import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'dart:async';
import 'package:transparent_image/transparent_image.dart';
import '../ad_helper.dart';
import '../calculator/basic.dart';
import '../characters/character.dart';
import '../characters/character_entity.dart';
import '../characters/character_manager.dart';
import '../info.dart';
import '../platformad_stub.dart' if (dart.library.io) '../platformad_stub.dart' if (dart.library.html) '../platformad.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'global_state.dart';

/// 角色详情
class CharacterDetailPage extends StatefulWidget {
  final Character characterBasic;

  const CharacterDetailPage({super.key, required this.characterBasic});

  @override
  State<CharacterDetailPage> createState() => _CharacterDetailPageState();
}

class _CharacterDetailPageState extends State<CharacterDetailPage> {
  final GlobalState _gs = GlobalState();
  Character characterData = Character();
  bool isLoading = true;

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
          logger.e('Failed to load a banner ad: ${err.message}');
          _isBannerAdReady = false;
          ad.dispose();
        },
      ),
    ).load();

    _getData();
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  late List<CharacterLeveldata> levelData;
  late List<CharacterSkilldata> skillData;
  late List<CharacterTracedata> traceData;
  late List<CharacterEidolon> eidolonData;
  late int attributeCount;
  late double _currentSliderValue;
  late List<double> levelnumbers;

  Future<void> _getData() async {
    characterData = await CharacterManager.loadFromRemote(widget.characterBasic);
    levelData = characterData.entity.leveldata;
    skillData = characterData.entity.skilldata;
    traceData = characterData.entity.tracedata;
    eidolonData = characterData.entity.eidolon;
    _currentSliderValue = levelData.length - 1.0;
    levelnumbers = List.generate(skillData.length, (index) => 8);
    attributeCount = levelData.length;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String cid = ModalRoute.of(context)!.settings.arguments as String;
    final Character routeCharacter = CharacterManager.getCharacter(cid);
    logger.i("navigate to character: $cid");
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final columnwidth = screenWidth > 1440
        ? screenWidth / 4
        : screenWidth > 905
            ? screenWidth / 2
            : screenWidth;

    ResponsiveGridBreakpoints.value = ResponsiveGridBreakpoints(
      xs: 600,
      sm: 905,
      md: 1440,
      lg: 1440,
    );

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(42, 41, 48, 1),
      ),
      child: Stack(
        children: [
          getImageComponent(routeCharacter.getImageLargeUrl(_gs),
              placeholder: kTransparentImage, fit: BoxFit.fitHeight, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width),
          Scaffold(
            backgroundColor: Colors.black.withOpacity(0.1),
            appBar: AppBar(
              title: Text(routeCharacter.getName(getLanguageCode(context))),
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
                                  ResponsiveGridCol(
                                    lg: 3,
                                    md: 6,
                                    xs: 12,
                                    sm: 12,
                                    child: Container(
                                      height: screenWidth > 905 ? screenHeight - 100 : null,
                                      child: Column(
                                        children: [
                                          const SizedBox(
                                            height: 100,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                            children: [
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(10, 10, 5, 0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                          border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                              colors: [routeCharacter.elementType.color.withOpacity(0.35), routeCharacter.elementType.color.withOpacity(0.5)]),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            getImageComponent(characterData.elementType.icon, imageWrap: true, width: 50),
                                                            Text(
                                                              characterData.elementType.key,
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 25,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1,
                                                              ),
                                                            ).tr(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(5, 10, 10, 0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration: const BoxDecoration(
                                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration: BoxDecoration(
                                                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                          border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment.topLeft,
                                                              end: Alignment.bottomRight,
                                                              colors: [routeCharacter.elementType.color.withOpacity(0.35), routeCharacter.elementType.color.withOpacity(0.5)]),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            getImageComponent(characterData.pathType.icon, imageWrap: true, width: 50),
                                                            Text(
                                                              characterData.pathType.key,
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 25,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1,
                                                              ),
                                                            ).tr(),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                              ),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                    gradient: LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors: [routeCharacter.elementType.color.withOpacity(0.35), routeCharacter.elementType.color.withOpacity(0.5)]),
                                                  ),
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: 100,
                                                              child: Text(
                                                                "LV:${levelData[_currentSliderValue.toInt()].level}",
                                                                style: const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                  fontSize: 30,
                                                                  fontWeight: FontWeight.bold,
                                                                  height: 1.1,
                                                                ),
                                                              ),
                                                            ),
                                                            Expanded(
                                                              child: Slider(
                                                                value: _currentSliderValue,
                                                                min: 0,
                                                                max: (attributeCount - 1).toDouble(),
                                                                divisions: attributeCount - 1,
                                                                activeColor: routeCharacter.elementType.color,
                                                                inactiveColor: routeCharacter.elementType.color.withOpacity(0.5),
                                                                onChanged: (double value) {
                                                                  setState(() {
                                                                    _currentSliderValue = value;
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                ImageIcon(getImageComponent(FightProp.maxHP.icon), size: 40),
                                                                Text(
                                                                  "HP".tr(),
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              levelData[_currentSliderValue.toInt()].hp.toStringAsFixed(0),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                ImageIcon(getImageComponent(FightProp.attack.icon), size: 40),
                                                                Text(
                                                                  "ATK".tr(),
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              levelData[_currentSliderValue.toInt()].atk.toStringAsFixed(0),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                ImageIcon(getImageComponent(FightProp.defence.icon), size: 40),
                                                                Text(
                                                                  "DEF".tr(),
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              levelData[_currentSliderValue.toInt()].def.toStringAsFixed(0),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                ImageIcon(getImageComponent(FightProp.speed.icon), size: 40),
                                                                Text(
                                                                  "${"Basic".tr()}${"Speed".tr()}",
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              characterData.entity.dspeed.toString(),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 5),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                ImageIcon(getImageComponent(FightProp.aggro.icon), size: 40),
                                                                Text(
                                                                  "${"Basic".tr()}${"Taunt".tr()}",
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              characterData.entity.dtaunt.toString(),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(30, 5, 30, 10),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                ImageIcon(getImageComponent(FightProp.maxSP.icon), size: 40),
                                                                Text(
                                                                  "${"Basic".tr()}${"Energy Limit".tr()}",
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 30,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              characterData.entity.maxenergy.toString(),
                                                              style: const TextStyle(
                                                                //fontWeight: FontWeight.bold,
                                                                color: Colors.white,
                                                                fontSize: 30,
                                                                fontWeight: FontWeight.bold,
                                                                height: 1.1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          if (screenWidth > 905) Expanded(child: getImageComponent(characterData.getImageLargeUrl(_gs), imageWrap: true)),
                                          if (screenWidth < 905)
                                            Container(
                                              clipBehavior: Clip.hardEdge,
                                              decoration: const BoxDecoration(
                                                borderRadius: BorderRadius.all(Radius.circular(15)),
                                              ),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                child: Container(
                                                    margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                    decoration: BoxDecoration(
                                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                      border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                      gradient:
                                                          LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.black.withOpacity(0.7), Colors.black.withOpacity(0.9)]),
                                                    ),
                                                    child: getImageComponent(characterData.getImageLargeUrl(_gs),
                                                        placeholder: kTransparentImage, height: MediaQuery.of(context).size.height, width: MediaQuery.of(context).size.width)),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  //ANCHOR - Skilldata
                                  ResponsiveGridCol(
                                    lg: 3,
                                    md: 6,
                                    xs: 12,
                                    sm: 12,
                                    child: Container(
                                      height: screenWidth > 905 ? screenHeight - 100 : null,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                                          child: Column(children: [
                                            Text(
                                              "Skill".tr(),
                                              style: const TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(skillData.length, (index) {
                                                final data = skillData[index];
                                                String fixedtext = "";
                                                String detailtext = characterData.getSkillDescription(index, getLanguageCode(context));
                                                if (data.maxlevel > 0) {
                                                  List<Map<String, double>> multiplierData = data.levelmultiplier.map((e) {
                                                    Map<String, double> m = {};
                                                    for (var entry in e.entries) {
                                                      m[entry.key] = num.tryParse(entry.value.toString())?.toDouble() ?? 0;
                                                    }
                                                    return m;
                                                  }).toList();
                                                  int multicount = multiplierData.length;
                                                  fixedtext = detailtext;
                                                  for (var i = multicount; i >= 1; i--) {
                                                    Map<String, double> currentleveldata = multiplierData[i - 1];
                                                    String levelnum = (levelnumbers[index].toStringAsFixed(0));
                                                    if (currentleveldata['default'] == null) {
                                                      fixedtext = fixedtext.replaceAll("[$i]", (currentleveldata[levelnum]).toString());
                                                    } else {
                                                      fixedtext = fixedtext.replaceAll("[$i]", (currentleveldata['default']).toString());
                                                    }
                                                  }
                                                } else {
                                                  fixedtext = detailtext;
                                                }

                                                return Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: double.infinity,
                                                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                          clipBehavior: Clip.hardEdge,
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                          ),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: (data.effect.isNotEmpty)
                                                                    ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                                                                    : const BorderRadius.all(Radius.circular(15)),
                                                                border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                                gradient: LinearGradient(
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                    colors: [routeCharacter.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    child: getImageComponent(data.imageurl, imageWrap: true, width: 100),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                                                      child: Column(
                                                                        children: [
                                                                          Text(
                                                                            characterData.getSkillName(index, getLanguageCode(context)),
                                                                            style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            fixedtext,
                                                                            style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15,
                                                                            ),
                                                                            maxLines: 10,
                                                                          ),
                                                                          if (data.maxlevel > 0)
                                                                            Padding(
                                                                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                              child: Row(
                                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                children: [
                                                                                  SizedBox(
                                                                                    child: Text(
                                                                                      "LV:${levelnumbers[index].toInt()}",
                                                                                      style: const TextStyle(
                                                                                        //fontWeight: FontWeight.bold,
                                                                                        color: Colors.white,
                                                                                        fontSize: 20,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        height: 1.1,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  Expanded(
                                                                                    child: Slider(
                                                                                      value: levelnumbers[index],
                                                                                      min: 1,
                                                                                      max: (data.maxlevel).toDouble(),
                                                                                      divisions: data.maxlevel - 1,
                                                                                      activeColor: routeCharacter.elementType.color,
                                                                                      inactiveColor: routeCharacter.elementType.color.withOpacity(0.5),
                                                                                      onChanged: (double value) {
                                                                                        setState(() {
                                                                                          levelnumbers[index] = value;
                                                                                        });
                                                                                      },
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (data.effect.isNotEmpty)
                                                          Container(
                                                            width: double.infinity,
                                                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black.withOpacity(0.8),
                                                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                            ),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: List.generate(data.effect.length, (index2) {
                                                                String levelmulti = "";

                                                                if (data.levelmultiplier.isNotEmpty) {
                                                                  Map<String, dynamic> leveldata2 = (data.levelmultiplier[data.effect[index2].multiplier.toInt() - 1]);
                                                                  String levelnum2 = (levelnumbers[index].toStringAsFixed(0));

                                                                  if (leveldata2['default'] == null) {
                                                                    levelmulti = leveldata2[levelnum2].toString();
                                                                  } else {
                                                                    levelmulti = leveldata2['default'].toString();
                                                                  }
                                                                } else {
                                                                  levelmulti = data.effect[index2].multiplier.toString();
                                                                }

                                                                return SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Scrollbar(
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.amber,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Text(data.effect[index2].type,
                                                                                  style: const TextStyle(
                                                                                    //fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    height: 1.1,
                                                                                  )).tr()),
                                                                          if (data.effect[index2].referencetarget != '')
                                                                            Container(
                                                                                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.amber,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Text(
                                                                                    ('lang'.tr() == 'en')
                                                                                        ? data.effect[index2].referencetargetEN
                                                                                        : (('lang'.tr() == 'cn') ? data.effect[index2].referencetargetCN : data.effect[index2].referencetargetJP),
                                                                                    style: const TextStyle(
                                                                                      //fontWeight: FontWeight.bold,
                                                                                      color: Colors.black,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      height: 1.1,
                                                                                    ))),
                                                                          if (data.effect[index2].multipliertarget != '')
                                                                            Container(
                                                                                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: typetocolor[(data.effect[index2].type)],
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Text(
                                                                                    '${(data.effect[index2].multipliertarget).tr()}$levelmulti${((data.effect[index2].multipliertarget) != '') ? "%" : ""}',
                                                                                    style: const TextStyle(
                                                                                      //fontWeight: FontWeight.bold,
                                                                                      color: Colors.black,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      height: 1.1,
                                                                                    ))),
                                                                          if (data.effect[index2].addtarget != '')
                                                                            Container(
                                                                                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.greenAccent,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Text(
                                                                                    '${(data.effect[index2].addtarget).tr()}$levelmulti${((data.effect[index2].addtarget) != 'energy') && ((data.effect[index2].addtarget) != 'speedpt') ? "%" : ""}',
                                                                                    style: const TextStyle(
                                                                                      //fontWeight: FontWeight.bold,
                                                                                      color: Colors.black,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      height: 1.1,
                                                                                    ))),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                          children: List.generate(data.effect[index2].tag.length, (index3) {
                                                                        List<dynamic> taglist = data.effect[index2].tag;

                                                                        return Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(taglist[index3],
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                )).tr());
                                                                      })),
                                                                    ]),
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      top: 10,
                                                      left: 10,
                                                      child: Container(
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                          color: routeCharacter.elementType.color.withOpacity(0.3),
                                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                        ),
                                                        child: Center(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(data.stype,
                                                                style: const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  height: 1.1,
                                                                )).tr(),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    if (data.energy > 0)
                                                      Positioned(
                                                        top: 10,
                                                        right: 130,
                                                        child: Container(
                                                          width: 80,
                                                          decoration: BoxDecoration(
                                                            color: routeCharacter.elementType.color.withOpacity(0.3),
                                                            borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  ImageIcon(getImageComponent(FightProp.maxSP.icon), size: 15),
                                                                  Text('${data.energy}',
                                                                      style: const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors.white,

                                                                        fontSize: 18,
                                                                        fontWeight: FontWeight.bold,
                                                                        height: 1.1,
                                                                      )),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    Positioned(
                                                      top: 10,
                                                      right: 10,
                                                      child: Container(
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                          color: routeCharacter.elementType.color.withOpacity(0.3),
                                                          borderRadius: const BorderRadius.only(topRight: Radius.circular(15), bottomLeft: Radius.circular(15)),
                                                        ),
                                                        child: Center(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              children: [
                                                                ImageIcon(getImageComponent(FightProp.breakDamageAddedRatio.icon), size: 15),
                                                                Text('${data.weaknessbreak}',
                                                                    style: const TextStyle(
                                                                      //fontWeight: FontWeight.bold,
                                                                      color: Colors.white,

                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.bold,
                                                                      height: 1.1,
                                                                    )),
                                                                const SizedBox(
                                                                  width: 10,
                                                                ),
                                                                ImageIcon(getImageComponent(FightProp.sPRatio.icon), size: 15),
                                                                Text('${data.energyregen}',
                                                                    style: const TextStyle(
                                                                      //fontWeight: FontWeight.bold,
                                                                      color: Colors.white,

                                                                      fontSize: 18,
                                                                      fontWeight: FontWeight.bold,
                                                                      height: 1.1,
                                                                    )),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //ANCHOR - Tracedata
                                  ResponsiveGridCol(
                                    lg: 3,
                                    md: 6,
                                    xs: 12,
                                    sm: 12,
                                    child: Container(
                                      height: screenWidth > 905 ? screenHeight - 100 : null,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                                          child: Column(children: [
                                            Text(
                                              "Trace".tr(),
                                              style: const TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(traceData.length, (index) {
                                                final data = traceData[index];
                                                String detailtext = characterData.getTraceDescription(index, getLanguageCode(context));
                                                if (!data.tiny) {
                                                  return Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          Container(
                                                            width: double.infinity,
                                                            margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                            clipBehavior: Clip.hardEdge,
                                                            decoration: const BoxDecoration(
                                                              borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                            ),
                                                            child: BackdropFilter(
                                                              filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                              child: Container(
                                                                decoration: BoxDecoration(
                                                                  borderRadius: (data.effect.isNotEmpty)
                                                                      ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                                                                      : const BorderRadius.all(Radius.circular(15)),
                                                                  border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                                  gradient: LinearGradient(
                                                                      begin: Alignment.topLeft,
                                                                      end: Alignment.bottomRight,
                                                                      colors: [routeCharacter.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Container(
                                                                      margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                      child: getImageComponent(data.imageurl, imageWrap: true, width: 100),
                                                                    ),
                                                                    Expanded(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.all(8.0),
                                                                        child: Column(
                                                                          children: [
                                                                            Text(
                                                                              characterData.getTraceName(index, getLanguageCode(context)),
                                                                              style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontSize: 20,
                                                                              ),
                                                                            ),
                                                                            Text(
                                                                              detailtext,
                                                                              style: const TextStyle(
                                                                                color: Colors.white,
                                                                                fontSize: 15,
                                                                              ),
                                                                              maxLines: 10,
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          if (data.effect.isNotEmpty)
                                                            Container(
                                                              width: double.infinity,
                                                              margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                              decoration: BoxDecoration(
                                                                color: Colors.black.withOpacity(0.8),
                                                                borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                              ),
                                                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                              child: Column(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: List.generate(data.effect.length, (index2) {
                                                                  return SingleChildScrollView(
                                                                    scrollDirection: Axis.horizontal,
                                                                    child: Scrollbar(
                                                                      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.amber,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Text(data.effect[index2].type,
                                                                                    style: const TextStyle(
                                                                                      //fontWeight: FontWeight.bold,
                                                                                      color: Colors.black,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      height: 1.1,
                                                                                    )).tr()),
                                                                            if (data.effect[index2].multipliertarget != '')
                                                                              Container(
                                                                                  margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                  decoration: BoxDecoration(
                                                                                    color: typetocolor[(data.effect[index2].type)],
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Text('${(data.effect[index2].multipliertarget).tr()}${data.effect[index2].multiplier}%',
                                                                                      style: const TextStyle(
                                                                                        //fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        height: 1.1,
                                                                                      ))),
                                                                            if (data.effect[index2].addtarget != '')
                                                                              Container(
                                                                                  margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                  padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                  decoration: BoxDecoration(
                                                                                    color: Colors.greenAccent,
                                                                                    borderRadius: BorderRadius.circular(5),
                                                                                  ),
                                                                                  child: Text(
                                                                                      '${(data.effect[index2].addtarget).tr()}${data.effect[index2].multiplier}${((data.effect[index2].addtarget) != 'energy') ? "%" : ""}',
                                                                                      style: const TextStyle(
                                                                                        //fontWeight: FontWeight.bold,
                                                                                        color: Colors.black,
                                                                                        fontSize: 15,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        height: 1.1,
                                                                                      ))),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                            children: List.generate(data.effect[index2].tag.length, (index3) {
                                                                          List<dynamic> taglist = data.effect[index2].tag;

                                                                          return Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.white,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Text(taglist[index3],
                                                                                  style: const TextStyle(
                                                                                    //fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    height: 1.1,
                                                                                  )).tr());
                                                                        })),
                                                                      ]),
                                                                    ),
                                                                  );
                                                                }),
                                                              ),
                                                            ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      ),
                                                      Positioned(
                                                        top: 10,
                                                        left: 10,
                                                        child: Container(
                                                          width: 110,
                                                          decoration: BoxDecoration(
                                                            color: routeCharacter.elementType.color.withOpacity(0.3),
                                                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                          ),
                                                          child: Center(
                                                            child: Padding(
                                                              padding: const EdgeInsets.all(2.0),
                                                              child: Text(data.stype,
                                                                  style: const TextStyle(
                                                                    //fontWeight: FontWeight.bold,
                                                                    color: Colors.white,
                                                                    fontSize: 18,
                                                                    fontWeight: FontWeight.bold,
                                                                    height: 1.1,
                                                                  )).tr(),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                } else {
                                                  return Column(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.8),
                                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                        ),
                                                        child: Row(
                                                          children: [
                                                            Padding(
                                                              padding: const EdgeInsets.all(8.0),
                                                              child: ImageIcon(getImageComponent(FightProp.fromEffectKey(data.ttype).icon), size: 40),
                                                            ),
                                                            Expanded(
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Column(
                                                                  children: [
                                                                    Text(
                                                                      characterData.getTraceName(index, getLanguageCode(context)),
                                                                      style: const TextStyle(
                                                                        color: Colors.white,
                                                                        fontWeight: FontWeight.bold,
                                                                        fontSize: 20,
                                                                      ),
                                                                    ),
                                                                    Text(
                                                                      detailtext,
                                                                      style: const TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 15,
                                                                      ),
                                                                      maxLines: 10,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (data.effect.isNotEmpty)
                                                        Container(
                                                          width: double.infinity,
                                                          margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          decoration: BoxDecoration(
                                                            color: Colors.black.withOpacity(0.8),
                                                            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                          ),
                                                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: List.generate(data.effect.length, (index2) {
                                                              return SingleChildScrollView(
                                                                scrollDirection: Axis.horizontal,
                                                                child: Scrollbar(
                                                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                    Row(
                                                                      children: [
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.amber,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(data.effect[index2].type,
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                )).tr()),
                                                                        if (data.effect[index2].multipliertarget != '')
                                                                          Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.redAccent,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Text('${(data.effect[index2].multipliertarget).tr()}${data.effect[index2].multiplier}%',
                                                                                  style: const TextStyle(
                                                                                    //fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    height: 1.1,
                                                                                  ))),
                                                                        if (data.effect[index2].addtarget != '')
                                                                          Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.greenAccent,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Text('${(data.effect[index2].addtarget).tr()}${data.effect[index2].multiplier}%',
                                                                                  style: const TextStyle(
                                                                                    //fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    height: 1.1,
                                                                                  ))),
                                                                      ],
                                                                    ),
                                                                    Row(
                                                                        children: List.generate(data.effect[index2].tag.length, (index3) {
                                                                      List<dynamic> taglist = data.effect[index2].tag;

                                                                      return Container(
                                                                          margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                          padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                          decoration: BoxDecoration(
                                                                            color: Colors.white,
                                                                            borderRadius: BorderRadius.circular(5),
                                                                          ),
                                                                          child: Text(taglist[index3],
                                                                              style: const TextStyle(
                                                                                //fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                height: 1.1,
                                                                              )).tr());
                                                                    })),
                                                                  ]),
                                                                ),
                                                              );
                                                            }),
                                                          ),
                                                        ),
                                                      const SizedBox(
                                                        height: 10,
                                                      ),
                                                    ],
                                                  );
                                                }
                                              }),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                  //ANCHOR - eidolondata
                                  ResponsiveGridCol(
                                    lg: 3,
                                    md: 6,
                                    xs: 12,
                                    sm: 12,
                                    child: Container(
                                      height: screenWidth > 905 ? screenHeight - 100 : null,
                                      child: SingleChildScrollView(
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                                          child: Column(children: [
                                            Text(
                                              "Eidolon".tr(),
                                              style: const TextStyle(
                                                //fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                            Column(
                                              children: List.generate(eidolonData.length, (index) {
                                                final data = eidolonData[index];
                                                String fixedtext = characterData.getEidolonDescription(index, getLanguageCode(context));
                                                return Stack(
                                                  children: [
                                                    Column(
                                                      children: [
                                                        Container(
                                                          width: double.infinity,
                                                          margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                                                          clipBehavior: Clip.hardEdge,
                                                          decoration: const BoxDecoration(
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                                                          ),
                                                          child: BackdropFilter(
                                                            filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                                                            child: Container(
                                                              decoration: BoxDecoration(
                                                                borderRadius: (data.effect.isNotEmpty)
                                                                    ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                                                                    : const BorderRadius.all(Radius.circular(15)),
                                                                border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                                gradient: LinearGradient(
                                                                    begin: Alignment.topLeft,
                                                                    end: Alignment.bottomRight,
                                                                    colors: [routeCharacter.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                              ),
                                                              child: Row(
                                                                children: [
                                                                  Container(
                                                                    margin: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                                                    child: getImageComponent(data.imageurl, imageWrap: true, width: 100),
                                                                  ),
                                                                  Expanded(
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.all(8.0),
                                                                      child: Column(
                                                                        children: [
                                                                          Text(
                                                                            characterData.getEidolonName(index, getLanguageCode(context)),
                                                                            style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.bold,
                                                                              fontSize: 20,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            fixedtext,
                                                                            style: const TextStyle(
                                                                              color: Colors.white,
                                                                              fontSize: 15,
                                                                            ),
                                                                            maxLines: 10,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        if (data.effect.isNotEmpty)
                                                          Container(
                                                            width: double.infinity,
                                                            margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                            decoration: BoxDecoration(
                                                              color: Colors.black.withOpacity(0.8),
                                                              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                            ),
                                                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                            child: Column(
                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: List.generate(data.effect.length, (index2) {
                                                                String levelmulti = "";

                                                                levelmulti = (data.effect[index2].multiplier).toString();

                                                                return SingleChildScrollView(
                                                                  scrollDirection: Axis.horizontal,
                                                                  child: Scrollbar(
                                                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                                      Row(
                                                                        children: [
                                                                          Container(
                                                                              margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                              padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                              decoration: BoxDecoration(
                                                                                color: Colors.amber,
                                                                                borderRadius: BorderRadius.circular(5),
                                                                              ),
                                                                              child: Text(data.effect[index2].type,
                                                                                  style: const TextStyle(
                                                                                    //fontWeight: FontWeight.bold,
                                                                                    color: Colors.black,
                                                                                    fontSize: 15,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    height: 1.1,
                                                                                  )).tr()),
                                                                          if (data.effect[index2].multipliertarget != '')
                                                                            Container(
                                                                                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: typetocolor[(data.effect[index2].type)],
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Text(
                                                                                    '${(data.effect[index2].multipliertarget).tr()}$levelmulti${((data.effect[index2].multipliertarget) != '') && (data.effect[index2].multiplier != '') ? "%" : ""}',
                                                                                    style: const TextStyle(
                                                                                      //fontWeight: FontWeight.bold,
                                                                                      color: Colors.black,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      height: 1.1,
                                                                                    ))),
                                                                          if (data.effect[index2].addtarget != '')
                                                                            Container(
                                                                                margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                                padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                                decoration: BoxDecoration(
                                                                                  color: Colors.greenAccent,
                                                                                  borderRadius: BorderRadius.circular(5),
                                                                                ),
                                                                                child: Text(
                                                                                    '${(data.effect[index2].addtarget).tr()}$levelmulti${((data.effect[index2].addtarget) != 'energy') ? "%" : ""}',
                                                                                    style: const TextStyle(
                                                                                      //fontWeight: FontWeight.bold,
                                                                                      color: Colors.black,
                                                                                      fontSize: 15,
                                                                                      fontWeight: FontWeight.bold,
                                                                                      height: 1.1,
                                                                                    ))),
                                                                        ],
                                                                      ),
                                                                      Row(
                                                                          children: List.generate(data.effect[index2].tag.length, (index3) {
                                                                        List<dynamic> taglist = data.effect[index2].tag;

                                                                        return Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.white,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(taglist[index3],
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                )).tr());
                                                                      })),
                                                                    ]),
                                                                  ),
                                                                );
                                                              }),
                                                            ),
                                                          ),
                                                        const SizedBox(
                                                          height: 10,
                                                        ),
                                                      ],
                                                    ),
                                                    Positioned(
                                                      top: 10,
                                                      left: 10,
                                                      child: Container(
                                                        width: 110,
                                                        decoration: BoxDecoration(
                                                          color: routeCharacter.elementType.color.withOpacity(0.3),
                                                          borderRadius: const BorderRadius.only(topLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                        ),
                                                        child: Center(
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(2.0),
                                                            child: Text(data.stype.tr() + data.eidolonnum.toString(),
                                                                style: const TextStyle(
                                                                  //fontWeight: FontWeight.bold,
                                                                  color: Colors.white,
                                                                  fontSize: 18,
                                                                  fontWeight: FontWeight.bold,
                                                                  height: 1.1,
                                                                )),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              }),
                                            ),
                                            adsenseAdsView(columnwidth - 20),
                                            if (_isBannerAdReady)
                                              Container(
                                                width: _bannerAd!.size.width.toDouble(),
                                                height: _bannerAd!.size.height.toDouble(),
                                                child: AdWidget(ad: _bannerAd!),
                                              ),
                                          ]),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                      Stack(
                        children: [
                          Hero(
                            tag: routeCharacter.getImageUrl(_gs),
                            child: Container(
                              width: columnwidth,
                              height: 100,
                              color: routeCharacter.elementType.color.withOpacity(0.6),
                              child: getImageComponent(routeCharacter.getImageUrl(_gs), imageWrap: true, fit: BoxFit.none, alignment: const Alignment(1, -0.5)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(25.0),
                            child: Text(
                              routeCharacter.getName(getLanguageCode(context)),
                              style: const TextStyle(
                                //fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                height: 1,
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
        ],
      ),
    );
  }
}
