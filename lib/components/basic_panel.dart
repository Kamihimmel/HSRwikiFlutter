import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
        value: _gs.getCharacterStats(),
        child: Consumer<CharacterStatsNotify>(
            builder: (context, model, child) => Container()));
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
