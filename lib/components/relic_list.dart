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
  List<Relic> _filteredData = [];
  Set<String> setFilter = Set();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 4
        : screenWidth < 1000
        ? 6
        : 8;
    return ChangeNotifierProvider.value(
        value: _gs,
        child: Consumer<GlobalState>(
            builder: (context, model, child) {
              _filteredData = RelicManager.getRelics().values
                  .where((c) => _gs.spoilerMode || !c.spoiler)
                  .where((c) => setFilter.isEmpty || setFilter.contains(c.entity.xSet))
                  .toList();
              _filteredData.sort((e1, e2) => e1.spoiler == e2.spoiler ? 0 : (e1.spoiler ? -1 : 1));

              return Center(
                child: Column(
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
                                setState(() {
                                  if (value) {
                                    setFilter.add("2");
                                  } else {
                                    setFilter.remove("2");
                                  }
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: !_gs.relicLoaded ? Center(
                        child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                      ) : GridView.count(
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
                                          r.getName(getLanguageCode(context)) + (_gs.debug ? " ${r.entity.id}" : ''),
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
              );
            }));
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
