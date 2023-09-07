import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hsrwikiproject/utils/helper.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:flutter/services.dart';

import 'ad_helper.dart';
import 'enemies/enemy_manager.dart';
import 'platformad_stub.dart' if (dart.library.io) 'platformad_stub.dart' if (dart.library.html) 'platformad.dart';
import 'utils/logging.dart';

class EnemyListPage extends StatefulWidget {
  const EnemyListPage({super.key});

  @override
  State<EnemyListPage> createState() => _EnemyListPageState();
}

class _EnemyListPageState extends State<EnemyListPage> {
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
  }

  @override
  void dispose() {
    // TODO: Dispose a BannerAd object
    _bannerAd?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: AnimatedContainer(
              duration: const Duration(seconds: 1),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    "Enemy List".tr(),
                  ),
                ),
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            child: ResponsiveGridRow(
                              children: [
                                ResponsiveGridCol(
                                  lg: 12,
                                  md: 12,
                                  xs: 12,
                                  sm: 12,
                                  child: Container(
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 110,
                                        ),
                                        adsenseAdsView(columnwidth - 20),
                                        if (_isBannerAdReady)
                                          Container(
                                            width: _bannerAd!.size.width.toDouble(),
                                            height: _bannerAd!.size.height.toDouble(),
                                            child: AdWidget(ad: _bannerAd!),
                                          ),
                                        Container(
                                          width: screenWidth,
                                          height: screenHeight - 170,
                                          child: Scrollbar(
                                            isAlwaysShown: true,
                                            child: SingleChildScrollView(
                                              scrollDirection: Axis.horizontal,
                                              child: Scrollbar(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.vertical,
                                                  child: Center(
                                                    child: DataTable(
                                                      columns: <DataColumn>[
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Text(
                                                              'Icon'.tr(),
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Text(
                                                              'Name'.tr(),
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Text(
                                                              'Weakness'.tr(),
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Column(
                                                              children: [
                                                                getImageComponent('images/stat_ctrl-mstatdef_icon.webp', remote: false, imageWrap: true, height: 25, fit: BoxFit.contain),
                                                                Text('Effect Defense'.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        DataColumn(
                                                          label: Expanded(
                                                            child: Text(
                                                              'Category'.tr(),
                                                              style: TextStyle(fontWeight: FontWeight.bold),
                                                            ),
                                                          ),
                                                        ),
                                                        for (ElementType et in ElementType.validValues())
                                                          DataColumn(
                                                            label: Expanded(
                                                              child: getImageComponent(et.icon, imageWrap: true, height: 25, fit: BoxFit.contain),
                                                            ),
                                                          ),
                                                        for (DebuffType dt in DebuffType.validValues())
                                                          DataColumn(
                                                            label: Column(
                                                              children: [
                                                                getImageComponent(dt.icon, remote: false, imageWrap: true, height: 25, fit: BoxFit.contain),
                                                                Text(dt.desc.tr(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                                              ],
                                                            ),
                                                          ),
                                                      ],
                                                      rows: <DataRow>[
                                                        for (var e in EnemyManager.getEnemies().entries)
                                                          DataRow(
                                                            cells: <DataCell>[
                                                              DataCell(getImageComponent(e.value.entity.imageurl, imageWrap: true, width: 50)),
                                                              DataCell(Text(e.value.getName(getLanguageCode(context)))),
                                                              DataCell(
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    for (var weak in e.value.weakness) getImageComponent(weak.icon, imageWrap: true, width: 30),
                                                                  ],
                                                                ),
                                                              ),
                                                              DataCell(Text(e.value.entity.effectdef.toString())),
                                                              DataCell(
                                                                Row(
                                                                  mainAxisSize: MainAxisSize.min,
                                                                  children: [
                                                                    getImageComponent(e.value.category.icon, remote: false, imageWrap: true, width: 25),
                                                                    SizedBox(width: 5),
                                                                    Text(e.value.category.desc.tr())
                                                                  ],
                                                                ),
                                                              ),
                                                              for (ElementType et in ElementType.validValues()) DataCell(Text((e.value.resistence[et] ?? 0).toString())),
                                                              for (DebuffType dt in DebuffType.validValues()) DataCell(Text((e.value.effectResistence[dt] ?? 0).toString())),
                                                            ],
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                //ANCHOR - Skilldata
                              ],
                            ),
                          ),
                          Stack(
                            children: [
                              Hero(
                                tag: "enemylist",
                                child: Container(
                                  width: columnwidth,
                                  height: 100,
                                  color: Colors.blue.withOpacity(0.6),
                                  child: Image(
                                    image: AssetImage('images/monster.jpg'),
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
                                      "Enemy List".tr(),
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
