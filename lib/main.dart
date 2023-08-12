import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_strategy/url_strategy.dart';
import 'components/character_list.dart';
import 'components/global_state.dart';
import 'components/lightcone_list.dart';
import 'components/relic_list.dart';
import 'donatePage.dart';

import 'info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'dart:io' show Platform;

import 'toolboxPage.dart';
import 'uidimportPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  setPathUrlStrategy();
  bool needsWeb = false;
  if (kIsWeb) {
    // running on the web!
  } else {
    needsWeb = Platform.isLinux | Platform.isWindows;
    // NOT running on the web! You can check for additional platforms here.
  }
  await Firebase.initializeApp(
    options: needsWeb ? DefaultFirebaseOptions.web : DefaultFirebaseOptions.currentPlatform,
  );
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'), Locale('ja')],
      path: 'langs', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      useOnlyLangCode: true,
      child: const MyApp()));
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        // etc.
      };
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: !kIsWeb && Platform.isWindows ? "title_windows".tr() : "title".tr(),
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: "title"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  Future<InitializationStatus> _initGoogleMobileAds() {
    // TODO: Initialize Google Mobile Ads SDK
    return MobileAds.instance.initialize();
  }

  final GlobalState _gs = GlobalState();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      List<String> sStrings = [
        "silverwolf1".tr(),
        "silverwolf2".tr(),
        "silverwolf3".tr(),
        "silverwolf4".tr(),
        "silverwolf5".tr(),
        "silverwolf6".tr(),
        "silverwolf7".tr(),
        "silverwolf8".tr(),
        "silverwolf9".tr(),
        "silverwolf10".tr(),
      ];
      final random = Random();
      final randomString = sStrings[random.nextInt(sStrings.length)];

      if (kIsWeb || Platform.isIOS || Platform.isAndroid)
        Fluttertoast.showToast(
            msg: randomString,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            textColor: Colors.white,
            fontSize: 16.0);

      if (_counter > 4 && testmode == false) {
        _counter = 0;
        testmode = true;
        _gs.setAppConfig(test: true);
        final snackBar = SnackBar(
          content: const Text('Oops!Test mode activated!'),
          action: SnackBarAction(
            label: "✕",
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }

      if (_counter > 4 && testmode == true) {
        _counter = 0;
        testmode = false;
        _gs.setAppConfig(test: false);
        final snackBar = SnackBar(
          content: const Text('Test mode Deactivated!'),
          action: SnackBarAction(
            label: "✕",
            onPressed: () {
              // Some code to undo the change.
            },
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    });
  }

  List<Map<String, String>> _data2 = [];
  List<Map<String, String>> _data3 = [];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    fetchstaus();
    _getData2();
    _getData3();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _getData2() async {
    final response = await http.get(Uri.parse(urlendpoint + 'lib/lightconelist.json'));
    final Map<String, dynamic> jsonData = json.decode(response.body);

    setState(() {
      _data2 = (jsonData['data'] as List<dynamic>)
          .map((e) => {
                'enname': e['ENname'] as String,
                'cnname': e['CNname'] as String,
                'janame': e['JAname'] as String,
                'imageUrl': urlendpoint + e['imageurl'],
                'wtype': e['wtype'] as String,
                'rarity': e['rarity'] as String,
                'infoUrl': urlendpoint + e['infourl'],
                'spoiler': (e['spoiler'] ? "true" : "false")
              })
          .toList();
      _filteredData2 = List.from(_data2);
    });
  }

  Future<void> _getData3() async {
    final response = await http.get(Uri.parse(urlendpoint + 'lib/reliclist.json'));
    final Map<String, dynamic> jsonData = json.decode(response.body);

    setState(() {
      _data3 = (jsonData['data'] as List<dynamic>)
          .map((e) => {
                'enname': e['ENname'] as String,
                'cnname': e['CNname'] as String,
                'janame': e['JAname'] as String,
                'imageUrl': urlendpoint + e['imageurl'],
                'set': e['set'] as String,
                'infoUrl': urlendpoint + e['infourl'],
                'spoiler': (e['spoiler'] ? "true" : "false")
              })
          .toList();
      _filteredData3 = List.from(_data3);
    });
  }

  Future<void> fetchstaus() async {
    final prefs = await SharedPreferences.getInstance();
    String genderN = prefs.getString('gender') ?? "999";
    if ('male' == genderN) {
      gender = false;
    }
    String spoilerN = prefs.getString('spoilermode') ?? "false";
    if ('true' == spoilerN) {
      spoilermode = true;
    }
    String cnmodeN = '';
    if (!kIsWeb) {
      String deviceCountry = Platform.localeName.substring(Platform.localeName.length - 2);
      String modeString = "false";
      if (deviceCountry == "CN") {
        modeString = "true";
      }
      cnmodeN = prefs.getString('cnmode') ?? modeString;
      if ('true' == cnmodeN) {
        cnmode = true;
        urlendpoint = "https://hsrwikidata.kchlu.com/";
      }
    }
    _gs.setAppConfig(male: 'male' == genderN, spoiler: 'true' == spoilerN, cn: 'true' == cnmodeN);
    setState(() {
      // Here you can write your code for open new view
    });
  }

  //show control bool
  bool filterStar5On = false;
  bool filterStar4On = false;
  bool filterSet4On = false;
  bool filterSet2On = false;
  bool filterStar3On = false;
  bool filterDestructionOn = false;
  bool filterEruditionOn = false;
  bool filterHarmonyOn = false;
  bool filterThehuntOn = false;
  bool filterNihilityOn = false;
  bool filterAbundanceOn = false;
  bool filterPreservationOn = false;
  bool showall = true;

  List<Map<String, String>> _filteredData2 = [];
  List<Map<String, String>> _filteredData3 = [];

  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    // filter lightcone data
    _filteredData2 = List.from(_data2);
    List<Map<String, String>> tempData2 = [];

    if (spoilermode) {
      tempData2.addAll(_filteredData2.where((item) => item['spoiler'] == 'true').toList());
      tempData2.addAll(_filteredData2.where((item) => item['spoiler'] == 'false').toList());

      _filteredData2 = List.from(tempData2);
      tempData2 = [];
    } else {
      tempData2.addAll(_filteredData2.where((item) => item['spoiler'] == 'false').toList());

      _filteredData2 = List.from(tempData2);
      tempData2 = [];
    }

    if (filterStar4On || filterStar5On || filterStar3On) {
      if (filterStar4On) {
        tempData2.addAll(_filteredData2.where((item) => item['rarity'] == '4').toList());
      }
      if (filterStar5On) {
        tempData2.addAll(_filteredData2.where((item) => item['rarity'] == '5').toList());
      }
      if (filterStar3On) {
        tempData2.addAll(_filteredData2.where((item) => item['rarity'] == '3').toList());
      }
      _filteredData2 = List.from(tempData2);
      tempData2 = [];
    }

    if (filterDestructionOn || filterEruditionOn || filterHarmonyOn || filterThehuntOn || filterNihilityOn || filterAbundanceOn || filterPreservationOn) {
      if (filterDestructionOn) {
        tempData2.addAll(_filteredData2.where((item) => item['wtype'] == 'destruction').toList());
      }
      if (filterEruditionOn) {
        tempData2.addAll(_filteredData2.where((item) => item['wtype'] == 'erudition').toList());
      }
      if (filterHarmonyOn) {
        tempData2.addAll(_filteredData2.where((item) => item['wtype'] == 'harmony').toList());
      }
      if (filterThehuntOn) {
        tempData2.addAll(_filteredData2.where((item) => item['wtype'] == 'thehunt').toList());
      }
      if (filterNihilityOn) {
        tempData2.addAll(_filteredData2.where((item) => item['wtype'] == 'nihility').toList());
      }
      if (filterAbundanceOn) {
        tempData2.addAll(_filteredData2.where((item) => item['wtype'] == 'abundance').toList());
      }
      if (filterPreservationOn) {
        tempData2.addAll(_filteredData2.where((item) => item['wtype'] == 'preservation').toList());
      }
      _filteredData2 = List.from(tempData2);
      tempData2 = [];
    }
    // filter relic data

    _filteredData3 = List.from(_data3);
    List<Map<String, String>> tempData3 = [];

    if (spoilermode) {
      tempData3.addAll(_filteredData3.where((item) => item['spoiler'] == 'true').toList());
      tempData3.addAll(_filteredData3.where((item) => item['spoiler'] == 'false').toList());

      _filteredData3 = List.from(tempData3);
      tempData3 = [];
    } else {
      tempData3.addAll(_filteredData3.where((item) => item['spoiler'] == 'false').toList());

      _filteredData3 = List.from(tempData3);
      tempData3 = [];
    }

    if (filterSet2On || filterSet4On) {
      if (filterSet4On) {
        tempData3.addAll(_filteredData3.where((item) => item['set'] == '4').toList());
      }
      if (filterSet2On) {
        tempData3.addAll(_filteredData3.where((item) => item['set'] == '2').toList());
      }
      _filteredData3 = List.from(tempData3);
      tempData3 = [];
    }

    var footer = Padding(
      padding: EdgeInsets.all(8.0),
      child: FittedBox(
        child: Column(
          children: [
            Text(
              'Designed and developed by yunlu18.net. Game assets are property of COGNOSPHERE PTE. LTD / miHoYo.',
            ),
          ],
        ),
      ),
    );

    var footer2 = Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        height: 70,
        width: double.infinity,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Row(
                children: [
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Image(
                        image: bannericon['apple']!,
                        width: 130,
                      ),
                    ),
                    onTap: () {
                      launchUrlString("https://apps.apple.com/app/alice-workshop-for-star-rail/id6450605570");
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                      child: Image(
                        image: bannericon['google']!,
                        width: 170,
                      ),
                    ),
                    onTap: () {
                      launchUrlString("https://play.google.com/store/apps/details?id=net.yunlu18.hsrwikiproject");
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.white, width: 0.5),
                        ),
                        child: Image(
                          image: bannericon['microsoft']!,
                          width: 125,
                        ),
                      ),
                    ),
                    onTap: () {
                      launchUrlString("https://www.microsoft.com/store/apps/9MT6XF11KVT7");
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: 130,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.white, width: 0.5),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.android),
                              Text(
                                'Download APK',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      launchUrlString(urlendpoint + "downloads/hsrwikiproject-" + versionstring + ".apk");
                    },
                  ),
                  InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Container(
                        width: 130,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          border: Border.all(color: Colors.white, width: 0.5),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.window),
                              Text(
                                'Download Msix',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      launchUrlString(urlendpoint + "downloads/hsrwikiproject-" + versionstring + ".msix");
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );

    return Title(
      title: !kIsWeb && Platform.isWindows ? "title_windows".tr() : "title".tr(),
      color: Theme.of(context).colorScheme.background,
      child: Scaffold(
        drawer: SafeArea(
          bottom: false,
          child: Drawer(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
                  child: Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 5),
                  child: Text(
                    "language".tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('English'),
                  onTap: () {
                    setState(() {
                      EasyLocalization.of(context)?.setLocale(const Locale('en'));
                    });
                    // Update the state of the app.
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('简体中文'),
                  onTap: () {
                    // Update the state of the app.
                    EasyLocalization.of(context)?.setLocale(const Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'));
                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.language),
                  title: const Text('日本語'),
                  onTap: () {
                    // Update the state of the app.
                    EasyLocalization.of(context)?.setLocale(const Locale('ja'));
                    // ...
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
                  child: Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 5),
                  child: Text(
                    "Settings".tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                SwitchListTile(
                    title: const Text('Trailblazer').tr(),
                    secondary: (gender ? const Icon(Icons.female) : const Icon(Icons.male)),
                    value: gender,
                    onChanged: (bool value) async {
                      setState(() => gender = value);

                      if (gender == false) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('gender', "male");
                        _gs.setAppConfig(male: true);
                      } else {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setString('gender', "female");
                        _gs.setAppConfig(male: false);
                      }
                    }),
                if (testmode == true)
                  SwitchListTile(
                      title: const Text('Spoiler Mode').tr(),
                      value: spoilermode,
                      onChanged: (bool value) async {
                        setState(() => spoilermode = value);

                        if (value == false) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('spoilermode', "false");
                          _gs.setAppConfig(spoiler: false);
                        } else {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('spoilermode', "true");
                          _gs.setAppConfig(spoiler: true);
                        }
                      }),
                if (!kIsWeb)
                  SwitchListTile(
                      title: cnmode ? Text('Datasource:China').tr() : Text('Datasource:International').tr(),
                      value: cnmode,
                      onChanged: (bool value) async {
                        setState(() => cnmode = value);

                        if (cnmode == false) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('cnmode', "false");
                          _gs.setAppConfig(cn: false);

                          urlendpoint = "https://hsrwikidata.yunlu18.net/";
                          _getData2();
                          _getData3();
                        } else {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('cnmode', "true");
                          _gs.setAppConfig(cn: true);

                          urlendpoint = "https://hsrwikidata.kchlu.com/";
                          _getData2();
                          _getData3();
                        }
                      }),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 5, 20, 2),
                  child: Divider(
                    thickness: 1,
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(22, 0, 22, 5),
                  child: Text(
                    "Others".tr(),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: const Text('Alice Workshop for Genshin').tr(),
                  onTap: () {
                    // Update the state of the app.
                    launchUrlString("https://genshincalc.yunlu18.net/".tr());

                    // ...
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: const Text('Privacy Policy').tr(),
                  onTap: () {
                    launchUrlString("https://genshincalc.yunlu18.net/privacy.html");
                    // Update the state of the app.

                    // ...
                  },
                ),
                if (kIsWeb || Platform.isWindows || Platform.isIOS)
                  ListTile(
                    leading: Icon(Icons.coffee),
                    title: Text('Buy Me a Coffee').tr(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DonatePage()),
                      ).then((value) {
                        setState(() {});
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: PreferredSize(preferredSize: const Size.fromHeight(40), child: FittedBox(fit: BoxFit.scaleDown, child: Text(!kIsWeb && Platform.isWindows ? "title_windows".tr() : "title".tr()))),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(33),
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(width: 1, color: Color.fromRGBO(72, 69, 78, 1))),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TabBar(
                  controller: _tabController,
                  dividerColor: Colors.transparent,
                  isScrollable: true,
                  tabs: <Widget>[
                    Tab(
                      height: 33,
                      icon: Row(
                        children: [
                          const ImageIcon(
                            AssetImage('images/AvatarIcon.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Text('character').tr(),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      height: 33,
                      icon: Row(
                        children: [
                          const ImageIcon(
                            AssetImage('images/IconAvatarLightCone.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Text('lightcone').tr(),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      height: 33,
                      icon: Row(
                        children: [
                          const ImageIcon(
                            AssetImage('images/IconAvatarRelic.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Text('relic').tr(),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      height: 33,
                      icon: Row(
                        children: [
                          const ImageIcon(
                            AssetImage('images/ShopMaterialsIcon.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Text('toolbox').tr(),
                          )
                        ],
                      ),
                    ),
                    Tab(
                      height: 33,
                      icon: Row(
                        children: [
                          const ImageIcon(
                            AssetImage('images/TeamIcon.png'),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: const Text('Your Characters').tr(),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            //ANCHOR - Character
            CharacterList(footer: footer, footer2: footer2),
            //ANCHOR - Lightcone
            LightconeList(footer: footer, footer2: footer2),
            //ANCHOR - Relic
            RelicList(footer: footer, footer2: footer2),
            //ANCHOR - Tools
            Toolboxpage(footer: footer),
            //ANCHOR - Uidimport
            Uidimportpage(footer: footer),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          child: Image.asset(
            "images/silverwolficon.png",
            width: 45,
          ),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
