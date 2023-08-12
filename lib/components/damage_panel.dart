import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../characters/character.dart';
import '../characters/character_manager.dart';
import '../utils/helper.dart';
import 'character_detail.dart';
import 'global_state.dart';

/// 技能伤害面板
class DamagePanelState extends State<DamagePanel> {
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

class DamagePanel extends StatefulWidget {

  final isBannerAdReady;
  final bannerAd;

  const DamagePanel({
    Key? key,
    required this.isBannerAdReady,
    required this.bannerAd,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return DamagePanelState();
  }
}
