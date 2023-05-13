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
                'rarity': e['rarity'] as String,
                'infoUrl': e['infourl'] as String,
              })
          .toList();
      _filteredData = List.from(_data);
    });
  }

  //show control bool
  bool filterStar5On = false;
  bool filterStar4On = false;
  bool filterFireOn = false;
  bool filterLightningOn = false;
  bool filterIceOn = false;
  bool filterImaginaryOn = false;
  bool filterQuantumOn = false;
  bool filterWindOn = false;
  bool filterPhysicalOn = false;
  bool filterDestructionOn = false;
  bool filterEruditionOn = false;
  bool filterHarmonyOn = false;
  bool filterThehuntOn = false;
  bool filterNihilityOn = false;
  bool filterAbundanceOn = false;
  bool filterPreservationOn = false;
  bool showall = true;

  List<Map<String, String>> _filteredData = [];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final crossAxisCount = screenWidth < 600 ? 4 : 8;

    _filteredData = List.from(_data);
    List<Map<String, String>> tempData = [];

    if (filterStar4On || filterStar5On) {
      if (filterStar4On) {
        tempData.addAll(_filteredData.where((item) => item['rarity'] == '4').toList());
      }
      if (filterStar5On) {
        tempData.addAll(_filteredData.where((item) => item['rarity'] == '5').toList());
      }
      _filteredData = List.from(tempData);
      tempData = [];
    }

    if (filterFireOn || filterLightningOn || filterIceOn || filterWindOn || filterPhysicalOn || filterQuantumOn || filterImaginaryOn) {
      if (filterFireOn) {
        tempData.addAll(_filteredData.where((item) => item['etype'] == 'fire').toList());
      }
      if (filterLightningOn) {
        tempData.addAll(_filteredData.where((item) => item['etype'] == 'lightning').toList());
      }
      if (filterWindOn) {
        tempData.addAll(_filteredData.where((item) => item['etype'] == 'wind').toList());
      }
      if (filterIceOn) {
        tempData.addAll(_filteredData.where((item) => item['etype'] == 'ice').toList());
      }
      if (filterPhysicalOn) {
        tempData.addAll(_filteredData.where((item) => item['etype'] == 'physical').toList());
      }
      if (filterQuantumOn) {
        tempData.addAll(_filteredData.where((item) => item['etype'] == 'quantum').toList());
      }
      if (filterImaginaryOn) {
        tempData.addAll(_filteredData.where((item) => item['etype'] == 'imaginary').toList());
      }
      _filteredData = List.from(tempData);
      tempData = [];
    }

    if (filterDestructionOn || filterEruditionOn || filterHarmonyOn || filterThehuntOn || filterNihilityOn || filterAbundanceOn || filterPreservationOn) {
      if (filterDestructionOn) {
        tempData.addAll(_filteredData.where((item) => item['wtype'] == 'destruction').toList());
      }
      if (filterEruditionOn) {
        tempData.addAll(_filteredData.where((item) => item['wtype'] == 'erudition').toList());
      }
      if (filterHarmonyOn) {
        tempData.addAll(_filteredData.where((item) => item['wtype'] == 'harmony').toList());
      }
      if (filterThehuntOn) {
        tempData.addAll(_filteredData.where((item) => item['wtype'] == 'thehunt').toList());
      }
      if (filterNihilityOn) {
        tempData.addAll(_filteredData.where((item) => item['wtype'] == 'nihility').toList());
      }
      if (filterAbundanceOn) {
        tempData.addAll(_filteredData.where((item) => item['wtype'] == 'abundance').toList());
      }
      if (filterPreservationOn) {
        tempData.addAll(_filteredData.where((item) => item['wtype'] == 'preservation').toList());
      }
      _filteredData = List.from(tempData);
      tempData = [];
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
            Row(children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterChip(
                  selectedColor: Colors.amber.withOpacity(0.5),
                  backgroundColor: Colors.amber[100]!.withOpacity(0.1),
                  label: const Text("★5"),
                  selected: filterStar5On,
                  onSelected: (bool value) {
                    setState(() {
                      filterStar5On = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilterChip(
                  selectedColor: Colors.deepPurpleAccent.withOpacity(0.5),
                  backgroundColor: Colors.deepPurpleAccent[100]!.withOpacity(0.1),
                  label: const Text("★4"),
                  selected: filterStar4On,
                  onSelected: (bool value) {
                    setState(() {
                      filterStar4On = value;
                    });
                  },
                ),
              ),
            ]),
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
                    selected: filterLightningOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterLightningOn = value;
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
                    selected: filterIceOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterIceOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.red.withOpacity(0.5),
                    backgroundColor: Colors.red[100]!.withOpacity(0.1),
                    label: Image.network(
                      etoimage['fire']!,
                      width: 30,
                    ),
                    selected: filterFireOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterFireOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.yellow.withOpacity(0.5),
                    backgroundColor: Colors.yellow[100]!.withOpacity(0.1),
                    label: Image.network(
                      etoimage['imaginary']!,
                      width: 30,
                    ),
                    selected: filterImaginaryOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterImaginaryOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.indigo.withOpacity(0.5),
                    backgroundColor: Colors.indigo[100]!.withOpacity(0.1),
                    label: Image.network(
                      etoimage['quantum']!,
                      width: 30,
                    ),
                    selected: filterQuantumOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterQuantumOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.green.withOpacity(0.5),
                    backgroundColor: Colors.green[100]!.withOpacity(0.1),
                    label: Image.network(
                      etoimage['wind']!,
                      width: 30,
                    ),
                    selected: filterWindOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterWindOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      etoimage['physical']!,
                      width: 30,
                    ),
                    selected: filterPhysicalOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterPhysicalOn = value;
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      wtoimage['destruction']!,
                      width: 30,
                    ),
                    selected: filterDestructionOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterDestructionOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      wtoimage['erudition']!,
                      width: 30,
                    ),
                    selected: filterEruditionOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterEruditionOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      wtoimage['harmony']!,
                      width: 30,
                    ),
                    selected: filterHarmonyOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterHarmonyOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      wtoimage['thehunt']!,
                      width: 30,
                    ),
                    selected: filterThehuntOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterThehuntOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      wtoimage['nihility']!,
                      width: 30,
                    ),
                    selected: filterNihilityOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterNihilityOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      wtoimage['abundance']!,
                      width: 30,
                    ),
                    selected: filterAbundanceOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterAbundanceOn = value;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FilterChip(
                    selectedColor: Colors.grey.withOpacity(0.5),
                    backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                    label: Image.network(
                      wtoimage['preservation']!,
                      width: 30,
                    ),
                    selected: filterPreservationOn,
                    onSelected: (bool value) {
                      setState(() {
                        filterPreservationOn = value;
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
