import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:hsrwikiproject/info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Character {
  final String id;
  final String createdate;
  final Map<String, dynamic> info;

  Character(this.id, this.createdate, this.info);
}

class Uidimportpage extends StatefulWidget {
  const Uidimportpage({
    super.key,
    required this.screenWidth,
    required this.crossAxisCount3,
    required this.footer,
  });

  final double screenWidth;
  final int crossAxisCount3;
  final Padding footer;

  @override
  State<Uidimportpage> createState() => _UidimportpageState();
}

class _UidimportpageState extends State<Uidimportpage> {
  void initState() {
    super.initState();

    _getUid();
  }

  TextEditingController uidController = TextEditingController(text: '');

  String uid = "";
  late Map<String, dynamic> returndata;
  String avatarimage = "";
  String nickname = "";
  String level = "";
  List<Character> characters = [];
  void addOrUpdateCharacter(Character newCharacter) {
    setState(() {
      final existingIndex = characters.indexWhere((c) => c.id == newCharacter.id);
      if (existingIndex != -1) {
        characters[existingIndex] = newCharacter;
      } else {
        characters.add(newCharacter);
      }
    });
  }

  Future<void> _getUid() async {
    if (uid == '') {
      final prefs = await SharedPreferences.getInstance();

      uidController.text = prefs.getString('uid') ?? '';
      uid = prefs.getString('uid') ?? '';

      nickname = prefs.getString('nickname') ?? '';
      avatarimage = prefs.getString('avatarimage') ?? '';
      level = prefs.getString('level') ?? '';

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Column(
        // Column is also a layout widget. It takes a list of children and

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: widget.screenWidth > 1300 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: Column(children: [
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 1000),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        labelText: 'Your UID'.tr(),
                        border: OutlineInputBorder(),
                      ),
                      controller: uidController,
                      onChanged: (value) {
                        setState(() {
                          uid = value;
                        });
                      },
                      keyboardType: TextInputType.numberWithOptions(decimal: false),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: (uid.length == 9)
                        ? () async {
                            if (uid != '') {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('uid', uid);
                            }
                            String langcode = ('lang'.tr() == 'en') ? 'en' : (('lang'.tr() == 'cn') ? 'cn' : 'ja');
                            String url = kIsWeb ? "https://mohomoapi.yunlu18.net/$uid?lang=$langcode" : "https://api.mihomo.me/sr_info_parsed/$uid?lang=$langcode";
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: Duration(days: 1),
                              backgroundColor: Colors.blue,
                              content: Text("Loading.....").tr(),
                              action: SnackBarAction(
                                textColor: Colors.white,
                                label: '×',
                                onPressed: () {
                                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                  // Some code to undo the change.
                                },
                              ),
                            ));
                            http.Response resp = await http.get(
                              Uri.parse(url),
                            );
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();

                            if (resp.statusCode != 200) {
                              setState(() {
                                int statusCode = resp.statusCode;

                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  duration: Duration(days: 1),
                                  backgroundColor: Colors.red,
                                  content: Text("Failed to get $statusCode").tr(),
                                  action: SnackBarAction(
                                    textColor: Colors.white,
                                    label: '×',
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                      // Some code to undo the change.
                                    },
                                  ),
                                ));
                              });
                              return;
                            }
                            returndata = jsonDecode(utf8.decode(resp.bodyBytes));
                            print(returndata['player']);
                            nickname = returndata['player']['nickname'];

                            level = returndata['player']['level'].toString();
                            avatarimage = urlendpoint + "starrailres/" + returndata['player']['avatar']['icon'];
                            if (nickname != '' && avatarimage != '' && level != '') {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setString('nickname', nickname);
                              await prefs.setString('avatarimage', avatarimage);
                              await prefs.setString('level', level);
                            }

                            print(avatarimage);

                            final List<Character> newCharacters = List<Character>.from(
                                returndata['characters'].map((json) => Character(json['id'] as String, DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now()), json as Map<String, dynamic>)));

                            newCharacters.forEach((newCharacter) {
                              addOrUpdateCharacter(newCharacter);
                            });

                            setState(() {});
                          }
                        : null,
                    child: const Text('Import'),
                  ),
                ],
              ),
            ),
            if (nickname == "")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("You have not imported any character.\nPlease import Using your in game UID."),
              ),
            if (avatarimage != "") Image.network(avatarimage),
            if (nickname != "")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  nickname,
                  style: const TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1,
                  ),
                ),
              ),
            if (level != "")
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "LV$level",
                  style: const TextStyle(
                    //fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.normal,
                    height: 1,
                  ),
                ),
              ),
            Container(
              height: 510,
              width: double.infinity,
              child: Center(
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: characters.length,
                  itemBuilder: (context, index) {
                    final character = characters[index];
                    return Container(
                      width: 374,
                      height: 508,
                      child: Stack(
                        children: [
                          Card(
                            child: Image.network(
                              urlendpoint + "starrailres/" + character.info['icon'],
                              fit: BoxFit.cover,
                            ),
                          ),
                          Column(
                            children: [
                              Text(character.id),
                              Text(character.createdate),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  setState(() {
                                    characters.removeAt(index);
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ])),
          widget.footer,
        ],
      ),
    );
  }
}
