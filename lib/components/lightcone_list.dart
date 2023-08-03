import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'lightcone_detail.dart';
import '../lightcones/lightcone.dart';
import '../lightcones/lightcone_manager.dart';
import '../utils/helper.dart';
import 'global_state.dart';

/// 光锥列表
class LightconeListState extends State<LightconeList> {
  final GlobalState _gs = GlobalState();
  final List<Lightcone> _lightcones = [];
  List<Lightcone> _filteredData = [];
  bool _cnMode = false;
  Set<String> starFilter = Set();
  Set<String> pathFilter = Set();

  @override
  void initState() {
    super.initState();
    _cnMode = _gs.getAppConfig().cnMode;
    _initLightconeData();
  }

  Future<void> _initLightconeData() async {
    final Map<String, Lightcone> response = await LightconeManager.initAllLightcones();
    setState(() {
      _lightcones.clear();
      _lightcones.addAll(response.values);
      _filteredData = List.from(_lightcones);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 4
        : screenWidth < 1000
        ? 6
        : 8;

    if (_cnMode != _gs.getAppConfig().cnMode) {
      _cnMode = _gs.getAppConfig().cnMode;
      _initLightconeData();
    }
    // filter lightcone data
    _filteredData = _lightcones
        .where((c) => _gs.getAppConfig().spoilerMode || !c.spoiler)
        .where((c) => starFilter.isEmpty || starFilter.contains(c.entity.rarity))
        .where((c) => pathFilter.isEmpty || pathFilter.contains(c.pathType.key))
        .toList();

    return ChangeNotifierProvider(
        create: (_) => _gs.newAppConfig(),
        child: Consumer<AppConfig>(
            builder: (context, model, child) => Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                // Column is also a layout widget. It takes a list of children and

                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: screenWidth > 1300 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: <Widget>[
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilterChip(
                            selectedColor: Colors.amber.withOpacity(0.5),
                            backgroundColor: Colors.amber[100]!.withOpacity(0.1),
                            label: const Icon(
                              Icons.star_border_rounded,
                              size: 30,
                              color: Colors.amber,
                            ),
                            selected: starFilter.contains("5"),
                            onSelected: (bool value) {
                              setState(() {
                                if (value) {
                                  starFilter.add("5");
                                } else {
                                  starFilter.remove("5");
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilterChip(
                            selectedColor: Colors.deepPurpleAccent.withOpacity(0.5),
                            backgroundColor: Colors.deepPurpleAccent[100]!.withOpacity(0.1),
                            label: const Icon(
                              Icons.star_border_rounded,
                              size: 30,
                              color: Colors.deepPurpleAccent,
                            ),
                            selected: starFilter.contains("4"),
                            onSelected: (bool value) {
                              setState(() {
                                if (value) {
                                  starFilter.add("4");
                                } else {
                                  starFilter.remove("4");
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilterChip(
                            selectedColor: Colors.blueAccent.withOpacity(0.5),
                            backgroundColor: Colors.blueAccent[100]!.withOpacity(0.1),
                            label: const Icon(
                              Icons.star_border_rounded,
                              size: 30,
                              color: Colors.blueAccent,
                            ),
                            selected: starFilter.contains("3"),
                            onSelected: (bool value) {
                              setState(() {
                                if (value) {
                                  starFilter.add("3");
                                } else {
                                  starFilter.remove("3");
                                }
                              });
                            },
                          ),
                        )] +
                        PathType.values.where((p) => p.key != 'diy').map((p) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FilterChip(
                              selectedColor: Colors.grey.withOpacity(0.5),
                              backgroundColor: Colors.grey[100]!.withOpacity(0.1),
                              label: getImageComponent(p.icon, imageWrap: true, width: 30),
                              selected: pathFilter.contains(p.key),
                              onSelected: (bool value) {
                                setState(() {
                                  if (value) {
                                    pathFilter.add(p.key);
                                  } else {
                                    pathFilter.remove(p.key);
                                  }
                                });
                              },
                            ),
                          );
                        }).toList(),
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: (374 / 508),
                      children: _filteredData.map((d) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LightconeDetailPage(lightconeBasic: d),
                                  settings: RouteSettings(
                                    arguments: d.entity.id,
                                  ),
                                ),
                              );
                            },
                            onHover: (value) {
                              if (value) {
                                setState(() {});
                              }
                            },
                            hoverColor: Colors.grey,
                            child: Card(
                              color: Colors.grey.withOpacity(0.1),
                              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12))),
                              child: Stack(
                                children: [
                                  Hero(
                                    tag: d.entity.imageurl,
                                    child: getImageComponent(d.entity.imageurl, imageWrap: true, fit: BoxFit.scaleDown, width: double.infinity),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                          color: Colors.black54,
                                          child: Text(
                                            d.getName(getLanguageCode(context)),
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(bottom: 1),
                                          decoration: BoxDecoration(
                                            color: d.entity.rarity == '5'
                                                ? Colors.amber.withOpacity(0.5)
                                                : d.entity.rarity == '4'
                                                ? Colors.deepPurpleAccent.withOpacity(0.5)
                                                : Colors.blueAccent.withOpacity(0.5),
                                            boxShadow: [
                                              BoxShadow(
                                                color: d.entity.rarity == '5'
                                                    ? Colors.amber.withOpacity(0.5)
                                                    : d.entity.rarity == '4'
                                                    ? Colors.deepPurpleAccent.withOpacity(0.5)
                                                    : Colors.blueAccent.withOpacity(0.5), // Adjust the color and opacity as desired
                                                blurRadius: 5.0, // Adjust the blur radius to control the size of the glow effect
                                                spreadRadius: 1.0, // Adjust the spread radius to control the intensity of the glow effect
                                              ),
                                            ], // This blend mode allows the glow effect to show on top of the container
                                          ),
                                        ),
                                      ],
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
                                            constraints: const BoxConstraints(maxWidth: 50),
                                            child: getImageComponent(d.pathType.icon, imageWrap: true, width: screenWidth / 20),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  widget.footer,
                  if (kIsWeb) widget.footer2
                ],
              ),
            )));
  }
}

class LightconeList extends StatefulWidget {
  final footer;
  final footer2;

  const LightconeList({
    Key? key,
    required this.footer,
    required this.footer2,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LightconeListState();
  }
}
