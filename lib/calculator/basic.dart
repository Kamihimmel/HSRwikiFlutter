import 'dart:core';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../characters/character_manager.dart';
import '../lightcones/lightcone_manager.dart';
import '../relics/relic.dart';
import '../relics/relic_manager.dart';
import '../utils/helper.dart';
import 'effect.dart';

enum FightProp {
  maxHP(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png', buffOrder: 7, effectKey: ['maxhp']),
  baseHP(desc: 'Base HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  hPDelta(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png', buffOrder: 7, effectKey: ['hppt']),
  hPAddedRatio(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png', buffOrder: 7, effectKey: ['hp']),

  attack(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png', buffOrder: 1, effectKey: ['allatk']),
  baseAttack(desc: 'Base ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  attackDelta(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png', buffOrder: 1, effectKey: ['atkpt']),
  attackAddedRatio(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png', buffOrder: 1, effectKey: ['atk']),

  defence(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png', buffOrder: 9, effectKey: ['alldef']),
  baseDefence(desc: 'Base DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  defenceDelta(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png', buffOrder: 9, effectKey: ['defpt']),
  defenceAddedRatio(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png', buffOrder: 9, effectKey: ['def']),

  maxSP(desc: 'Max Energy', icon: 'starrailres/icon/property/IconEnergyLimit.png'),
  sPRatio(desc: 'energyregenrate', icon: 'starrailres/icon/property/IconEnergyRecovery.png', buffOrder: 9, effectKey: ['sprate', 'energyregenrate']),
  sPDelta(desc: 'energyregenrate', icon: 'starrailres/icon/property/IconEnergyRecovery.png', buffOrder: 9, effectKey: ['energy']),
  sPRatioBase(desc: 'Energy Regeneration Rate', icon: 'starrailres/icon/property/IconEnergyRecovery.png'),

  speed(desc: 'speed', icon: 'starrailres/icon/property/IconSpeed.png', effectKey: ['spd']),
  baseSpeed(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png'),
  speedDelta(desc: 'speed', icon: 'starrailres/icon/property/IconSpeed.png', buffOrder: 6, effectKey: ['speedpt']),
  speedAddedRatio(desc: 'speed', icon: 'starrailres/icon/property/IconSpeed.png', buffOrder: 6, effectKey: ['speed']),
  actionForwardRatio(desc: 'speed', icon: 'starrailres/icon/property/IconSpeed.png', buffOrder: 6, effectKey: ['actionf']),

  aggro(desc: 'Taunt', icon: 'starrailres/icon/property/IconTaunt.png', buffOrder: 10, effectKey: ['taunt']),
  stanceBreakAddedRatio(desc: ''),

  healRatio(desc: 'healrate', icon: 'starrailres/icon/property/IconHealRatio.png', buffOrder: 9, effectKey: ['healrate']),
  healRatioBase(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  healTakenRatio(desc: 'Incoming Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  shieldAddRatio(desc: 'Shield Boost', buffOrder: 9, effectKey: ['shielddmgabsorb']),

  effectHitRate(desc: 'effecthit', icon: 'starrailres/icon/property/IconStatusProbability.png', buffOrder: 8, effectKey: ['effecthit']),
  effectHitRateBase(desc: 'Effect Hit', icon: 'starrailres/icon/property/IconStatusProbability.png'),
  effectResistenceRate(desc: 'effectres', icon: 'starrailres/icon/property/IconStatusResistance.png', buffOrder: 8, effectKey: ['effectres']),
  effectResistenceRateBase(desc: 'Effect RES', icon: 'starrailres/icon/property/IconStatusResistance.png'),

  criticalChance(desc: 'critrate', icon: 'starrailres/icon/property/IconCriticalChance.png', buffOrder: 2, effectKey: ['critrate']),
  criticalChanceBase(desc: 'CRIT Rate', icon: 'starrailres/icon/property/IconCriticalChance.png'),
  criticalDamage(desc: 'critdmg', icon: 'starrailres/icon/property/IconCriticalDamage.png', buffOrder: 2, effectKey: ['critdmg']),
  criticalDamageBase(desc: 'CRIT DMG', icon: 'starrailres/icon/property/IconCriticalDamage.png'),
  basicAttackCriticalChange(desc: 'normalcrit', buffOrder: 2, effectKey: ['basiccrit', 'normalcrit']),
  skillAttackCriticalChange(desc: 'skillcrit', buffOrder: 2, effectKey: ['skillcrit']),
  ultimateAttackCriticalChange(desc: 'ultcrit', buffOrder: 2, effectKey: ['ultcrit']),
  followupAttackCriticalChange(desc: 'followupcrit', buffOrder: 2, effectKey: ['followupcrit']),
  basicAttackCriticalDamage(desc: 'normalcritdmg', buffOrder: 2, effectKey: ['basiccritdmg', 'normalcritdmg']),
  skillAttackCriticalDamage(desc: 'skillcritdmg', buffOrder: 2, effectKey: ['skillcritdmg']),
  ultimateAttackCriticalDamage(desc: 'ultcritdmg', buffOrder: 2, effectKey: ['ultcritdmg']),
  followupAttackCriticalDamage(desc: 'followupcritdmg', buffOrder: 2, effectKey: ['followupcritdmg']),

  breakDamageAddedRatio(desc: 'breakeffect', buffOrder: 3, icon: 'starrailres/icon/property/IconBreakUp.png', effectKey: ['breakeffect', 'breakdmg']),
  breakDamageAddedRatioBase(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png'),

  allDamageAddRatio(desc: 'alldmg', buffOrder: 3, effectKey: ['alldmg']),
  physicalAddedRatio(desc: 'physicaldmg', buffOrder: 3, icon: 'starrailres/icon/property/IconPhysicalAddedRatio.png', effectKey: ['physicaldmg']),
  fireAddedRatio(desc: 'firedmg', buffOrder: 3, icon: 'starrailres/icon/property/IconFireAddedRatio.png', effectKey: ['firedmg']),
  iceAddedRatio(desc: 'icedmg', buffOrder: 3, icon: 'starrailres/icon/property/IconIceAddedRatio.png', effectKey: ['icedmg']),
  lightningAddedRatio(desc: 'lightningdmg', buffOrder: 3, icon: 'starrailres/icon/property/IconThunderAddedRatio.png', effectKey: ['lightningdmg']),
  windAddedRatio(desc: 'winddmg', buffOrder: 3, icon: 'starrailres/icon/property/IconWindAddedRatio.png', effectKey: ['winddmg']),
  quantumAddedRatio(desc: 'quantumdmg', buffOrder: 3, icon: 'starrailres/icon/property/IconQuantumAddedRatio.png', effectKey: ['quantumdmg']),
  imaginaryAddedRatio(desc: 'imaginarydmg', buffOrder: 3, icon: 'starrailres/icon/property/IconImaginaryAddedRatio.png', effectKey: ['imaginarydmg']),
  dotDamageAddRatio(desc: 'dotatk', buffOrder: 3, effectKey: ['dotatk']),
  additionalDamageAddRatio(desc: 'additionalatk', buffOrder: 3, effectKey: ['additionalatk']),
  basicAttackAddRatio(desc: 'normalatk', buffOrder: 3, effectKey: ['basicatk', 'normalatk']),
  skillAttackAddRatio(desc: 'skillatk', buffOrder: 3, effectKey: ['skillatk']),
  ultimateAttackAddRatio(desc: 'ultatk', buffOrder: 3, effectKey: ['ultatk']),
  followupAttackAddRatio(desc: 'followupatk', buffOrder: 3, effectKey: ['followupatk']),

  physicalResistance(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  fireResistance(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceResistance(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  lightningResistance(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windResistance(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumResistance(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryResistance(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),

  allResistanceIgnore(desc: 'allresreduce', buffOrder: 5, effectKey: ['allres']),
  specificResistanceIgnore(desc: 'specificresreduce', buffOrder: 5, effectKey: ['specificres']),
  physicalResistanceIgnore(desc: 'physicalpen', buffOrder: 5, effectKey: ['physicalpen']),
  fireResistanceIgnore(desc: 'firepen', buffOrder: 5, effectKey: ['firepen']),
  iceResistanceIgnore(desc: 'icepen', buffOrder: 5, effectKey: ['icepen']),
  lightningResistanceIgnore(desc: 'lightningpen', buffOrder: 5, effectKey: ['lightningpen']),
  windResistanceIgnore(desc: 'windpen', buffOrder: 5, effectKey: ['windpen']),
  quantumResistanceIgnore(desc: 'quantumpen', buffOrder: 5, effectKey: ['quantumpen']),
  imaginaryResistanceIgnore(desc: 'imaginarypen', buffOrder: 5, effectKey: ['imaginarypen']),
  defenceIgnoreRatio(desc: 'ignoredef', buffOrder: 5, effectKey: ['ignoredef']),

  physicalResistanceDelta(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  fireResistanceDelta(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceResistanceDelta(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  lightningResistanceDelta(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windResistanceDelta(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumResistanceDelta(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryResistanceDelta(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),

  controlResist(desc: 'controlresist', buffOrder: 9, effectKey: ['controlresist']),
  damageReduceRatio(desc: 'dmgreduction', buffOrder: 9, effectKey: ['dmgreduction']),

  skillpointreProbability(desc: 'skillpointre', buffOrder: 10, effectKey: ['skillpointre']),

  /// debuff start
  allDamageReceiveRatio(desc: 'dmgreceive', buffOrder: 4, debuff: true, effectKey: ['dmgreceive']),
  physicalDamageReceiveRatio(desc: 'physicaldmgreceive', buffOrder: 4, debuff: true, effectKey: ['physicaldmgreceive']),
  fireDamageReceiveRatio(desc: 'firedmgreceive', buffOrder: 4, debuff: true, effectKey: ['firedmgreceive']),
  iceDamageReceiveRatio(desc: 'icedmgreceive', buffOrder: 4, debuff: true, effectKey: ['icedmgreceive']),
  lightningDamageReceiveRatio(desc: 'lightningdmgreceive', buffOrder: 4, debuff: true, effectKey: ['lightningdmgreceive']),
  windDamageReceiveRatio(desc: 'winddmgreceive', buffOrder: 4, debuff: true, effectKey: ['winddmgreceive']),
  quantumDamageReceiveRatio(desc: 'quantumdmgreceive', buffOrder: 4, debuff: true, effectKey: ['quantumdmgreceive']),
  imaginaryDamageReceiveRatio(desc: 'imaginarydmgreceive', buffOrder: 4, debuff: true, effectKey: ['imaginarydmgreceive']),
  dotDamageReceiveRatio(desc: 'dotdmgreceive', buffOrder: 4, debuff: true, effectKey: ['dotdmgreceive']),
  additionalDamageReceiveRatio(desc: 'additionaldmgreceive', buffOrder: 4, debuff: true, effectKey: ['additionaldmgreceive']),

  defenceReduceRatio(desc: 'reducedefdebuff', buffOrder: 4, debuff: true, effectKey: ['reducedef']),
  speedReduceRatio(desc: 'reducespeeddebuff', buffOrder: 9, debuff: true, icon: 'starrailres/icon/property/IconSpeed.png', effectKey: ['reducespeed']),

  addWeaknessProbability(desc: 'addweakness', debuff: true, buffOrder: 10, effectKey: ['addweakness']),
  frozenProbability(desc: 'frozen', debuff: true, buffOrder: 10, effectKey: ['frozen']),
  burnProbability(desc: 'burn', debuff: true, buffOrder: 10, effectKey: ['burn']),
  bleedProbability(desc: 'bleed', debuff: true, buffOrder: 10, effectKey: ['bleed']),
  shockedProbability(desc: 'shocked', debuff: true, buffOrder: 10, effectKey: ['shocked']),
  windShearProbability(desc: 'windshear', debuff: true, buffOrder: 10, effectKey: ['windshear']),
  imprisonProbability(desc: 'imprison', debuff: true, buffOrder: 10, effectKey: ['imprison']),
  entanglementProbability(desc: 'entanglement', debuff: true, buffOrder: 10, effectKey: ['entanglement']),
  /// debuff end

  // 人为构造的属性
  breakDamageBase(desc: 'Base Break DMG', icon: 'starrailres/icon/property/IconBreakUp.png', effectKey: ['breakdmgbase']),
  lostHP(desc: 'losthp', effectKey: ['losthp']),
  lostHPRatio(desc: 'losthp', effectKey: ['losthpratio']),
  allDotDamage(desc: 'alldotdmg', effectKey: ['alldotdmg']),
  shockedDotDamage(desc: 'shockeddotdmg', effectKey: ['shockeddotdmg']),
  burnDotDamage(desc: 'burndotdmg', effectKey: ['burndotdmg']),
  windshearDotDamage(desc: 'windsheardotdmg', effectKey: ['windsheardotdmg']),
  bleedDotDamage(desc: 'bleeddotdmg', effectKey: ['bleeddotdmg']),

  none(desc: 'No multiplier'), // effect.multipliertarget == ''
  unknown(desc: '');

  final String desc;
  final String icon;
  final bool debuff;
  final int buffOrder;
  final List<String> effectKey;

  const FightProp({
    required this.desc,
    this.icon = '',
    this.debuff = false,
    this.buffOrder = 999,
    this.effectKey = const [],
  });

  bool isPercent() {
    return this.name.contains("Ratio") || this.name.endsWith("ResistanceIgnore") || this.name.endsWith("Resistance")
        || this.name.contains("Probability") || this.name.toLowerCase().contains("critical")
        || this.name.contains("Rate") || this.name == 'controlResist';
  }

  bool isProbability() {
    return this.name.endsWith("Probability");
  }

  String getPropText(double value, {bool? percent}) {
    return getDisplayText(value, percent ?? this.isPercent());
  }

  static List<FightProp> sortByBuffOrder(List<FightProp> props) {
    props.sort((p1, p2) => p1.buffOrder.compareTo(p2.buffOrder));
    return props;
  }

  static FightProp fromName(String name) {
    return FightProp.values.firstWhere((p) => p.name == name, orElse: () => FightProp.unknown);
  }

  /// 对应effect中addtarget
  static FightProp fromEffectKey(String effectKey) {
    return FightProp.values.firstWhere((p) => p.effectKey.contains(effectKey.toLowerCase()), orElse: () => FightProp.unknown);
  }

  /// 对应effect中multipliertarget
  static FightProp fromEffectMultiplier(String multiplierTarget) {
    if (multiplierTarget == 'atk') {
      return FightProp.attack;
    } else if (multiplierTarget == 'def') {
      return FightProp.defence;
    } else if (multiplierTarget == '') {
      return FightProp.none;
    }
    return FightProp.fromEffectKey(multiplierTarget);
  }

  static FightProp fromImportType(String importType) {
    if (importType == 'ThunderAddedRatio') {
      return FightProp.lightningAddedRatio;
    }
    String type = importType.replaceFirst('Base', '').toLowerCase();
    return FightProp.values.firstWhere((p) => p.name.toLowerCase() == type, orElse: () => FightProp.unknown);
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
  static const int manualBuff = 12;
  static const int unknown = 99;

  String id = '';
  String name = '';
  String desc = '';
  Effect effect = Effect.empty();
  int source = PropSource.unknown;
  bool base = false;

  PropSource.characterBasic(String id, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.selfBasic;
    this.base = true;
  }

  PropSource.characterSkill(String id, Effect effect, {name = '', desc = '', self = false}) {
    _setBase(id, name, desc);
    this.effect = effect;
    this.source = self ? PropSource.selfSkill : PropSource.otherSkill;
  }

  PropSource.characterTrace(String id, Effect effect, {name = '', desc = '', self = false}) {
    _setBase(id, name, desc);
    this.effect = effect;
    this.source = self ? PropSource.selfTrace : PropSource.otherTrace;
  }

  PropSource.characterEidolon(String id, Effect effect, {name = '', desc = '', self = false}) {
    _setBase(id, name, desc);
    this.effect = effect;
    this.source = self ? PropSource.selfEidolon : PropSource.otherEidolon;
  }

  PropSource.lightconeAttr(String id, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.lightconeBasic;
    this.base = true;
  }

  PropSource.lightconeEffect(String id, Effect effect, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.effect = effect;
    this.source = PropSource.lightconeSkill;
  }

  PropSource.relicAttr(RelicPart relicPart, {desc = '', mainAttr = false}) {
    _setBase(relicPart.name, relicPart.name, desc);
    this.source = mainAttr ? PropSource.relicMain : PropSource.relicSub;
  }

  PropSource.relicSetEffect(String id, Effect effect, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.effect = effect;
    this.source = PropSource.relicSet;
  }

  PropSource.manualEffect(String id, Effect effect, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.effect = effect;
    this.source = PropSource.manualBuff;
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
        return PropSourceDisplay(LightconeManager.getLightcone(effect.majorId).getSkillName(0, 'lang'.tr()), Colors.green);
      case selfSkill:
        return PropSourceDisplay(CharacterManager.getCharacter(effect.majorId).getSkillNameById(effect.minorId, 'lang'.tr()), Colors.lime);
      case selfTrace:
        return PropSourceDisplay(name == 'tiny' ? 'trace'.tr() : CharacterManager.getCharacter(effect.majorId).getTraceNameById(effect.minorId, 'lang'.tr()), Colors.amber);
      case selfEidolon:
        return PropSourceDisplay('eidolon'.tr() + effect.minorId, Colors.indigo);
      case relicSet:
        return PropSourceDisplay(RelicManager.getRelic(effect.majorId).getName('lang'.tr()) + effect.minorId, Colors.purple);
      case relicMain:
        return PropSourceDisplay('relic'.tr(), Colors.teal);
      case relicSub:
        return PropSourceDisplay('relic'.tr(), Colors.teal);
      case otherSkill:
        return PropSourceDisplay(effect.getSkillName('lang'.tr()), Colors.cyan);
      case manualBuff:
        return PropSourceDisplay('Manual Buff'.tr(), Colors.brown);
    }
    return PropSourceDisplay(id, Colors.grey);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is PropSource) {
      return runtimeType == other.runtimeType &&
          id == other.id &&
          source == other.source &&
          effect.getKey() == other.effect.getKey();
    } else {
      return false;
    }
  }
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + source.hashCode;
    result = 37 * result + effect.getKey().hashCode;
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
