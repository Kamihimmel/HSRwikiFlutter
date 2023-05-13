import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:responsive_grid/responsive_grid.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

import 'info.dart';

Future fetchCharacterList(String infourl) async {
  final response = await http.get(Uri.parse(infourl));
  // print(response.body);
  var parseBody = jsonDecode(response.body);

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return parseBody;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load');
  }
}

class ChracterDetailPage extends StatefulWidget {
  ChracterDetailPage({Key? key}) : super(key: key);

  @override
  State<ChracterDetailPage> createState() => _ChracterDetailPageState();
}

class _ChracterDetailPageState extends State<ChracterDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    final Map<String, String> namedata = ModalRoute.of(context)!.settings.arguments as Map<String, String>;

    return Scaffold(
      appBar: AppBar(
        title: Text(('lang'.tr() == 'en') ? namedata['enname']! : (('lang'.tr() == 'cn') ? namedata['cnname']! : namedata['janame']!)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                FutureBuilder(
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done || snapshot.hasData == null || snapshot.data == null) {
                      //print('project snapshot data is: ${snapshot.data}');
                      return Center(
                        child: Container(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    } else {
                      return Container(
                        decoration: BoxDecoration(image: DecorationImage(image: NetworkImage(snapshot.data['imagelargeurl']), fit: BoxFit.fitHeight)),
                        child: ResponsiveGridRow(
                          children: [
                            ResponsiveGridCol(
                              lg: 3,
                              xs: 12,
                              md: 6,
                              child: Container(
                                color: Colors.black.withOpacity(0.5),
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 110,
                                    ),
                                    Container(
                                      child: Text(
                                        snapshot.data['CNname'],
                                        style: const TextStyle(
                                          //fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 40,
                                          fontWeight: FontWeight.bold,
                                          height: 1.1,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              Image.network(
                                                etoimage[snapshot.data['etype']!]!,
                                              ),
                                              Text(
                                                snapshot.data['etype'],
                                                style: const TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.1,
                                                ),
                                              ).tr(),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              Image.network(
                                                wtoimage[snapshot.data['wtype']!]!,
                                                height: 80,
                                              ),
                                              Text(
                                                snapshot.data['wtype'],
                                                style: const TextStyle(
                                                  //fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.bold,
                                                  height: 1.1,
                                                ),
                                              ).tr(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 200,
                                alignment: Alignment(0, 0),
                                color: Colors.green.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.orange.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.red.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                            ResponsiveGridCol(
                              xs: 6,
                              md: 3,
                              child: Container(
                                height: 100,
                                alignment: Alignment(0, 0),
                                color: Colors.blue.withOpacity(0.5),
                                child: Text("xs : 6 \r\nmd : 3"),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                  future: fetchCharacterList(namedata['infoUrl']!),
                ),
                Hero(
                  tag: namedata['imageUrl']!,
                  child: Container(
                    width: 320,
                    height: 100,
                    color: etocolor[namedata['etype']!]?.withOpacity(0.6),
                    child: Image.network(
                      namedata['imageUrl']!,
                      alignment: const Alignment(-1, -0.5),
                      fit: BoxFit.none,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
