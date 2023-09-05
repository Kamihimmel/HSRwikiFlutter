import 'dart:math';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_strategy/url_strategy.dart';
import 'components/character_list.dart';
import 'components/global_state.dart';
import 'components/lightcone_list.dart';
import 'components/relic_list.dart';
import 'components/side_panel.dart';

import 'info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'dart:io' show Platform;

import 'toolboxPage.dart';
import 'uidimportPage.dart';
import 'utils/helper.dart';
import 'utils/logging.dart';

void main() async {
  _setDebug();
  _customEazyLocalization();
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
      path: 'langs',
      // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      useOnlyLangCode: true,
      child: const MyApp()));
}

void _setDebug() {
  GlobalState _gs = GlobalState();
  assert(() {
    // development env
    _gs.debug = true;
    logger.d('debug mode: ${_gs.debug}');
    return true;
  }());
  if (_gs.debug && !kIsWeb && Platform.environment.containsKey('LOCAL_ENDPOINT')) {
    _gs.localEndpoint = Platform.environment['LOCAL_ENDPOINT']!;
  }
}

void _customEazyLocalization() {
  RegExp regExp = RegExp(r'ocalization key \[(.*)] not found');
  GlobalState _gs = GlobalState();
  var customLogPrinter = (
      Object object, {
        String? name,
        StackTrace? stackTrace,
        LevelMessages? level,
      }) {
    String message = object.toString();
    RegExpMatch? match = regExp.firstMatch(message);
    if (match != null) {
      String? key = match.group(1);
      if (key != null) {
        if (_gs.debug) {
          _gs.missingLocalizationKeys.add(key);
        }
        return;
      }
    }

    switch(level) {
      case LevelMessages.debug:
        logger.d('$name: $message');
        break;
      case LevelMessages.info:
        logger.i('$name: $message');
        break;
      case LevelMessages.warning:
        logger.w('$name: $message');
        break;
      case LevelMessages.error:
        logger.e('$name: $message');
        break;
      case null:
        logger.d('$name: $message');
        break;
    }
  };
  EasyLocalization.logger.printer = customLogPrinter;
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

      if (_counter > 4 && !_gs.test) {
        _counter = 0;
        _gs.test = true;
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

      if (_counter > 4 && _gs.test) {
        _counter = 0;
        _gs.test = false;
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

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> init() async {
    await fetchstaus();
    await initData();
  }

  Future<void> fetchstaus() async {
    final prefs = await SharedPreferences.getInstance();
    String genderN = prefs.getString('gender') ?? "999";
    String spoilerN = prefs.getString('spoilermode') ?? "false";
    String cnmodeN = '';
    if (!kIsWeb) {
      String deviceCountry = Platform.localeName.substring(Platform.localeName.length - 2);
      String modeString = "false";
      if (deviceCountry == "CN") {
        modeString = "true";
      }
      cnmodeN = prefs.getString('cnmode') ?? modeString;
    }
    _gs.male = 'male' == genderN;
    _gs.spoilerMode = 'true' == spoilerN;
    _gs.cnMode = 'true' == cnmodeN;
    setState(() {
      // Here you can write your code for open new view
    });
  }

  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
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
                      launchUrlString(getUrlEndpoint() + "downloads/hsrwikiproject-" + versionstring + ".apk");
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
                      launchUrlString(getUrlEndpoint() + "downloads/hsrwikiproject-" + versionstring + ".msix");
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
            child: SidePanel(),
          ),
        ),
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: PreferredSize(
              preferredSize: const Size.fromHeight(40),
              child: FittedBox(fit: BoxFit.scaleDown, child: Text(!kIsWeb && Platform.isWindows ? "title_windows".tr() : "title".tr()))),
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
