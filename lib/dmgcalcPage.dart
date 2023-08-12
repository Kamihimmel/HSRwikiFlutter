import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
import 'relics/relic_manager.dart';

class DmgCalcPage extends StatefulWidget {

  const DmgCalcPage({super.key});

  @override
  State<DmgCalcPage> createState() => _DmgCalcPageState();
}

class _DmgCalcPageState extends State<DmgCalcPage> {
  final GlobalState _gs = GlobalState();
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;

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

    _initData("1005");
  }

  //get character data
  Character _cData = Character();
  bool isLoading = true;

  Future<void> _initData(String characterId) async {
    _cData = await CharacterManager.loadFromRemoteById(characterId);
    String lId = CharacterManager.getDefaultLightcone(characterId);
    await LightconeManager.loadFromRemoteById(lId);
    if (RelicManager.getRelicIds().isEmpty) {
      await RelicManager.initAllRelics();
    }
    CharacterStats? cs = null;
    final prefs = await SharedPreferences.getInstance();
    String? playerStr = await prefs.getString('playerinfo');
    if ((cs == null || cs.id == '') && playerStr != null) {
      Map<String, dynamic> jsonMap = jsonDecode(playerStr);
      cs = PlayerInfo.fromJson(jsonMap).characters.firstWhere((c) => c.id == characterId, orElse: () => CharacterStats.empty());
    }
    _gs.newCharacterStats();
    if (cs != null && cs.id != '') {
      _gs.stats = cs;
    } else {
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
    }
    setState(() {
      isLoading = false;
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

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(42, 41, 48, 1),
      ),
      child: Stack(
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isLoading
                          ? Colors.black.withOpacity(0.8)
                          : _cData.elementType.color.withOpacity(0.35),
                      Colors.black.withOpacity(0.8)
                    ]),
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
                          isLoading
                              ? const CircularProgressIndicator()
                              : Container(
                                  child: ResponsiveGridRow(
                                    children: [
                                      //ANCHOR:  CharacterPage
                                      ResponsiveGridCol(lg: 3,
                                        md: 6,
                                        xs: 12,
                                        sm: 12,
                                        child: CharacterBasic(
                                          isBannerAdReady: _isBannerAdReady,
                                          bannerAd: _bannerAd,
                                        )
                                      ),
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
                                  padding: const EdgeInsets.fromLTRB(
                                      25, 25, 110, 25),
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
                                            color:
                                                Color.fromARGB(125, 0, 0, 255),
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
