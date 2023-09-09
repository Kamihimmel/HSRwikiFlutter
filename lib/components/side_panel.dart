import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../donatePage.dart';
import '../utils/helper.dart';
import '../utils/logging.dart';
import 'global_state.dart';

/// 侧边栏
class _SidePanelState extends State<SidePanel> {
  final GlobalState _gs = GlobalState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _gs,
        child: Consumer<GlobalState>(builder: (context, model, child) {
          return ListView(
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
                  "Settings".tr(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              SwitchListTile(
                  title: const Text('Trailblazer').tr(),
                  secondary: (!_gs.appConfig.male ? const Icon(Icons.female) : const Icon(Icons.male)),
                  value: !_gs.appConfig.male,
                  onChanged: (bool value) async {
                    _gs.appConfig.male = !value;
                    _gs.changeConfig();
                  }),
              if (_gs.appConfig.test)
                SwitchListTile(
                    title: const Text('Spoiler Mode').tr(),
                    value: _gs.appConfig.spoilerMode,
                    onChanged: (bool value) async {
                      _gs.appConfig.spoilerMode = value;
                      _gs.changeConfig();
                    }),
              if (!kIsWeb)
                SwitchListTile(
                    title: _gs.appConfig.cnMode ? Text('Datasource:China').tr() : Text('Datasource:International').tr(),
                    value: _gs.appConfig.cnMode,
                    onChanged: (bool value) async {
                      _gs.appConfig.cnMode = value;
                      _gs.changeConfig();
                      initData();
                    }),
              if (_gs.debug)
                ...[
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
                      "Debug",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.refresh),
                    title: const Text("Reload Data"),
                    onTap: () {
                      initData();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.adb),
                    title: const Text("Print Debug Info"),
                    onTap: () {
                      List<String> debugInfo = [];
                      debugInfo.add("Endpoint: ${getUrlEndpoint()}");
                      debugInfo.add("AppConfig: ${_gs.appConfig.toString()}");
                      debugInfo.add("Missing localization keys: ${_gs.missingLocalizationKeys.toList()}");
                      debugInfo.forEach((element) {
                        logger.i(element);
                      });
                      final snackBar = SnackBar(
                        content: Column(
                          children: debugInfo.map((e) => Text(e)).toList(),
                        ),
                        action: SnackBarAction(
                          label: "✕",
                          onPressed: () {
                            // Some code to undo the change.
                          },
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.cleaning_services),
                    title: const Text("Clean Store"),
                    onTap: () async {
                      List<String> keys = ['saved_stats', 'saved_enemy_stats', 'playerinfo', 'uid', 'nickname', 'avatarimage', 'characters'];
                      final prefs = await SharedPreferences.getInstance();
                      for (var k in keys) {
                        await prefs.remove(k);
                      }
                      logger.w("Removed keys: ${keys}");
                    },
                  ),
                ],
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
                  "Others".tr(),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: const Text('Alice Workshop for Genshin').tr(),
                onTap: () {
                  // Update the state of the app.
                  launchUrlString("https://genshincalc.yunlu18.net/".tr());

                  // ...
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: const Text('Privacy Policy').tr(),
                onTap: () {
                  launchUrlString("https://genshincalc.yunlu18.net/privacy.html");
                  // Update the state of the app.

                  // ...
                },
              ),
              if (kIsWeb || Platform.isWindows || Platform.isIOS)
                ListTile(
                  leading: Icon(Icons.coffee),
                  title: Text('Buy Me a Coffee').tr(),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DonatePage()),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                ),
            ],
          );
        }));
  }
}

class SidePanel extends StatefulWidget {

  const SidePanel({
    Key? key
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _SidePanelState();
  }
}
