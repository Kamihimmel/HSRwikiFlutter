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
import '../calculator/effect.dart';
import '../calculator/effect_entity.dart';
import '../info.dart';
import '../platformad_stub.dart' if (dart.library.io) '../platformad_stub.dart' if (dart.library.html) '../platformad.dart';
import '../relics/relic.dart';
import '../relics/relic_entity.dart';
import '../relics/relic_manager.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';

class RelicDetailPage extends StatefulWidget {
  final Relic basicRelic;

  const RelicDetailPage({super.key, required this.basicRelic});

  @override
  State<RelicDetailPage> createState() => _RelicDetailPageState();
}

class _RelicDetailPageState extends State<RelicDetailPage> {
  Relic relicData = Relic();
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

        final directColor3 = '#${hexCode.substring(2)}';
        logger.i('Black Color: $directColor3');
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  late List<RelicSkilldata> skillData;
  late int attributeCount;

  Future<void> _getData() async {
    relicData = await RelicManager.loadFromRemote(widget.basicRelic);
    skillData = relicData.entity.skilldata;
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final String cid = ModalRoute.of(context)!.settings.arguments as String;
    final Relic routeRelic = RelicManager.getRelic(cid);
    logger.i("navigate to relic: $cid");
    if (darkcolor == Colors.black && lightcolor == Colors.black) {
      _loadPalette(routeRelic.entity.imageurl);
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

    return AnimatedContainer(
      duration: const Duration(seconds: 1),
      constraints: const BoxConstraints.expand(),
      decoration: BoxDecoration(
        gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [lightcolor.withOpacity(1), darkcolor.withOpacity(1)]),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(routeRelic.getName(getLanguageCode(context))),
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
                                        if (relicData.entity.xSet == "4")
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    getImageComponent(routeRelic.entity.head, imageWrap: true),
                                                    getImageComponent(routeRelic.entity.hands, imageWrap: true),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    getImageComponent(routeRelic.entity.body, imageWrap: true),
                                                    getImageComponent(routeRelic.entity.feet, imageWrap: true),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      if (screenWidth > 905)
                                        if (relicData.entity.xSet == "2")
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    getImageComponent(routeRelic.entity.sphere, imageWrap: true),
                                                    getImageComponent(routeRelic.entity.rope, imageWrap: true),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      if (screenWidth < 905)
                                        if (relicData.entity.xSet == "4")
                                          FittedBox(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    getImageComponent(relicData.entity.head,
                                                        imageWrap: true,
                                                        placeholder: kTransparentImage,
                                                        fit: BoxFit.cover,
                                                        height: MediaQuery.of(context).size.width / 2,
                                                        width: MediaQuery.of(context).size.width / 2),
                                                    getImageComponent(relicData.entity.hands,
                                                        imageWrap: true,
                                                        placeholder: kTransparentImage,
                                                        fit: BoxFit.cover,
                                                        height: MediaQuery.of(context).size.width / 2,
                                                        width: MediaQuery.of(context).size.width / 2),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    getImageComponent(relicData.entity.body,
                                                        imageWrap: true,
                                                        placeholder: kTransparentImage,
                                                        fit: BoxFit.cover,
                                                        height: MediaQuery.of(context).size.width / 2,
                                                        width: MediaQuery.of(context).size.width / 2),
                                                    getImageComponent(relicData.entity.feet,
                                                        imageWrap: true,
                                                        placeholder: kTransparentImage,
                                                        fit: BoxFit.cover,
                                                        height: MediaQuery.of(context).size.width / 2,
                                                        width: MediaQuery.of(context).size.width / 2),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                      if (screenWidth < 905)
                                        if (relicData.entity.xSet == "2")
                                          FittedBox(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    getImageComponent(relicData.entity.sphere,
                                                        imageWrap: true,
                                                        placeholder: kTransparentImage,
                                                        fit: BoxFit.cover,
                                                        height: MediaQuery.of(context).size.width / 2,
                                                        width: MediaQuery.of(context).size.width / 2),
                                                    getImageComponent(relicData.entity.rope,
                                                        imageWrap: true,
                                                        placeholder: kTransparentImage,
                                                        fit: BoxFit.cover,
                                                        height: MediaQuery.of(context).size.width / 2,
                                                        width: MediaQuery.of(context).size.width / 2),
                                                  ],
                                                ),
                                              ],
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
                                      padding: const EdgeInsets.fromLTRB(0, 8, 0, 10),
                                      child: Column(children: [
                                        if (screenWidth > 905)
                                          const SizedBox(
                                            height: 100,
                                          ),
                                        if (screenWidth > 905)
                                          FittedBox(
                                            child: Padding(
                                              padding: const EdgeInsets.all(25.0),
                                              child: Text(
                                                relicData.getName(getLanguageCode(context)),
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
                                        Column(
                                          children: List.generate(skillData.length, (index) {
                                            final skill = skillData[index];
                                            String fixedtext = relicData.getSkillDescription(index, getLanguageCode(context));
                                            List<EffectEntity> effects = skill.effect.where((e) => !e.hide).toList();
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
                                                            borderRadius: (effects.isNotEmpty)
                                                                ? const BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))
                                                                : const BorderRadius.all(Radius.circular(15)),
                                                            border: Border.all(color: Colors.white.withOpacity(0.13)),
                                                            gradient: LinearGradient(
                                                                begin: Alignment.topLeft,
                                                                end: Alignment.bottomRight,
                                                                colors: [lightcolor.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                                                          ),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Padding(
                                                                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
                                                                  child: Column(
                                                                    children: [
                                                                      Text(
                                                                        relicData.getSkillName(index, getLanguageCode(context)),
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
                                                    if (effects.isNotEmpty)
                                                      Container(
                                                        width: double.infinity,
                                                        margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                                        decoration: BoxDecoration(
                                                          color: Colors.black.withOpacity(0.5),
                                                          borderRadius:
                                                              const BorderRadius.only(bottomLeft: Radius.circular(15), bottomRight: Radius.circular(15)),
                                                        ),
                                                        child: Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: effects.map((e) => Effect.fromEntity(e, relicData.entity.id, '', type: Effect.relicType)).map((effect) {
                                                            EffectEntity ee = effect.entity;
                                                            double multiplierValue = effect.getEffectMultiplierValue(skill, null, null);
                                                            FightProp addProp = FightProp.fromEffectKey(ee.addtarget);
                                                            FightProp multiProp = FightProp.fromEffectKey(ee.multipliertarget);
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
                                                                          child: Text(ee.type,
                                                                              style: const TextStyle(
                                                                                //fontWeight: FontWeight.bold,
                                                                                color: Colors.black,
                                                                                fontSize: 15,
                                                                                fontWeight: FontWeight.bold,
                                                                                height: 1.1,
                                                                              )).tr()),
                                                                      if (ee.referencetarget != '')
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.amber,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(
                                                                                ('lang'.tr() == 'en')
                                                                                    ? ee.referencetargetEN
                                                                                    : (('lang'.tr() == 'cn')
                                                                                        ? ee.referencetargetCN
                                                                                        : ee.referencetargetJP),
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                ))),
                                                                      if (effect.isDamageHealShield() || ee.multipliertarget != '')
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: typetocolor[(ee.type)],
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(
                                                                                '${(ee.multipliertarget).tr()}${multiProp.getPropText(multiplierValue, percent: multiProp != FightProp.none && multiProp != FightProp.unknown)}',
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.black,
                                                                                  fontSize: 15,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  height: 1.1,
                                                                                ))),
                                                                      if (ee.addtarget != '')
                                                                        Container(
                                                                            margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                            padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                            decoration: BoxDecoration(
                                                                              color: Colors.greenAccent,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child: Text(
                                                                                '${(ee.addtarget).tr()}${addProp.getPropText(multiplierValue)}',
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
                                                                    children: ee.tag.map((tag) {
                                                                      return Container(
                                                                        margin: const EdgeInsets.fromLTRB(0, 5, 10, 5),
                                                                        padding: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                                                                        decoration: BoxDecoration(
                                                                          color: Colors.white,
                                                                          borderRadius: BorderRadius.circular(5),
                                                                        ),
                                                                        child: Text(tag,
                                                                          style: const TextStyle(
                                                                            //fontWeight: FontWeight.bold,
                                                                            color: Colors.black,
                                                                            fontSize: 15,
                                                                            fontWeight: FontWeight.bold,
                                                                            height: 1.1,
                                                                          ),
                                                                        ).tr(),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ]),
                                                              ),
                                                            );
                                                          }).toList(),
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
                        tag: routeRelic.entity.imageurl,
                        child: Container(
                          width: columnwidth,
                          height: 100,
                          color: Colors.grey.withOpacity(0.6),
                          child: getImageComponent(routeRelic.entity.imageurl, imageWrap: true, fit: BoxFit.scaleDown, alignment: const Alignment(1, -0.5)),
                        ),
                      ),
                      Container(
                        alignment: Alignment(0, 0),
                        height: 100,
                        width: columnwidth,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(25, 25, 110, 25),
                          child: FittedBox(
                            child: Text(
                              routeRelic.getName(getLanguageCode(context)),
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
    );
  }
}
