import 'dart:convert';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hsrwikiproject/info.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:flutter/services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:http/http.dart' as http;
import 'ad_helper.dart';
import 'platformad_stub.dart'
    if (dart.library.io) 'platformad_stub.dart'
    if (dart.library.html) 'platformad.dart';

class DmgCalcPage extends StatefulWidget {
  final String jsonUrl;
  const DmgCalcPage({super.key, required this.jsonUrl});

  @override
  State<DmgCalcPage> createState() => _DmgCalcPageState();
}

class _DmgCalcPageState extends State<DmgCalcPage> {
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

    _getData(urlendpoint + "lib/kafka.json");
    _lgetData(urlendpoint + "lib/lightcones/23006.json");
  }
  //get character data

  Map<String, dynamic>? characterData;
  late List<dynamic> levelData;
  late List<dynamic> skillData;
  late List<dynamic> traceData;
  late List<dynamic> eidolonData;
  late int attributeCount;
  late double _currentSliderValue;
  late List<double> levelnumbers;
  late List<double> levelnumbers3;
  late List<bool> traceonList;
  late List<bool> eidolononList;
  bool isLoading = true;

  Future<void> _getData(String url) async {
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> jsonData = json.decode(response.body);
    characterData = jsonData;
    levelData = characterData!['leveldata'];
    skillData = characterData!['skilldata'];
    traceData = characterData!['tracedata'];
    eidolonData = characterData!['eidolon'];
    _currentSliderValue = levelData.length - 1.0;
    levelnumbers = List.generate(skillData.length, (index) => 8);
    levelnumbers3 = List.generate(eidolonData.length, (index) => 8);
    traceonList = List.generate(traceData.length, (index) => true);
    eidolononList = List.generate(eidolonData.length, (index) => false);
    attributeCount = levelData.length;
    print(characterData);
    setState(() {
      isLoading = false;
    });
  }

  // get lightcones data
  Map<String, dynamic>? lightconeData;

  late List<dynamic> llevelData;
  late List<dynamic> lskillData;
  late int lattributeCount;
  late double _lcurrentSliderValue;
  late List<double> llevelnumbers;

  Future<void> _lgetData(String url) async {
    final response = await http.get(Uri.parse(url));
    final Map<String, dynamic> jsonData = json.decode(response.body);
    lightconeData = jsonData;
    llevelData = lightconeData!['leveldata'];
    lskillData = lightconeData!['skilldata'];
    _lcurrentSliderValue = llevelData.length - 1.0;
    llevelnumbers = List.generate(lskillData.length, (index) => 5);
    lattributeCount = llevelData.length;
    print(lightconeData);
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
    const raritytocolor = {
      '5': Colors.amber,
      '4': Colors.deepPurpleAccent,
      '3': Colors.blueAccent,
    };

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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isLoading
                          ? Colors.black.withOpacity(0.8)
                          : (etocolor[characterData!['etype']]
                              ?.withOpacity(0.35) as Color),
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
                                      ResponsiveGridCol(
                                        lg: 3,
                                        md: 6,
                                        xs: 12,
                                        sm: 12,
                                        child: Container(
                                          height: screenWidth > 905
                                              ? screenHeight - 100
                                              : null,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 110,
                                                ),
                                                Container(
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                  ),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 4, sigmaY: 4),
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            0, 0, 0, 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.5) as Color
                                                              ]),
                                                        ),
                                                        child: FadeInImage.memoryNetwork(
                                                            placeholder:
                                                                kTransparentImage,
                                                            image: (gender ==
                                                                        false &&
                                                                    characterData![
                                                                            'imageurlalter'] !=
                                                                        null)
                                                                ? urlendpoint +
                                                                    characterData![
                                                                        'imageurlalter']
                                                                : urlendpoint +
                                                                    characterData![
                                                                        'imageurl'],
                                                            fit: BoxFit.cover,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .medium)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.5) as Color
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      30,
                                                                      5,
                                                                      30,
                                                                      5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Text(
                                                                      "LV:${levelData[_currentSliderValue.toInt()]['level']}",
                                                                      style:
                                                                          const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        height:
                                                                            1.1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Slider(
                                                                      value:
                                                                          _currentSliderValue,
                                                                      min: 0,
                                                                      max: (attributeCount -
                                                                              1)
                                                                          .toDouble(),
                                                                      divisions:
                                                                          attributeCount -
                                                                              1,
                                                                      activeColor:
                                                                          etocolor[
                                                                              characterData!['etype']!],
                                                                      inactiveColor: etocolor[characterData![
                                                                              'etype']!]
                                                                          ?.withOpacity(
                                                                              0.5),
                                                                      onChanged:
                                                                          (double
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          _currentSliderValue =
                                                                              value;
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
                                                  ),
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      skillData.length,
                                                      (index) {
                                                    final data =
                                                        skillData[index];
                                                    String fixedtext = "";

                                                    String detailtext = ('lang'
                                                                .tr() ==
                                                            'en')
                                                        ? data['DescriptionEN']!
                                                        : (('lang'.tr() == 'cn')
                                                            ? data[
                                                                'DescriptionCN']!
                                                            : data[
                                                                'DescriptionJP']!);
                                                    if (data['maxlevel'] > 0) {
                                                      List<dynamic>
                                                          multiplierData = data[
                                                              'levelmultiplier']!;

                                                      int multicount =
                                                          multiplierData.length;
                                                      fixedtext = detailtext;

                                                      for (var i = multicount;
                                                          i >= 1;
                                                          i--) {
                                                        Map<String, dynamic>
                                                            currentleveldata =
                                                            multiplierData[
                                                                i - 1];
                                                        String levelnum =
                                                            (levelnumbers[index]
                                                                .toStringAsFixed(
                                                                    0));

                                                        if (currentleveldata[
                                                                'default'] ==
                                                            null) {
                                                          fixedtext = fixedtext.replaceAll(
                                                              "[$i]",
                                                              (currentleveldata[
                                                                      levelnum])
                                                                  .toString());
                                                        } else {
                                                          fixedtext = fixedtext.replaceAll(
                                                              "[$i]",
                                                              (currentleveldata[
                                                                      'default'])
                                                                  .toString());
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
                                                              width: double
                                                                  .infinity,
                                                              margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                  10,
                                                                  10,
                                                                  10,
                                                                  0),
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15))),
                                                              child:
                                                                  BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                        sigmaX:
                                                                            4,
                                                                        sigmaY:
                                                                            4),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            15)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.13)),
                                                                    gradient: LinearGradient(
                                                                        begin: Alignment
                                                                            .topLeft,
                                                                        end: Alignment
                                                                            .bottomRight,
                                                                        colors: [
                                                                          etocolor[characterData!['etype']!]?.withOpacity(0.35)
                                                                              as Color,
                                                                          Colors
                                                                              .black
                                                                              .withOpacity(0.5) as Color
                                                                        ]),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Container(
                                                                        margin: const EdgeInsets.fromLTRB(
                                                                            0,
                                                                            20,
                                                                            0,
                                                                            0),
                                                                        child: Image
                                                                            .network(
                                                                          urlendpoint +
                                                                              data['imageurl']!,
                                                                          filterQuality:
                                                                              FilterQuality.medium,
                                                                          width:
                                                                              80,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              8,
                                                                              20,
                                                                              8,
                                                                              8),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Text(
                                                                                ('lang'.tr() == 'en') ? data['ENname']! : (('lang'.tr() == 'cn') ? data['CNname']! : data['JAname']!),
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 20,
                                                                                ),
                                                                              ),
                                                                              if (data['maxlevel']! > 0)
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
                                                                                          max: (data['maxlevel']).toDouble(),
                                                                                          divisions: data['maxlevel'] - 1,
                                                                                          activeColor: etocolor[characterData!['etype']!],
                                                                                          inactiveColor: etocolor[characterData!['etype']!]?.withOpacity(0.5),
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color: etocolor[
                                                                      characterData![
                                                                          'etype']!]
                                                                  ?.withOpacity(
                                                                      0.3),
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15)),
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Text(
                                                                    data[
                                                                        'stype']!,
                                                                    style:
                                                                        const TextStyle(
                                                                      //fontWeight: FontWeight.bold,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      height:
                                                                          1.1,
                                                                    )).tr(),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      traceData.length,
                                                      (index) {
                                                    final data =
                                                        traceData[index];
                                                    String detailtext = ('lang'
                                                                .tr() ==
                                                            'en')
                                                        ? data['DescriptionEN']!
                                                        : (('lang'.tr() == 'cn')
                                                            ? data[
                                                                'DescriptionCN']!
                                                            : data[
                                                                'DescriptionJP']!);

                                                    if (data['tiny'] == false) {
                                                      return Stack(
                                                        children: [
                                                          Column(
                                                            children: [
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                margin: const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    0),
                                                                clipBehavior:
                                                                    Clip.hardEdge,
                                                                decoration: const BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.all(
                                                                            Radius.circular(15))),
                                                                child:
                                                                    BackdropFilter(
                                                                  filter: ImageFilter
                                                                      .blur(
                                                                          sigmaX:
                                                                              4,
                                                                          sigmaY:
                                                                              4),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.13)),
                                                                      gradient: LinearGradient(
                                                                          begin: Alignment
                                                                              .topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
                                                                          colors: [
                                                                            etocolor[characterData!['etype']!]?.withOpacity(0.35)
                                                                                as Color,
                                                                            Colors.black.withOpacity(0.5)
                                                                                as Color
                                                                          ]),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Container(
                                                                          margin: const EdgeInsets.fromLTRB(
                                                                              0,
                                                                              20,
                                                                              0,
                                                                              0),
                                                                          child:
                                                                              Image.network(
                                                                            urlendpoint +
                                                                                data['imageurl']!,
                                                                            filterQuality:
                                                                                FilterQuality.medium,
                                                                            width:
                                                                                80,
                                                                          ),
                                                                        ),
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                Text(
                                                                                  ('lang'.tr() == 'en') ? data['ENname']! : (('lang'.tr() == 'cn') ? data['CNname']! : data['JAname']!),
                                                                                  style: const TextStyle(
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontSize: 20,
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
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: etocolor[
                                                                        characterData![
                                                                            'etype']!]
                                                                    ?.withOpacity(
                                                                        0.3),
                                                                borderRadius: const BorderRadius
                                                                        .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            15),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            15)),
                                                              ),
                                                              child: Center(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          2.0),
                                                                  child: Text(
                                                                      data[
                                                                          'stype']!,
                                                                      style:
                                                                          const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        height:
                                                                            1.1,
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
                                                            width:
                                                                double.infinity,
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    0),
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.8),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          15)),
                                                            ),
                                                            child: Row(
                                                              children: [
                                                                Expanded(
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.all(
                                                                            8.0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Container(
                                                                          child: SwitchListTile(
                                                                              activeColor: etocolor[characterData!['etype']!],
                                                                              secondary: ImageIcon(
                                                                                stattoimage[data['ttype']!],
                                                                                size: 30,
                                                                              ),
                                                                              title: Text(
                                                                                ('lang'.tr() == 'en') ? data['ENname']! : (('lang'.tr() == 'cn') ? data['CNname']! : data['JAname']!),
                                                                                style: const TextStyle(
                                                                                  color: Colors.white,
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontSize: 18,
                                                                                ),
                                                                              ),
                                                                              subtitle: Text(detailtext),
                                                                              value: traceonList[index],
                                                                              onChanged: (bool value) async {
                                                                                traceonList[index] = !traceonList[index];

                                                                                setState(() {});
                                                                              }),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                        ],
                                                      );
                                                    }
                                                  }),
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      eidolonData.length,
                                                      (index) {
                                                    final data =
                                                        eidolonData[index];
                                                    String fixedtext = "";

                                                    String detailtext = ('lang'
                                                                .tr() ==
                                                            'en')
                                                        ? data['DescriptionEN']!
                                                        : (('lang'.tr() == 'cn')
                                                            ? data[
                                                                'DescriptionCN']!
                                                            : data[
                                                                'DescriptionJP']!);
                                                    if (data['maxlevel'] !=
                                                            null &&
                                                        data['maxlevel'] > 0) {
                                                      List<dynamic>
                                                          multiplierData = data[
                                                              'levelmultiplier']!;

                                                      int multicount =
                                                          multiplierData.length;

                                                      for (var i = multicount;
                                                          i >= 1;
                                                          i--) {
                                                        Map<String, dynamic>
                                                            currentleveldata =
                                                            multiplierData[
                                                                i - 1];
                                                        String levelnum =
                                                            (levelnumbers3[
                                                                    index]
                                                                .toStringAsFixed(
                                                                    0));

                                                        fixedtext = detailtext
                                                            .replaceAll(
                                                                "[$i]",
                                                                (currentleveldata[
                                                                        levelnum])
                                                                    .toString());
                                                      }
                                                    } else {
                                                      fixedtext = detailtext;
                                                    }

                                                    return Stack(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            if (((data['eidolonnum']!) !=
                                                                    3) &&
                                                                ((data['eidolonnum']!) !=
                                                                    5))
                                                              Container(
                                                                width: double
                                                                    .infinity,
                                                                margin: const EdgeInsets
                                                                        .fromLTRB(
                                                                    10,
                                                                    10,
                                                                    10,
                                                                    0),
                                                                clipBehavior:
                                                                    Clip.hardEdge,
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15)),
                                                                ),
                                                                child:
                                                                    BackdropFilter(
                                                                  filter: ImageFilter
                                                                      .blur(
                                                                          sigmaX:
                                                                              4,
                                                                          sigmaY:
                                                                              4),
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(15)),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .white
                                                                              .withOpacity(0.13)),
                                                                      gradient: LinearGradient(
                                                                          begin: Alignment
                                                                              .topLeft,
                                                                          end: Alignment
                                                                              .bottomRight,
                                                                          colors: [
                                                                            etocolor[characterData!['etype']!]?.withOpacity(0.35)
                                                                                as Color,
                                                                            Colors.black.withOpacity(0.5)
                                                                                as Color
                                                                          ]),
                                                                    ),
                                                                    child: Row(
                                                                      children: [
                                                                        Expanded(
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                Column(
                                                                              children: [
                                                                                SwitchListTile(
                                                                                    activeColor: etocolor[characterData!['etype']!],
                                                                                    secondary: Image.network(
                                                                                      urlendpoint + data['imageurl']!,
                                                                                      filterQuality: FilterQuality.medium,
                                                                                      width: 80,
                                                                                    ),
                                                                                    title: Text(
                                                                                      ('lang'.tr() == 'en') ? data['ENname']! : (('lang'.tr() == 'cn') ? data['CNname']! : data['JAname']!),
                                                                                      style: const TextStyle(
                                                                                        color: Colors.white,
                                                                                        fontWeight: FontWeight.bold,
                                                                                        fontSize: 18,
                                                                                      ),
                                                                                    ),
                                                                                    subtitle: Text(detailtext),
                                                                                    value: eidolononList[index],
                                                                                    onChanged: (bool value) async {
                                                                                      eidolononList[index] = !eidolononList[index];

                                                                                      setState(() {});
                                                                                    }),
                                                                                if (data['maxlevel'] != null && data['maxlevel']! > 0)
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                                    child: Row(
                                                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                      children: [
                                                                                        SizedBox(
                                                                                          child: Text(
                                                                                            "LV:${levelnumbers3[index].toInt()}",
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
                                                                                            value: levelnumbers3[index],
                                                                                            min: 1,
                                                                                            max: (data['maxlevel']).toDouble(),
                                                                                            divisions: data['maxlevel'] - 1,
                                                                                            activeColor: etocolor[characterData!['etype']!],
                                                                                            inactiveColor: etocolor[characterData!['etype']!]?.withOpacity(0.5),
                                                                                            onChanged: (double value) {
                                                                                              setState(() {
                                                                                                levelnumbers3[index] = value;
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
                                                            decoration:
                                                                BoxDecoration(
                                                              color: etocolor[
                                                                      characterData![
                                                                          'etype']!]
                                                                  ?.withOpacity(
                                                                      0.3),
                                                              borderRadius: const BorderRadius
                                                                      .only(
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          15),
                                                                  bottomRight: Radius
                                                                      .circular(
                                                                          15)),
                                                            ),
                                                            child: Center(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        2.0),
                                                                child: Text(
                                                                    (data['stype']!
                                                                                as String)
                                                                            .tr() +
                                                                        data['eidolonnum']!
                                                                            .toString(),
                                                                    style:
                                                                        const TextStyle(
                                                                      //fontWeight: FontWeight.bold,
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          18,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      height:
                                                                          1.1,
                                                                    )),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                                adsenseAdsView(
                                                    columnwidth - 20),
                                                if (_isBannerAdReady)
                                                  Container(
                                                    width: _bannerAd!.size.width
                                                        .toDouble(),
                                                    height: _bannerAd!
                                                        .size.height
                                                        .toDouble(),
                                                    child: AdWidget(
                                                        ad: _bannerAd!),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      //ANCHOR - Lightcones and Relics
                                      ResponsiveGridCol(
                                        lg: 3,
                                        md: 6,
                                        xs: 12,
                                        sm: 12,
                                        child: Container(
                                          height: screenWidth > 905
                                              ? screenHeight - 100
                                              : null,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                Container(
                                                  width: 200,
                                                  height: 200,
                                                  clipBehavior: Clip.hardEdge,
                                                  decoration:
                                                      const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                15)),
                                                  ),
                                                  child: BackdropFilter(
                                                    filter: ImageFilter.blur(
                                                        sigmaX: 4, sigmaY: 4),
                                                    child: Container(
                                                        margin: const EdgeInsets
                                                                .fromLTRB(
                                                            0, 0, 0, 0),
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          15)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                Colors.black12
                                                                    .withOpacity(
                                                                        0.35),
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.35),
                                                              ]),
                                                        ),
                                                        child: FadeInImage.memoryNetwork(
                                                            placeholder:
                                                                kTransparentImage,
                                                            image: urlendpoint +
                                                                lightconeData![
                                                                    'imageurl'],
                                                            fit: BoxFit.cover,
                                                            filterQuality:
                                                                FilterQuality
                                                                    .medium)),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.5)
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .fromLTRB(
                                                                      30,
                                                                      5,
                                                                      30,
                                                                      5),
                                                              child: Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  SizedBox(
                                                                    width: 100,
                                                                    child: Text(
                                                                      "LV:${llevelData[_lcurrentSliderValue.toInt()]['level']}",
                                                                      style:
                                                                          const TextStyle(
                                                                        //fontWeight: FontWeight.bold,
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            25,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        height:
                                                                            1.1,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        Slider(
                                                                      value:
                                                                          _lcurrentSliderValue,
                                                                      min: 0,
                                                                      max: (lattributeCount -
                                                                              1)
                                                                          .toDouble(),
                                                                      divisions:
                                                                          lattributeCount -
                                                                              1,
                                                                      activeColor:
                                                                          etocolor[
                                                                              characterData!['etype']!],
                                                                      inactiveColor: etocolor[characterData![
                                                                              'etype']!]
                                                                          ?.withOpacity(
                                                                              0.5),
                                                                      onChanged:
                                                                          (double
                                                                              value) {
                                                                        setState(
                                                                            () {
                                                                          _lcurrentSliderValue =
                                                                              value;
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
                                                  ),
                                                ),
                                                Column(
                                                  children: List.generate(
                                                      lskillData.length,
                                                      (index) {
                                                    final data =
                                                        lskillData[index];
                                                    String fixedtext = "";

                                                    String detailtext = ('lang'
                                                                .tr() ==
                                                            'en')
                                                        ? data['DescriptionEN']!
                                                        : (('lang'.tr() == 'cn')
                                                            ? data[
                                                                'DescriptionCN']!
                                                            : data[
                                                                'DescriptionJP']!);
                                                    if (data['maxlevel'] > 0) {
                                                      List<dynamic>
                                                          multiplierData = data[
                                                              'levelmultiplier']!;

                                                      int multicount =
                                                          multiplierData.length;
                                                      fixedtext = detailtext;

                                                      for (var i = multicount;
                                                          i >= 1;
                                                          i--) {
                                                        Map<String, dynamic>
                                                            currentleveldata =
                                                            multiplierData[
                                                                i - 1];
                                                        String levelnum =
                                                            (levelnumbers[index]
                                                                .toStringAsFixed(
                                                                    0));

                                                        if (currentleveldata[
                                                                'default'] ==
                                                            null) {
                                                          fixedtext = fixedtext.replaceAll(
                                                              "[$i]",
                                                              (currentleveldata[
                                                                      levelnum])
                                                                  .toString());
                                                        } else {
                                                          fixedtext = fixedtext.replaceAll(
                                                              "[$i]",
                                                              (currentleveldata[
                                                                      'default'])
                                                                  .toString());
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
                                                              width: double
                                                                  .infinity,
                                                              margin: const EdgeInsets
                                                                      .fromLTRB(
                                                                  10,
                                                                  10,
                                                                  10,
                                                                  0),
                                                              clipBehavior:
                                                                  Clip.hardEdge,
                                                              decoration: const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              15))),
                                                              child:
                                                                  BackdropFilter(
                                                                filter: ImageFilter
                                                                    .blur(
                                                                        sigmaX:
                                                                            4,
                                                                        sigmaY:
                                                                            4),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    borderRadius: const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            15)),
                                                                    border: Border.all(
                                                                        color: Colors
                                                                            .white
                                                                            .withOpacity(0.13)),
                                                                    gradient: LinearGradient(
                                                                        begin: Alignment
                                                                            .topLeft,
                                                                        end: Alignment
                                                                            .bottomRight,
                                                                        colors: [
                                                                          etocolor[characterData!['etype']!]?.withOpacity(0.35)
                                                                              as Color,
                                                                          Colors
                                                                              .black
                                                                              .withOpacity(0.5)
                                                                        ]),
                                                                  ),
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              30,
                                                                              5,
                                                                              30,
                                                                              5),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                                                                child: Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                  children: [
                                                                                    SizedBox(
                                                                                      width: 100,
                                                                                      child: Text(
                                                                                        "E${llevelnumbers[index].toInt()}",
                                                                                        style: const TextStyle(
                                                                                          //fontWeight: FontWeight.bold,
                                                                                          color: Colors.white,
                                                                                          fontSize: 25,
                                                                                          fontWeight: FontWeight.bold,
                                                                                          height: 1.1,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    Expanded(
                                                                                      child: Slider(
                                                                                        value: llevelnumbers[index],
                                                                                        min: 1,
                                                                                        max: (data['maxlevel']).toDouble(),
                                                                                        divisions: data['maxlevel'] - 1,
                                                                                        activeColor: etocolor[characterData!['etype']!],
                                                                                        inactiveColor: etocolor[characterData!['etype']!]?.withOpacity(0.5),
                                                                                        onChanged: (double value) {
                                                                                          setState(() {
                                                                                            llevelnumbers[index] = value;
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
                                                            const SizedBox(
                                                              height: 10,
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    );
                                                  }),
                                                ),
                                                //ANCHOR - relicselect
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                      ),
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 4,
                                                                sigmaY: 4),
                                                        child: Container(
                                                            width: 125,
                                                            height: 125,
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          15)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.13)),
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                  colors: [
                                                                    Colors
                                                                        .black12
                                                                        .withOpacity(
                                                                            0.35),
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.35),
                                                                  ]),
                                                            ),
                                                            child: FadeInImage.memoryNetwork(
                                                                placeholder:
                                                                    kTransparentImage,
                                                                image: urlendpoint +
                                                                    "images/relics/71008.webp",
                                                                width: 125,
                                                                fit: BoxFit
                                                                    .cover,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .medium)),
                                                      ),
                                                    ),
                                                    Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                      ),
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 4,
                                                                sigmaY: 4),
                                                        child: Container(
                                                            width: 125,
                                                            height: 125,
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          15)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.13)),
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                  colors: [
                                                                    Colors
                                                                        .black12
                                                                        .withOpacity(
                                                                            0.35),
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.35),
                                                                  ]),
                                                            ),
                                                            child: FadeInImage.memoryNetwork(
                                                                placeholder:
                                                                    kTransparentImage,
                                                                image: urlendpoint +
                                                                    "images/relics/71008.webp",
                                                                width: 125,
                                                                fit: BoxFit
                                                                    .cover,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .medium)),
                                                      ),
                                                    ),
                                                    Container(
                                                      clipBehavior:
                                                          Clip.hardEdge,
                                                      decoration:
                                                          const BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    15)),
                                                      ),
                                                      child: BackdropFilter(
                                                        filter:
                                                            ImageFilter.blur(
                                                                sigmaX: 4,
                                                                sigmaY: 4),
                                                        child: Container(
                                                            width: 125,
                                                            height: 125,
                                                            margin:
                                                                const EdgeInsets
                                                                        .fromLTRB(
                                                                    0, 0, 0, 0),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  const BorderRadius
                                                                          .all(
                                                                      Radius.circular(
                                                                          15)),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .white
                                                                      .withOpacity(
                                                                          0.13)),
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topLeft,
                                                                  end: Alignment
                                                                      .bottomRight,
                                                                  colors: [
                                                                    Colors
                                                                        .black12
                                                                        .withOpacity(
                                                                            0.35),
                                                                    Colors.black
                                                                        .withOpacity(
                                                                            0.35),
                                                                  ]),
                                                            ),
                                                            child: FadeInImage.memoryNetwork(
                                                                placeholder:
                                                                    kTransparentImage,
                                                                image: urlendpoint +
                                                                    "images/relics/71017.webp",
                                                                width: 125,
                                                                fit: BoxFit
                                                                    .cover,
                                                                filterQuality:
                                                                    FilterQuality
                                                                        .medium)),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                //ANCHOR - relics1
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.5)
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 70,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      child:
                                                                          OverflowBox(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        maxWidth:
                                                                            60,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                          child: FadeInImage.memoryNetwork(
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/relic/101_0.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 80,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          FadeInImage.memoryNetwork(
                                                                              width: 25,
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                          Text(
                                                                            "15%",
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: Text(
                                                                                "+" + "15",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,

                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(
                                                                                    width: 28,
                                                                                    placeholder: kTransparentImage,
                                                                                    image: urlendpoint +
                                                                                        "starrailres/"
                                                                                            "icon/property/IconAttack.png",
                                                                                    filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
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
                                                ),
                                                //ANCHOR - relics2
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.5)
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 70,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      child:
                                                                          OverflowBox(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        maxWidth:
                                                                            60,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                          child: FadeInImage.memoryNetwork(
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/relic/101_0.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 80,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          FadeInImage.memoryNetwork(
                                                                              width: 25,
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                          Text(
                                                                            "15%",
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: Text(
                                                                                "+" + "15",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,

                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(
                                                                                    width: 28,
                                                                                    placeholder: kTransparentImage,
                                                                                    image: urlendpoint +
                                                                                        "starrailres/"
                                                                                            "icon/property/IconAttack.png",
                                                                                    filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
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
                                                ),
                                                //ANCHOR - relics3
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.5)
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 70,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      child:
                                                                          OverflowBox(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        maxWidth:
                                                                            60,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                          child: FadeInImage.memoryNetwork(
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/relic/101_0.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 80,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          FadeInImage.memoryNetwork(
                                                                              width: 25,
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                          Text(
                                                                            "15%",
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: Text(
                                                                                "+" + "15",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,

                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(
                                                                                    width: 28,
                                                                                    placeholder: kTransparentImage,
                                                                                    image: urlendpoint +
                                                                                        "starrailres/"
                                                                                            "icon/property/IconAttack.png",
                                                                                    filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
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
                                                ),
                                                //ANCHOR - relics4
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.5)
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 70,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      child:
                                                                          OverflowBox(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        maxWidth:
                                                                            60,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                          child: FadeInImage.memoryNetwork(
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/relic/101_0.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 80,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          FadeInImage.memoryNetwork(
                                                                              width: 25,
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                          Text(
                                                                            "15%",
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: Text(
                                                                                "+" + "15",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,

                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(
                                                                                    width: 28,
                                                                                    placeholder: kTransparentImage,
                                                                                    image: urlendpoint +
                                                                                        "starrailres/"
                                                                                            "icon/property/IconAttack.png",
                                                                                    filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
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
                                                ),
                                                //ANCHOR - relics5
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.5)
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 70,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      child:
                                                                          OverflowBox(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        maxWidth:
                                                                            60,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                          child: FadeInImage.memoryNetwork(
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/relic/101_0.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 80,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          FadeInImage.memoryNetwork(
                                                                              width: 25,
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                          Text(
                                                                            "15%",
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: Text(
                                                                                "+" + "15",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,

                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(
                                                                                    width: 28,
                                                                                    placeholder: kTransparentImage,
                                                                                    image: urlendpoint +
                                                                                        "starrailres/"
                                                                                            "icon/property/IconAttack.png",
                                                                                    filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
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
                                                ),
                                                //ANCHOR - relics6
                                                Padding(
                                                  padding: const EdgeInsets.all(
                                                      10.0),
                                                  child: Container(
                                                    clipBehavior: Clip.hardEdge,
                                                    decoration:
                                                        const BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10)),
                                                    ),
                                                    child: BackdropFilter(
                                                      filter: ImageFilter.blur(
                                                          sigmaX: 4, sigmaY: 4),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10)),
                                                          border: Border.all(
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                      0.13)),
                                                          gradient: LinearGradient(
                                                              begin: Alignment
                                                                  .topLeft,
                                                              end: Alignment
                                                                  .bottomRight,
                                                              colors: [
                                                                etocolor[characterData![
                                                                        'etype']!]
                                                                    ?.withOpacity(
                                                                        0.35) as Color,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.5)
                                                              ]),
                                                        ),
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          2),
                                                              child: Container(
                                                                width: double
                                                                    .infinity,
                                                                height: 70,
                                                                child: Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Container(
                                                                      width: 30,
                                                                      child:
                                                                          OverflowBox(
                                                                        alignment:
                                                                            Alignment.centerLeft,
                                                                        maxWidth:
                                                                            60,
                                                                        child:
                                                                            Padding(
                                                                          padding: const EdgeInsets.fromLTRB(
                                                                              5,
                                                                              5,
                                                                              0,
                                                                              5),
                                                                          child: FadeInImage.memoryNetwork(
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/relic/101_0.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 80,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [
                                                                          FadeInImage.memoryNetwork(
                                                                              width: 25,
                                                                              placeholder: kTransparentImage,
                                                                              image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png",
                                                                              filterQuality: FilterQuality.medium),
                                                                          Text(
                                                                            "15%",
                                                                            style:
                                                                                const TextStyle(
                                                                              //fontWeight: FontWeight.bold,
                                                                              color: Colors.white,
                                                                              fontSize: 22,
                                                                              fontWeight: FontWeight.bold,
                                                                              height: 1,
                                                                            ),
                                                                          ),
                                                                          Container(
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.3),
                                                                              borderRadius: const BorderRadius.all(Radius.circular(2)),
                                                                            ),
                                                                            child:
                                                                                Padding(
                                                                              padding: const EdgeInsets.all(1.0),
                                                                              child: Text(
                                                                                "+" + "15",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,

                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    Padding(
                                                                      padding: const EdgeInsets
                                                                              .symmetric(
                                                                          vertical:
                                                                              5),
                                                                      child:
                                                                          VerticalDivider(
                                                                        thickness:
                                                                            1,
                                                                        color: Theme.of(context)
                                                                            .colorScheme
                                                                            .primary
                                                                            .withOpacity(0.3),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(
                                                                                    width: 28,
                                                                                    placeholder: kTransparentImage,
                                                                                    image: urlendpoint +
                                                                                        "starrailres/"
                                                                                            "icon/property/IconAttack.png",
                                                                                    filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      width: 90,
                                                                      height:
                                                                          70,
                                                                      child:
                                                                          Column(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "10%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          Row(
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(1.0),
                                                                                child: FadeInImage.memoryNetwork(width: 28, placeholder: kTransparentImage, image: urlendpoint + "starrailres/" + "icon/property/IconAttack.png", filterQuality: FilterQuality.medium),
                                                                              ),
                                                                              Text(
                                                                                "15%",
                                                                                style: const TextStyle(
                                                                                  //fontWeight: FontWeight.bold,
                                                                                  color: Colors.white,
                                                                                  fontSize: 20,
                                                                                  height: 1,
                                                                                ),
                                                                              ),
                                                                            ],
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
                                                ),
                                                adsenseAdsView(
                                                    columnwidth - 20),
                                                if (_isBannerAdReady)
                                                  Container(
                                                    width: _bannerAd!.size.width
                                                        .toDouble(),
                                                    height: _bannerAd!
                                                        .size.height
                                                        .toDouble(),
                                                    child: AdWidget(
                                                        ad: _bannerAd!),
                                                  ),
                                              ],
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
