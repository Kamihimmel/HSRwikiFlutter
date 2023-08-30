import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

import 'ad_helper.dart';
import 'calculator/player_info.dart';
import 'characters/character.dart';
import 'characters/character_manager.dart';
import 'characters/character_stats.dart';
import 'components/basic_panel.dart';
import 'components/character_basic.dart';
import 'components/damage_panel.dart';
import 'components/global_state.dart';
import 'components/lightcone_relic.dart';
import 'lightcones/lightcone_manager.dart';
import 'relics/relic.dart';
import 'relics/relic_manager.dart';
import 'utils/helper.dart';

class DmgCalcPage extends StatefulWidget {
  final String characterId;

  const DmgCalcPage({required this.characterId, super.key});

  @override
  State<DmgCalcPage> createState() => _DmgCalcPageState();
}

class _DmgCalcPageState extends State<DmgCalcPage> {
  final GlobalState _gs = GlobalState();
  late bool _loading;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  late String cid;

  @override
  void initState() {
    super.initState();
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdReady = true;
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    ).load();

    cid = widget.characterId;
    _initData(widget.characterId);
  }

  //get character data
  Character _cData = Character();

  Future<void> _initData(String characterId) async {
    setState(() {
      cid = characterId;
      _loading = true;
    });
    _cData = await CharacterManager.loadFromRemoteById(characterId);
    String lId = CharacterManager.getDefaultLightcone(characterId);
    List<String> defaultRelicSet = CharacterManager.getDefaultRelicSets(characterId);
    CharacterStats? cs = null;
    final prefs = await SharedPreferences.getInstance();
    String? playerStr = await prefs.getString('playerinfo');
    if ((cs == null || cs.id == '') && playerStr != null) {
      Map<String, dynamic> jsonMap = jsonDecode(playerStr);
      cs = PlayerInfo.fromJson(jsonMap).characters.firstWhere((c) => c.id == characterId, orElse: () => CharacterStats.empty());
    }
    if (cs != null && cs.id != '') {
      _gs.stats = cs;
      if (_gs.stats.lightconeId == '') {
        _gs.stats.lightconeId = lId;
        _gs.stats.lightconeLevel = '80';
      }
      for (RelicPart rp in RelicPart.values) {
        if (!_gs.stats.relics.containsKey(rp) && rp != RelicPart.unknown) {
          _gs.stats.relics[rp] = RelicStats.empty(rp);
        }
      }
    } else {
      _gs.stats = CharacterStats.empty();
      _gs.stats.id = characterId;
      _gs.stats.level = '80';
      _gs.stats.lightconeId = lId;
      _gs.stats.lightconeLevel = '80';
      for (var s in _cData.entity.skilldata) {
        if (s.maxlevel == 0) {
          _gs.stats.skillLevels[s.id] = 0;
        } else {
          _gs.stats.skillLevels[s.id] = s.maxlevel > 10 ? 8 : 5;
        }
      }
      for (var t in _cData.entity.tracedata) {
        _gs.stats.traceLevels[t.id] = 1;
      }
      for (var rp in RelicPart.values) {
        if (rp == RelicPart.unknown) {
          continue;
        }
        _gs.stats.relics[rp] = RelicStats.empty(rp);
      }
    }
    await LightconeManager.loadFromRemoteById(_gs.stats.lightconeId);
    List<String> relicSets = _gs.stats.getRelicSets();
    for (var i = 0; i < 3; i++) {
      String rid = relicSets[i];
      if (rid == '') {
        rid = defaultRelicSet[i];
      }
      if (i == 0) {
        _gs.stats.relics[RelicPart.head]!.setId = rid;
        _gs.stats.relics[RelicPart.hands]!.setId = rid;
      } else if (i == 1) {
        _gs.stats.relics[RelicPart.body]!.setId = rid;
        _gs.stats.relics[RelicPart.feet]!.setId = rid;
      } else if (i == 2) {
        _gs.stats.relics[RelicPart.sphere]!.setId = rid;
        _gs.stats.relics[RelicPart.rope]!.setId = rid;
      }
      await RelicManager.loadFromRemoteById(rid);
    }
    setState(() {
      _loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
      xs: 600,
      sm: 905,
      md: 1440,
      lg: 1440,
    );
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final columnwidth = screenWidth > 1440
        ? screenWidth / 4
        : screenWidth > 905
            ? screenWidth / 2
            : screenWidth;

    String bgImageUrl = CharacterManager.getCharacter(cid).getImageLargeUrl(_gs);
    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(42, 41, 48, 1),
      ),
      child: Stack(
        children: [
          getImageComponent(bgImageUrl,
              placeholder: kTransparentImage, fit: BoxFit.cover, alignment: Alignment(0, -0.2), height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0.1, sigmaY: 0.1),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_loading ? Colors.grey.withOpacity(0.8) : Colors.black.withOpacity(0.01), Colors.black.withOpacity(0.8)]),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    "HSR Damage Calculator".tr(),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            height: _loading ? screenHeight : null,
                            child: _loading
                                ? Center(
                                    child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                                  )
                                : ResponsiveGridRow(
                                    children: [
                                      //ANCHOR:  CharacterPage
                                      ResponsiveGridCol(
                                          lg: 3,
                                          md: 6,
                                          xs: 12,
                                          sm: 12,
                                          child: CharacterBasic(
                                            isBannerAdReady: _isBannerAdReady,
                                            bannerAd: _bannerAd,
                                            switchCharacter: _initData,
                                          )),
                                      //ANCHOR - Lightcones and Relics
                                      ResponsiveGridCol(
                                        lg: 3,
                                        md: 6,
                                        xs: 12,
                                        sm: 12,
                                        child: LightconeRelic(
                                          isBannerAdReady: _isBannerAdReady,
                                          bannerAd: _bannerAd,
                                        ),
                                      ),
                                      //ANCHOR - Character Basic Panel
                                      ResponsiveGridCol(
                                        lg: 3,
                                        md: 6,
                                        xs: 12,
                                        sm: 12,
                                        child: BasicPanel(
                                          isBannerAdReady: _isBannerAdReady,
                                          bannerAd: _bannerAd,
                                        ),
                                      ),
                                      //ANCHOR - Damage Panel
                                      ResponsiveGridCol(
                                        lg: 3,
                                        md: 6,
                                        xs: 12,
                                        sm: 12,
                                        child: DamagePanel(
                                          isBannerAdReady: _isBannerAdReady,
                                          bannerAd: _bannerAd,
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                          Stack(
                            children: [
                              Hero(
                                tag: "damagecalc",
                                child: Container(
                                  width: columnwidth,
                                  height: 100,
                                  color: Colors.purple.withOpacity(0.6),
                                  child: Image(
                                    image: AssetImage('images/damagecalc.jpeg'),
                                    width: double.infinity,
                                    height: double.infinity,
                                    alignment: const Alignment(0.5, -0.25),
                                    filterQuality: FilterQuality.medium,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                alignment: Alignment(-1, 0),
                                height: 100,
                                width: columnwidth - 100,
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(25, 25, 110, 25),
                                  child: FittedBox(
                                    child: Text(
                                      "HSR Damage Calculator".tr(),
                                      style: const TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
                                        shadows: <Shadow>[
                                          Shadow(
                                            offset: Offset(10.0, 10.0),
                                            blurRadius: 3.0,
                                            color: Color.fromARGB(255, 0, 0, 0),
                                          ),
                                          Shadow(
                                            offset: Offset(10.0, 10.0),
                                            blurRadius: 8.0,
                                            color: Color.fromARGB(125, 0, 0, 255),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
