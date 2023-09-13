import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
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
import 'enemies/enemy.dart';
import 'lightcones/lightcone_manager.dart';
import 'relics/relic.dart';
import 'relics/relic_manager.dart';
import 'utils/helper.dart';
import 'utils/logging.dart';

class DmgCalcPage extends StatefulWidget {
  final String characterId;

  const DmgCalcPage({required this.characterId, super.key});

  @override
  State<DmgCalcPage> createState() => _DmgCalcPageState();
}

class _DmgCalcPageState extends State<DmgCalcPage> {
  final GlobalState _gs = GlobalState();
  bool _loading = true;
  BannerAd? _bannerAd;
  bool _isBannerAdReady = false;
  late String cid;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      if (!_loading) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('saved_stats', _gs.stats.toString());
        await prefs.setString('saved_enemy_stats', _gs.enemyStats.toString());
        String simpleJson = _gs.stats.toSimpleString();
        logger.d('Save character stats: ${simpleJson}');
      }
    });

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

  @override
  void dispose() {
    super.dispose();
    _bannerAd?.dispose();
    _timer?.cancel();
  }

  //get character data
  Character _cData = Character();

  Future<void> _initData(String characterId, {bool isSwitch = false, bool fromImport = false}) async {
    if (isSwitch || fromImport) {
      setState(() {
        _loading = true;
      });
    }
    String lId = CharacterManager.getDefaultLightcone(characterId);
    List<String> defaultRelicSet = CharacterManager.getDefaultRelicSets(characterId);
    CharacterStats? cs = null;
    if (isSwitch) {
      cs = _gs.stats;
      cs.id = characterId;
      cs.lightconeId = lId;
      cs.skillLevels = {};
      cs.traceLevels = {};
      cs.eidolons = {};
      cs.selfSkillEffect = {};
      cs.selfTraceEffect = {};
      cs.selfEidolonEffect = {};
      cs.lightconeEffect = {};
      cs.relicEffect = {};
    }
    if (cs == null) {
      cs = await loadSavedCharacterStats();
    }
    final prefs = await SharedPreferences.getInstance();
    String? playerStr = await prefs.getString('playerinfo');
    if (fromImport && playerStr != null) {
      Map<String, dynamic> jsonMap = jsonDecode(playerStr);
      cs = PlayerInfo.fromJson(jsonMap).characters.firstWhere((c) => c.id == characterId, orElse: () => CharacterStats.empty());
      cs.level = '80';
      cs.lightconeLevel = '80';
    }
    if (cs != null && cs.id != '') {
      _gs.stats = cs;
      if (_gs.stats.lightconeId == '') {
        _gs.stats.lightconeId = lId;
        _gs.stats.lightconeLevel = '80';
      }
    } else {
      _gs.stats.id = characterId;
      _gs.stats.level = '80';
      _gs.stats.lightconeId = lId;
      _gs.stats.lightconeLevel = '80';
    }
    setState(() {
      cid = _gs.stats.id;
    });
    _cData = await CharacterManager.loadFromRemoteById(_gs.stats.id);
    await LightconeManager.loadFromRemoteById(_gs.stats.lightconeId);
    _fillFields();
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
    EnemyStats? es = null;
    if (!isSwitch) {
      es = await loadSavedEnemyStats();
    }
    if (es != null) {
      _gs.enemyStats = es;
    }
    if (_gs.enemyStats.id == '') {
      _gs.enemyStats.id = '1253';
    }
    setState(() {
      _loading = false;
    });
  }

  void _fillFields() {
    for (var s in _cData.entity.skilldata) {
      if (_gs.stats.skillLevels.containsKey(s.id)) {
        continue;
      }
      if (s.maxlevel == 0) {
        _gs.stats.skillLevels[s.id] = 0;
      } else {
        _gs.stats.skillLevels[s.id] = s.maxlevel > 10 ? 8 : 5;
      }
    }
    for (var t in _cData.entity.tracedata) {
      if (t.maxlevel == 0) {
        _gs.stats.skillLevels[t.id] = 0;
      } else {
        _gs.stats.skillLevels[t.id] = t.maxlevel > 10 ? 8 : 5;
      }
      if (_gs.stats.traceLevels.containsKey(t.id)) {
        continue;
      }
      _gs.stats.traceLevels[t.id] = 1;
    }
    for (var e in _cData.entity.eidolon) {
      if (e.maxlevel == 0) {
        _gs.stats.skillLevels[e.id] = 0;
      } else {
        _gs.stats.skillLevels[e.id] = e.maxlevel > 10 ? 8 : 5;
      }
    }
    for (RelicPart rp in RelicPart.values) {
      if (!_gs.stats.relics.containsKey(rp) && rp != RelicPart.unknown) {
        _gs.stats.relics[rp] = RelicStats.empty(rp);
      }
    }
  }

  Future<CharacterStats?> loadSavedCharacterStats() async {
    final prefs = await SharedPreferences.getInstance();
    String saved = prefs.getString('saved_stats') ?? '';
    if (saved != '') {
      Map<String, dynamic> jsonMap = jsonDecode(saved);
      return CharacterStats.fromJson(jsonMap);
    }
    return null;
  }

  Future<EnemyStats?> loadSavedEnemyStats() async {
    final prefs = await SharedPreferences.getInstance();
    String saved = prefs.getString('saved_enemy_stats') ?? '';
    if (saved != '') {
      Map<String, dynamic> jsonMap = jsonDecode(saved);
      return EnemyStats.fromJson(jsonMap);
    }
    return null;
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
                            height: _loading || !_gs.loaded() ? screenHeight : null,
                            child: _loading || !_gs.loaded()
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
                                      //ANCHOR - Footer
                                      ResponsiveGridCol(
                                        lg: 12,
                                        md: 12,
                                        xs: 12,
                                        sm: 12,
                                        child: ChangeNotifierProvider.value(
                                          value: _gs,
                                          child: Consumer<GlobalState>(
                                            builder: (context, model, child) => Container(
                                              height: screenWidth > 905 ? 48 : null,
                                              color: Colors.black45,
                                              width: double.infinity,
                                              alignment: Alignment.centerRight,
                                              child: Column(mainAxisAlignment: MainAxisAlignment.end, crossAxisAlignment: CrossAxisAlignment.start, children: [
                                                Wrap(runSpacing: 10, alignment: WrapAlignment.start, crossAxisAlignment: WrapCrossAlignment.center, children: [
                                                  Container(
                                                    width: 300,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Stat scale'.tr(),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold,

                                                                ),
                                                          ),
                                                          Slider(
                                                            min: 1,
                                                            max: 10,
                                                            divisions: 9,
                                                            activeColor: Colors.grey,
                                                            inactiveColor: Colors.grey[200]!,
                                                            label: _gs.appConfig.statScale.toString(),
                                                            value: _gs.appConfig.statScale.toDouble(),
                                                            onChanged: (value) {
                                                              _gs.appConfig.statScale = value.toInt();
                                                              _gs.changeConfig();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 300,
                                                    child: FittedBox(
                                                      fit: BoxFit.scaleDown,
                                                      child: Row(
                                                        children: [
                                                          Text(
                                                            'Dmg scale'.tr(),
                                                            style: TextStyle(
                                                                //fontWeight: FontWeight.bold,

                                                                ),
                                                          ),
                                                          Slider(
                                                            min: 1,
                                                            max: 10,
                                                            divisions: 9,
                                                            activeColor: Colors.grey,
                                                            inactiveColor: Colors.grey[200]!,
                                                            label: _gs.appConfig.dmgScale.toString(),
                                                            value: _gs.appConfig.dmgScale.toDouble(),
                                                            onChanged: (value) {
                                                              _gs.appConfig.dmgScale = value.toInt();
                                                              _gs.changeConfig();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                              ]),
                                            ),
                                          )
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
