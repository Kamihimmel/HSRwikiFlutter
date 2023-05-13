import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'characterdetail.dart';
import 'info.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(EasyLocalization(
      supportedLocales: const [Locale('en'), Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'), Locale('ja')],
      path: 'langs', // <-- change the path of the translation files
      fallbackLocale: const Locale('en'),
      useFallbackTranslations: true,
      useOnlyLangCode: true,
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      debugShowCheckedModeBanner: false,
      title: 'Honkai Starrail wiki',
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.dark,
      home: const MyHomePage(title: ' Honkai Starrail wiki'),
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

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  List<Map<String, String>> _data = [];
  @override
  void initState() {
    super.initState();
    _getData();
  }

  Future<void> _getData() async {
    final response = await http.get(Uri.parse('https://hsrwikidata.yunlu18.net/lib/characterlist.json'));
    final Map<String, dynamic> jsonData = json.decode(response.body);
    print(jsonData);

    setState(() {
      _data = (jsonData['data'] as List<dynamic>)
          .map((e) => {
                'enname': e['ENname'] as String,
                'cnname': e['CNname'] as String,
                'janame': e['JAname'] as String,
                'imageUrl': e['imageurl'] as String,
                'etype': e['etype'] as String,
                'wtype': e['wtype'] as String,
                'infoUrl': e['infourl'] as String,
              })
          .toList();
      _filteredData = List.from(_data);
    });
  }

  //show control bool
  bool lightningOn = false;
  bool iceOn = false;
  bool showall = true;

  List<Map<String, String>> _filteredData = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = screenWidth < 600 ? 4 : 8;

    if (lightningOn || iceOn) {
      _filteredData = [];
      if (lightningOn) {
        _filteredData.addAll(_data.where((item) => item['etype'] == 'lightning').toList());
      }
      if (iceOn) {
        _filteredData.addAll(_data.where((item) => item['etype'] == 'ice').toList());
      }
    } else {
      _filteredData = List.from(_data);
    }

    return Scaffold(
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
            ],
          ),
        ),
      ),
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("title".tr() + " Honkai Starrail Wiki"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.purple.withOpacity(0.5),
                    backgroundColor: Colors.purple[100]!.withOpacity(0.1),
                    label: Image.network(
                      etoimage['lightning']!,
                      width: 30,
                    ),
                    selected: lightningOn,
                    onSelected: (bool value) {
                      setState(() {
                        lightningOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.lightBlue.withOpacity(0.5),
                    backgroundColor: Colors.lightBlue[100]!.withOpacity(0.1),
                    label: Image.network(
                      etoimage['ice']!,
                      width: 30,
                    ),
                    selected: iceOn,
                    onSelected: (bool value) {
                      setState(() {
                        iceOn = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: crossAxisCount,
                childAspectRatio: (374 / 508),
                children: _filteredData.asMap().entries.map((e) {
                  final int index = e.key;
                  final Map<String, String> data = e.value;

                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChracterDetailPage(jsonUrl: data['infoUrl']!),
                          settings: RouteSettings(
                            arguments: data,
                          ),
                        ),
                      );
                    },
                    onHover: (value) {
                      if (value) {
                        setState(() {});
                      }
                    },
                    hoverColor: etocolor[data['etype']!],
                    child: Card(
                      color: Colors.grey.withOpacity(0.1),
                      child: Stack(
                        children: [
                          Hero(
                            tag: data['imageUrl']!,
                            child: Image.network(
                              data['imageUrl']!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              color: Colors.black54,
                              child: Text(
                                ('lang'.tr() == 'en') ? data['enname']! : (('lang'.tr() == 'cn') ? data['cnname']! : data['janame']!),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Column(
                                children: [
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 50),
                                    child: Image.network(
                                      etoimage[data['etype']!] ?? 'none',
                                      width: screenWidth / 20,
                                    ),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(maxWidth: 50),
                                    child: Image.network(
                                      wtoimage[data['wtype']!]!,
                                      width: screenWidth / 20,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Provided by yunlu18.net',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
