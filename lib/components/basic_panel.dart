import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../characters/character.dart';
import '../characters/character_manager.dart';
import '../utils/helper.dart';
import 'character_detail.dart';
import 'global_state.dart';

/// 角色基础面板
class BasicPanelState extends State<BasicPanel> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
  }

  //ANCHOR method:statbuilder
  Row buildStatRow(Color color, String a, String b) {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            border: Border.all(color: Colors.white, width: 0.5),
            color: color,
          ),
          width: 10,
          height: 10,
        ),
        Column(
          children: [
            SelectableText(
              a,
              style: TextStyle(
                fontSize: 10,
                height: 1.1,
              ),
            ),
            SelectableText(
              b,
              style: TextStyle(
                fontSize: 10,
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //ANCHOR method:statbarbuilder:percent
  Column buildstatbarpercent(Color color, var a) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
          width: a * 2 + 0.0,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5),
            color: color,
          ),
        ),
      ],
    );
  }

  //ANCHOR method:statbarbuilder
  Column buildstatbar(Color color, var a) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
          width: a / 7 * _gs.statScale / 10,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5),
            color: color,
          ),
        ),
      ],
    );
  }

  //ANCHOR method:statbarbuilder(HP)
  Column buildstatbarhp(Color color, var a) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
          width: a / 75 * _gs.statScale / 10,
          height: 20,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5),
            color: color,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Character _cData = CharacterManager.getCharacter(_gs.stats.id);
    return ChangeNotifierProvider.value(
        value: _gs.getCharacterStats(),
        child: Consumer<CharacterStatsNotify>(
            builder: (context, model, child) => Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                          border: Border.all(color: Colors.white.withOpacity(0.13)),
                          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [_cData.elementType.color.withOpacity(0.35), Colors.black.withOpacity(0.5)]),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: SelectableText(
                                'Basic Panel'.tr(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            //ANCHOR ATK
                            SelectableText(
                              '${"ATK".tr()}:500 + ' + "300" + ' = ' + "800",
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:
                                  //level:Colors.red
                                  //weapon:Colors.blue
                                  //weapon%:Colors.green
                                  //a1:Colors.yellow
                                  //a1%:Colors.yellow[700]
                                  //a2:Colors.pink
                                  //a2%:Colors.pink[700]
                                  //a3%:Colors.blueGrey
                                  //a3:Colors.blueGrey[700]
                                  //a4%:Colors.purple
                                  //a4:Colors.purple[700]
                                  //a5%:Colors.teal
                                  //a5:Colors.teal[700]
                                  //pyro2On:Colors.red
                                  //gladiator2On:Colors.purple
                                  //royalflora4On:Colors.purple

                                  FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //ANCHOR statATK:stats
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            buildStatRow(Colors.red, 'level'.tr(), '250'),
                                            buildStatRow(Colors.blue, 'weapon'.tr(), '250'),
                                            buildStatRow(Colors.red, '${"level".tr()}%(60)', double.parse((60 * 250 / 100).toStringAsFixed(1)).toString()),
                                            buildStatRow(Colors.green, '${"weapon".tr()}%(60)', double.parse((60 * 250 / 100).toStringAsFixed(1)).toString()),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        //ANCHOR statATK:bar
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          ),
                                          foregroundDecoration: BoxDecoration(
                                            border: Border.all(color: Colors.white, width: 1),
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          ),
                                          padding: const EdgeInsets.all(0.5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              buildstatbar(Colors.red, 250),
                                              buildstatbar(Colors.blue, 250),
                                              buildstatbar(Colors.red, 150),
                                              buildstatbar(Colors.green, 150),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            //ANCHOR HP
                            SelectableText(
                              '${"HP".tr()}:5000 + ' + "3000" + ' = ' + "8000",
                              style: TextStyle(fontSize: 15),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child:
                                  //level:Colors.red
                                  //weapon:Colors.blue
                                  //weapon%:Colors.green
                                  //a1:Colors.yellow
                                  //a1%:Colors.yellow[700]
                                  //a2:Colors.pink
                                  //a2%:Colors.pink[700]
                                  //a3%:Colors.blueGrey
                                  //a3:Colors.blueGrey[700]
                                  //a4%:Colors.purple
                                  //a4:Colors.purple[700]
                                  //a5%:Colors.teal
                                  //a5:Colors.teal[700]
                                  //pyro2On:Colors.red
                                  //gladiator2On:Colors.purple
                                  //royalflora4On:Colors.purple

                                  FractionallySizedBox(
                                widthFactor: 1.0,
                                child: Scrollbar(
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        //ANCHOR statATK:stats
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            buildStatRow(Colors.red, 'level'.tr(), '2500'),
                                            buildStatRow(Colors.blue, 'weapon'.tr(), '2500'),
                                            buildStatRow(Colors.red, '${"level".tr()}%(60)', double.parse((60 * 2500 / 100).toStringAsFixed(1)).toString()),
                                            buildStatRow(Colors.green, '${"weapon".tr()}%(60)', double.parse((60 * 2500 / 100).toStringAsFixed(1)).toString()),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 2,
                                        ),
                                        //ANCHOR statATK:bar
                                        Container(
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          ),
                                          foregroundDecoration: BoxDecoration(
                                            border: Border.all(color: Colors.white, width: 1),
                                            borderRadius: const BorderRadius.all(Radius.circular(10)),
                                          ),
                                          padding: const EdgeInsets.all(0.5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              buildstatbarhp(Colors.red, 2500),
                                              buildstatbarhp(Colors.blue, 2500),
                                              buildstatbarhp(Colors.red, 1500),
                                              buildstatbarhp(Colors.green, 1500),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )));
  }
}

class BasicPanel extends StatefulWidget {
  final isBannerAdReady;
  final bannerAd;

  const BasicPanel({
    Key? key,
    required this.isBannerAdReady,
    required this.bannerAd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BasicPanelState();
  }
}
