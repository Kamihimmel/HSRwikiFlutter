import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:transparent_image/transparent_image.dart';
import 'dart:async';

import '../ad_helper.dart';
import '../calculator/basic.dart';
import '../info.dart';
import '../lightcones/lightcone.dart';
import '../lightcones/lightcone_entity.dart';
import '../lightcones/lightcone_manager.dart';
import '../platformad_stub.dart' if (dart.library.io) '../platformad_stub.dart' if (dart.library.html) '../platformad.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';

/// 光锥详情
class LightconeDetailPage extends StatefulWidget {
  final Lightcone lightconeBasic;
  const LightconeDetailPage({super.key, required this.lightconeBasic});

  @override
  State<LightconeDetailPage> createState() => _LightconeDetailPageState();
}

class _LightconeDetailPageState extends State<LightconeDetailPage> {
  Lightcone lightconeData = Lightcone();
  bool isLoading = true;

  Color darkcolor = Colors.black;
  Color lightcolor = Colors.black;
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

  late PaletteGenerator _palette;
  bool _isLoading = true;
  bool _hasError = false;

  Future<void> _loadPalette(String url) async {
    try {
      _palette = await PaletteGenerator.fromImageProvider(getImageComponent(url));
      setState(() {
        _isLoading = false;
        darkcolor = _palette.darkMutedColor?.color ?? Colors.black;
        lightcolor = _palette.lightVibrantColor?.color ?? Colors.black;

        final hexCode = darkcolor.value.toRadixString(16).padLeft(8, '0');
        final directColor = '#${hexCode.substring(2)}';

        logger.i('Dark Color: $directColor');

        final directColor2 = '#${hexCode.substring(2)}';
        logger.i('Light Color: $directColor2');
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  late List<LightconeLeveldata> levelData;
  late List<LightconeSkilldata> skillData;
  late int attributeCount;
  late double _currentSliderValue;
  late List<double> levelnumbers;

  Future<void> _getData() async {
    lightconeData = await LightconeManager.loadFromRemote(widget.lightconeBasic);
    levelData = lightconeData.entity.leveldata;
    skillData = lightconeData.entity.skilldata;
    _currentSliderValue = levelData.length - 1.0;
    levelnumbers = List.generate(skillData.length, (index) => 5);
    attributeCount = levelData.length;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String lid = ModalRoute.of(context)!.settings.arguments as String;
    final routeLightcone = LightconeManager.getLightcone(lid);
    logger.i("navigate to lightcone: $lid");
    if (darkcolor == Colors.black && lightcolor == Colors.black) {
      _loadPalette(routeLightcone.entity.imageurl);
    }

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

    const raritytocolor = {
      '5': Colors.amber,
      '4': Colors.deepPurpleAccent,
      '3': Colors.blueAccent,
    };

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: const BoxDecoration(
        color: Color.fromRGBO(42, 41, 48, 1),
      ),
      child: Stack(
        children: [
          getImageComponent(
              routeLightcone.entity.imagelargeurl,
              placeholder: kTransparentImage,
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              decoration: BoxDecoration(
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(0.3), darkcolor.withOpacity(0.8)]),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(routeLightcone.getName(getLanguageCode(context))),
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
                                        lg: 9,
                                        md: 6,
                                        xs: 12,
                                        sm: 12,
                                        child: Container(
                                          height: screenWidth > 905 ? screenHeight - 100 : null,
                                          child: Column(
                                            children: [
                                              const SizedBox(
                                                height: 110,
                                              ),
                                              if (screenWidth > 905)
                                                Expanded(
                                                  child: getImageComponent(lightconeData.entity.imagelargeurl, imageWrap: true),
                                                ),
                                              if (screenWidth < 905)
                                                Container(
                                                  margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                  decoration: BoxDecoration(
                                                    borderRadius: const BorderRadius.all(Radius.circular(0)),
                                                    border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                    gradient:
                                                        LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(0.7), Colors.black.withOpacity(0.9)]),
                                                  ),
                                                  child: getImageComponent(
                                                    lightconeData.entity.imagelargeurl,
                                                    placeholder: kTransparentImage,
                                                    fit: BoxFit.cover,
                                                    height: MediaQuery.of(context).size.width / 867 * 1230,
                                                    width: MediaQuery.of(context).size.width),
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
                                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                              child: Column(children: [
                                                if (screenWidth > 905)
                                                  const SizedBox(
                                                    height: 100,
                                                  ),
                                                if (screenWidth > 905)
                                                  Padding(
                                                    padding: const EdgeInsets.all(25.0),
                                                    child: Text(
                                                      routeLightcone.getName(getLanguageCode(context)),
                                                      style: const TextStyle(
                                                        //fontWeight: FontWeight.bold,
                                                        color: Colors.white,
                                                        fontSize: 50,
                                                        fontWeight: FontWeight.bold,
                                                        height: 1,
                                                      ),
                                                    ),
                                                  ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [
                                                    Flexible(
                                                      child: Padding(
                                                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
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
                                                                    begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                              ),
                                                              child: Row(
                                                                mainAxisAlignment: MainAxisAlignment.center,
                                                                children: [
                                                                  getImageComponent(lightconeData.pathType.icon, imageWrap: true, width: 50),
                                                                  Text(
                                                                    lightconeData.pathType.key,
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
                                                              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
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
                                                                      activeColor: raritytocolor[lightconeData.entity.rarity],
                                                                      inactiveColor: raritytocolor[lightconeData.entity.rarity]?.withOpacity(0.5),
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
                                                              padding: const EdgeInsets.fromLTRB(30, 5, 30, 20),
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
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
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

                                                    String detailtext = lightconeData.getSkillDescription(index, getLanguageCode(context));
                                                    if (data.maxlevel > 0) {
                                                      List<Map<String, dynamic>> multiplierData = data.levelmultiplier;

                                                      int multicount = multiplierData.length;
                                                      fixedtext = detailtext;

                                                      for (var i = multicount; i >= 1; i--) {
                                                        Map<String, dynamic> currentleveldata = multiplierData[i - 1];
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
                                                                        begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child: Padding(
                                                                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                                                          child: Column(
                                                                            children: [
                                                                              Text(
                                                                                lightconeData.getSkillName(index, getLanguageCode(context)),
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
                                                                                          max: data.maxlevel.toDouble(),
                                                                                          divisions: data.maxlevel - 1,
                                                                                          activeColor: raritytocolor[lightconeData.entity.rarity],
                                                                                          inactiveColor: raritytocolor[lightconeData.entity.rarity]?.withOpacity(0.5),
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
                                                                                            : (('lang'.tr() == 'cn')
                                                                                                ? data.effect[index2].referencetargetCN
                                                                                                : data.effect[index2].referencetargetJP),
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
                                tag: routeLightcone.entity.imageurl,
                                child: Container(
                                  width: columnwidth,
                                  height: 100,
                                  color: darkcolor.withOpacity(0.6),
                                  child: getImageComponent(routeLightcone.entity.imageurl, imageWrap: true, fit: BoxFit.none, alignment: const Alignment(1, -0.5)),
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
                                      routeLightcone.getName(getLanguageCode(context)),
                                      style: const TextStyle(
                                        //fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 50,
                                        fontWeight: FontWeight.bold,
                                        height: 1,
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
