import 'dart:ffi';
import 'dart:ui';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/services.dart';

import 'info.dart';
import 'platformad_stub.dart' if (dart.library.io) 'platformad_stub.dart' if (dart.library.html) 'platformad.dart';

class EffecthitCalcPage extends StatefulWidget {
  final String jsonUrl;
  const EffecthitCalcPage({super.key, required this.jsonUrl});

  @override
  State<EffecthitCalcPage> createState() => _EffecthitCalcPageState();
}

class _EffecthitCalcPageState extends State<EffecthitCalcPage> {
  @override
  void initState() {
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  TextEditingController pController = TextEditingController(text: '100');
  num basicp = 100.0;

  TextEditingController effecthitController = TextEditingController(text: '0');
  num effecthit = 0.0;

  TextEditingController effectresController = TextEditingController(text: '30');
  num effectres = 30.0;

  TextEditingController effectresredController = TextEditingController(text: '0');
  num effectresred = 0.0;

  TextEditingController effectresspController = TextEditingController(text: '0');
  num effectressp = 0.0;

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

    var finalchance = basicp * (1 + effecthit / 100) * (1 - effectres / 100 + effectresred / 100) * (1 - effectressp / 100);
    var effecthitrequired = 100 / (basicp * (1 - effectres / 100 + effectresred / 100) * (1 - effectressp / 100)) * 100 - 100;

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
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.blue.withOpacity(0.3), Colors.black.withOpacity(0.8)]),
              ),
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  title: Text(
                    "Effect Hit & Effect Res Calculator".tr(),
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
                                    height: screenWidth > 905 ? screenHeight - 100 : null,
                                    child: Column(
                                      children: [
                                        const SizedBox(
                                          height: 110,
                                        ),
                                        adsenseAdsView(columnwidth - 20),
                                        ConstrainedBox(
                                          constraints: BoxConstraints(maxWidth: 1000),
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.end,
                                                  decoration: InputDecoration(
                                                    labelText: 'Basic Chance'.tr(),
                                                    border: OutlineInputBorder(),
                                                    suffixText: '%',
                                                  ),
                                                  controller: pController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      basicp = num.parse(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.end,
                                                  decoration: InputDecoration(
                                                    labelText: 'Effect hit'.tr(),
                                                    border: OutlineInputBorder(),
                                                    suffixText: '%',
                                                  ),
                                                  controller: effecthitController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      effecthit = num.parse(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.end,
                                                  decoration: InputDecoration(
                                                    labelText: 'Enemy Effect RES'.tr(),
                                                    border: OutlineInputBorder(),
                                                    suffixText: '%',
                                                  ),
                                                  controller: effectresController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      effectres = num.parse(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.end,
                                                  decoration: InputDecoration(
                                                    labelText: 'Enemy Effect RES Reduce'.tr(),
                                                    border: OutlineInputBorder(),
                                                    suffixText: '%',
                                                  ),
                                                  controller: effectresredController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      effectresred = num.parse(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  textAlign: TextAlign.end,
                                                  decoration: InputDecoration(
                                                    labelText: 'Enemy Special Effect RES'.tr(),
                                                    border: OutlineInputBorder(),
                                                    suffixText: '%',
                                                  ),
                                                  controller: effectresspController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      effectressp = num.parse(value);
                                                    });
                                                  },
                                                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                                                  inputFormatters: <TextInputFormatter>[
                                                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "Final Chance".tr(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      finalchance.toStringAsFixed(1) + "%",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 50,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(20.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      "100% Chance Effect hit Required".tr(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      effecthitrequired.toStringAsFixed(1) + "%",
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 50,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                tag: "effecthit",
                                child: Container(
                                  width: columnwidth,
                                  height: 100,
                                  color: Colors.blue.withOpacity(0.6),
                                  child: Image(
                                    image: AssetImage('images/effecthit.jpg'),
                                    width: double.infinity,
                                    height: double.infinity,
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
                                      "Effect Hit & Effect Res Calculator".tr(),
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
