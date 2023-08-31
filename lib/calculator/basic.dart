import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../characters/character_manager.dart';
import '../lightcones/lightcone_manager.dart';
import '../relics/relic.dart';
import '../relics/relic_manager.dart';

enum FightProp {
  maxHP(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  attack(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  defence(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  speed(desc: 'Speed', icon: 'starrailres/icon/property/IconSpeed.png', effectKey: ['spd']),
  criticalChance(desc: 'critrate', icon: 'starrailres/icon/property/IconCriticalChance.png', effectKey: ['critrate']),
  criticalDamage(desc: 'critdmg', icon: 'starrailres/icon/property/IconCriticalDamage.png', effectKey: ['critdmg']),
  breakDamageAddedRatio(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png', effectKey: ['breakeffect', 'breakdmg']),
  breakDamageAddedRatioBase(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png'),
  healRatio(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png', effectKey: ['healrate']),
  maxSP(desc: 'Max Energy', icon: 'starrailres/icon/property/IconEnergyLimit.png'),
  sPRatio(desc: 'energyregenrate', icon: 'starrailres/icon/property/IconEnergyRecovery.png', effectKey: ['sprate']),
  statusProbability(desc: 'Effect Hit Rate', icon: 'starrailres/icon/property/IconStatusProbability.png', effectKey: ['effecthit']),
  statusResistance(desc: 'Effect RES', icon: 'starrailres/icon/property/IconStatusResistance.png', effectKey: ['effectres']),
  criticalChanceBase(desc: 'CRIT Rate', icon: 'starrailres/icon/property/IconCriticalChance.png'),
  criticalDamageBase(desc: 'CRIT DMG', icon: 'starrailres/icon/property/IconCriticalDamage.png'),
  healRatioBase(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  stanceBreakAddedRatio(desc: '', icon: ''),
  sPRatioBase(desc: 'Energy Regeneration Rate', icon: 'starrailres/icon/property/IconEnergyRecovery.png', effectKey: ['energyregenrate']),
  statusProbabilityBase(desc: 'Effect Hit Rate', icon: 'starrailres/icon/property/IconStatusProbability.png'),
  statusResistanceBase(desc: 'Effect RES', icon: 'starrailres/icon/property/IconStatusResistance.png'),
  physicalAddedRatio(desc: 'Physical DMG Boost', icon: 'starrailres/icon/property/IconPhysicalAddedRatio.png', effectKey: ['physicaldmg']),
  physicalResistance(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  physicalResistanceIgnore(desc: 'Physical RES Ignore', icon: '', effectKey: ['physicalpen']),
  fireAddedRatio(desc: 'Fire DMG Boost', icon: 'starrailres/icon/property/IconFireAddedRatio.png', effectKey: ['firedmg']),
  fireResistance(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  fireResistanceIgnore(desc: 'Fire RES Ignore', icon: '', effectKey: ['firepen']),
  iceAddedRatio(desc: 'Ice DMG Boost', icon: 'starrailres/icon/property/IconIceAddedRatio.png', effectKey: ['icedmg']),
  iceResistance(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  iceResistanceIgnore(desc: 'Ice RES Ignore', icon: '', effectKey: ['icepen']),
  thunderAddedRatio(desc: 'Lightning DMG Boost', icon: 'starrailres/icon/property/IconThunderAddedRatio.png', effectKey: ['lightningdmg']),
  thunderResistance(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  thunderResistanceIgnore(desc: 'Lightning RES Ignore', icon: '', effectKey: ['lightningpen']),
  windAddedRatio(desc: 'Wind DMG Boost', icon: 'starrailres/icon/property/IconWindAddedRatio.png', effectKey: ['winddmg']),
  windResistance(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  windResistanceIgnore(desc: 'Wind RES Ignore', icon: '', effectKey: ['windpen']),
  quantumAddedRatio(desc: 'Quantum DMG Boost', icon: 'starrailres/icon/property/IconQuantumAddedRatio.png', effectKey: ['quantumdmg']),
  quantumResistance(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  quantumResistanceIgnore(desc: 'Quantum RES Ignore', icon: '', effectKey: ['quantumpen']),
  imaginaryAddedRatio(desc: 'Imaginary DMG Boost', icon: 'starrailres/icon/property/IconImaginaryAddedRatio.png', effectKey: ['imaginarydmg']),
  imaginaryResistance(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),
  imaginaryResistanceIgnore(desc: 'Imaginary RES Ignore', icon: '', effectKey: ['imaginarypen']),
  baseHP(desc: 'Base HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  hPDelta(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  hPAddedRatio(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png', effectKey: ['hp', 'maxhp']),
  baseAttack(desc: 'Base ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  attackDelta(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  attackAddedRatio(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png', effectKey: ['atk']),
  baseDefence(desc: 'Base DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  defenceDelta(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  defenceAddedRatio(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png', effectKey: ['def']),
  baseSpeed(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png'),
  healTakenRatio(desc: 'Incoming Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  physicalResistanceDelta(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  fireResistanceDelta(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceResistanceDelta(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  thunderResistanceDelta(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windResistanceDelta(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumResistanceDelta(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryResistanceDelta(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),
  speedDelta(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png', effectKey: ['speed']),
  aggro(desc: 'Taunt', icon: 'starrailres/icon/property/IconTaunt.png', effectKey: ['taunt']),
  dotDamageAddRatio(desc: 'Dot Boost', icon: '', effectKey: ['dotvulnerability']),
  allDamageAddRatio(desc: 'All DMG Boost', icon: '', effectKey: ['alldmg']),
  lostHP(desc: 'Lost HP', icon: ''),
  allDamageReceiveRatio(desc: 'Damage Receive', icon: '', debuff: true, effectKey: ['dmgreceive']),
  defenceIgnoreRatio(desc: 'Defence Ignore', icon: '', effectKey: ['ignoredef']),
  defenceReduceRatio(desc: 'Defence Reduce', icon: '', debuff: true, effectKey: ['reducedef']),
  basicAttackAddRatio(desc: 'Basic ATK Boost', icon: '', effectKey: ['basicatk', 'normalatk']),
  skillAttackAddRatio(desc: 'Skill ATK Boost', icon: '', effectKey: ['skillatk']),
  ultimateAttackAddRatio(desc: 'Ultimate ATK Boost', icon: '', effectKey: ['ultatk']),
  followupAttackAddRatio(desc: 'Followup ATK Boost', icon: '', effectKey: ['followupatk']),
  basicAttackCriticalChange(desc: 'Basic Critical Change', icon: '', effectKey: ['basiccrit', 'normalcrit']),
  skillAttackCriticalChange(desc: 'Skill Critical Change', icon: '', effectKey: ['skillcrit']),
  ultimateAttackCriticalChange(desc: 'Ultimate Critical Change', icon: '', effectKey: ['ultcrit']),
  followupAttackCriticalChange(desc: 'Followup Critical Change', icon: '', effectKey: ['followupcrit']),
  basicAttackCriticalDamage(desc: 'Basic Critical Damage', icon: '', effectKey: ['basiccritdmg', 'normalcritdmg']),
  skillAttackCriticalDamage(desc: 'Skill Critical Damage', icon: '', effectKey: ['skillcritdmg']),
  ultimateAttackCriticalDamage(desc: 'Ultimate Critical Damage', icon: '', effectKey: ['ultcritdmg']),
  followupAttackCriticalDamage(desc: 'Followup Critical Damage', icon: '', effectKey: ['followupcritdmg']),
  none(desc: '', icon: '');

  final String desc;
  final String icon;
  final bool debuff;
  final List<String> effectKey;

  const FightProp({
    required this.desc,
    required this.icon,
    this.debuff = false,
    this.effectKey = const [],
  });

  bool isPercent() {
    return this.name.contains("Ratio") || this.name.contains("Resistance") || this.name.contains("Probability") || this.name.contains("critical") || this.name.contains("Critical");
  }

  String getPropText(double value) {
    if (isPercent()) {
      return ((value * 1000).floor() / 10).toStringAsFixed(1) + '%';
    } else {
      return value.floor().toString();
    }
  }

  static FightProp fromName(String name) {
    return FightProp.values.firstWhere((p) => p.name == name, orElse: () => FightProp.none);
  }

  static FightProp fromEffectKey(String effectKey) {
    return FightProp.values.firstWhere((p) => p.effectKey.contains(effectKey.toLowerCase()), orElse: () => FightProp.none);
  }

  static FightProp fromEffectMultiplier(String multiplierTarget) {
    if (multiplierTarget == 'atk') {
      return FightProp.attack;
    } else if (multiplierTarget == 'maxhp') {
      return FightProp.maxHP;
    } else if (multiplierTarget == 'def') {
      return FightProp.defence;
    }
    return FightProp.none;
  }

  static FightProp fromImportType(String importType) {
    String type = importType.replaceFirst('Base', '').toLowerCase();
    return FightProp.values.firstWhere((p) => p.name.toLowerCase() == type, orElse: () => FightProp.none);
  }
}

class PropSource {
  static const int selfBasic = 0;
  static const int lightconeBasic = 1;
  static const int selfSkill = 2;
  static const int selfTrace = 3;
  static const int selfEidolon = 4;
  static const int lightconeSkill = 5;
  static const int relicMain = 6;
  static const int relicSub = 7;
  static const int relicSet = 8;
  static const int otherSkill = 9;
  static const int otherTrace = 10;
  static const int otherEidolon = 11;
  static const int unknown = 99;

  String id = '';
  String name = '';
  String desc = '';
  int source = PropSource.unknown;
  bool base = false;

  PropSource.characterBasic(String id, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.selfBasic;
    this.base = true;
  }

  PropSource.characterSkill(String id, {name = '', desc = '', self = false}) {
    _setBase(id, name, desc);
    this.source = self ? PropSource.selfSkill : PropSource.otherSkill;
  }

  PropSource.characterTrace(String id, {name = '', desc = '', self = false}) {
    _setBase(id, name, desc);
    this.source = self ? PropSource.selfTrace : PropSource.otherTrace;
  }

  PropSource.characterEidolon(String id, {name = '', desc = '', self = false}) {
    _setBase(id, name, desc);
    this.source = self ? PropSource.selfEidolon : PropSource.otherEidolon;
  }

  PropSource.lightconeAttr(String id, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.lightconeBasic;
    this.base = true;
  }

  PropSource.lightconeEffect(String id, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.lightconeSkill;
  }

  PropSource.relicAttr(RelicPart relicPart, {desc = '', mainAttr = false}) {
    _setBase(relicPart.name, relicPart.name, desc);
    this.source = mainAttr ? PropSource.relicMain : PropSource.relicSub;
  }

  PropSource.relicSetEffect(String id, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.relicSet;
  }

  _setBase(String id, String name, String desc) {
    this.id = id;
    this.name = name;
    this.desc = desc;
  }

  PropSourceDisplay getDisplay() {
    switch(source) {
      case selfBasic:
        return PropSourceDisplay('character'.tr(), Colors.red);
      case lightconeBasic:
        return PropSourceDisplay('lightcone'.tr(), Colors.blue);
      case lightconeSkill:
        return PropSourceDisplay(LightconeManager.getLightcone(id).getSkillName(0, 'lang'.tr()), Colors.green);
      case selfSkill:
        return PropSourceDisplay(CharacterManager.getCharacter(desc).getSkillNameById(id, 'lang'.tr()), Colors.lime);
      case selfTrace:
        return PropSourceDisplay(desc == '' ? 'trace'.tr() : CharacterManager.getCharacter(desc).getTraceNameById(id, 'lang'.tr()), Colors.amber);
      case selfEidolon:
        return PropSourceDisplay('eidolon'.tr() + desc, Colors.indigo);
      case relicSet:
        return PropSourceDisplay(RelicManager.getRelic(id).getName('lang'.tr()) + desc, Colors.purple);
      case relicMain:
        return PropSourceDisplay('relic'.tr(), Colors.teal);
      case relicSub:
        return PropSourceDisplay('relic'.tr(), Colors.teal);
    }
    return PropSourceDisplay(id.tr(), Colors.grey);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is PropSource) {
      return runtimeType == other.runtimeType &&
          id == other.id &&
          source == other.source &&
          name == other.name;
    } else {
      return false;
    }
  }
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + source.hashCode;
    result = 37 * result + name.hashCode;
    return result;
  }
}

class PropSourceDisplay {
  String source = '';
  MaterialColor color = Colors.grey;
  double? scale;

  PropSourceDisplay(String source, MaterialColor color) {
    this.source = source;
    this.color = color;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is PropSourceDisplay) {
      return runtimeType == other.runtimeType &&
          source == other.source &&
          color.value == other.color.value;
    } else {
      return false;
    }
  }
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + source.hashCode;
    result = 37 * result + color.value.hashCode;
    return result;
  }
}
