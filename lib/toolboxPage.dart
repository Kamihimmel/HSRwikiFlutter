import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import 'dmgcalcPage.dart';
import 'effecthitcalc.dart';

class Toolboxpage extends StatelessWidget {
  const Toolboxpage({
    super.key,
    required this.footer,
  });

  final Padding footer;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final crossAxisCount = screenWidth < 600
        ? 1
        : screenWidth < 1000
        ? 1
        : 2;
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: screenWidth > 1300
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              childAspectRatio: (4 / 1),
              children: <Widget>[
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DmgCalcPage(characterId: "1102"),
                        ),
                      );
                    },
                    onHover: (value) {},
                    hoverColor: Colors.grey,
                    child: Card(
                      color: Colors.grey.withOpacity(0.1),
                      clipBehavior: Clip.hardEdge,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      child: Stack(
                        children: [
                          Hero(
                            tag: "damagecalc",
                            child: Image(
                              image: AssetImage('images/damagecalc.jpeg'),
                              width: double.infinity,
                              height: double.infinity,
                              alignment: Alignment(0.5, -0.6),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              color: Colors.black54,
                              child: Text(
                                "HSR Damage Calculator".tr(),
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
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EffecthitCalcPage(),
                        ),
                      );
                    },
                    onHover: (value) {},
                    hoverColor: Colors.grey,
                    child: Card(
                      color: Colors.grey.withOpacity(0.1),
                      clipBehavior: Clip.hardEdge,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(12),
                              topRight: Radius.circular(12))),
                      child: Stack(
                        children: [
                          Hero(
                            tag: "effecthit",
                            child: Image(
                              image: AssetImage('images/effecthit.jpg'),
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              color: Colors.black54,
                              child: Text(
                                "Effect Hit & Effect Res Calculator".tr(),
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
                ),
                Center(child: Text("More Coming soon...")),
              ],
            ),
          ),
          footer,
        ],
      ),
    );
  }
}
