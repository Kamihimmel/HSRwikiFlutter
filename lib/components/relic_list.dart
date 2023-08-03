import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../relics/relic.dart';
import '../relics/relic_manager.dart';
import '../utils/helper.dart';
import 'global_state.dart';
import 'relic_detail.dart';

/// 遗器列表
class RelicListState extends State<RelicList> {
  final GlobalState _gs = GlobalState();
  final List<Relic> _relics = [];
  List<Relic> _filteredData = [];
  bool _cnMode = false;
  Set<String> setFilter = Set();

  @override
  void initState() {
    super.initState();
    _cnMode = _gs.getAppConfig().cnMode;
    _initRelicData();
  }

  Future<void> _initRelicData() async {
    final Map<String, Relic> response = await RelicManager.initAllRelics();
    setState(() {
      _relics.clear();
      _relics.addAll(response.values);
      _filteredData = List.from(_relics);
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
      _initRelicData();
    }
    // filter relic data
    _filteredData = _relics
        .where((c) => _gs.getAppConfig().spoilerMode || !c.spoiler)
        .where((c) => setFilter.isEmpty || setFilter.contains(c.entity.xSet))
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
                            selectedColor: Colors.white.withOpacity(0.5),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            label: const Icon(
                              Icons.looks_4,
                              size: 25,
                              color: Colors.white,
                            ),
                            selected: setFilter.contains("4"),
                            onSelected: (bool value) {
                              setState(() {
                                if (value) {
                                  setFilter.add("4");
                                } else {
                                  setFilter.remove("4");
                                }
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FilterChip(
                            selectedColor: Colors.white.withOpacity(0.5),
                            backgroundColor: Colors.white.withOpacity(0.1),
                            label: const Icon(
                              Icons.looks_two,
                              size: 25,
                              color: Colors.white,
                            ),
                            selected: setFilter.contains("2"),
                            onSelected: (bool value) {
                              if (value) {
                                setFilter.add("2");
                              } else {
                                setFilter.remove("2");
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: crossAxisCount,
                      childAspectRatio: (1 / 1),
                      children: _filteredData.map((r) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RelicDetailPage(basicRelic: r),
                                  settings: RouteSettings(
                                    arguments: r.entity.id,
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
                                    tag: r.entity.imageurl,
                                    child: getImageComponent(r.entity.imageurl, imageWrap: true, fit: BoxFit.scaleDown, width: double.infinity),
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                                      color: Colors.black54,
                                      child: Text(
                                        r.getName(getLanguageCode(context)),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
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

class RelicList extends StatefulWidget {
  final footer;
  final footer2;

  const RelicList({
    Key? key,
    required this.footer,
    required this.footer2,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return RelicListState();
  }
}
