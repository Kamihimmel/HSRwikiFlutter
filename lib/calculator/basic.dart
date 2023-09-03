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
  maxHP(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png', effectKey: ['maxhp']),
  baseHP(desc: 'Base HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  hPDelta(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  hPAddedRatio(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png', effectKey: ['hp']),
  lostHP(desc: 'Lost HP', effectKey: ['losthp']),

  attack(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png', effectKey: ['allatk']),
  baseAttack(desc: 'Base ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  attackDelta(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  attackAddedRatio(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png', effectKey: ['atk']),

  defence(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png', effectKey: ['alldef']),
  baseDefence(desc: 'Base DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  defenceDelta(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  defenceAddedRatio(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png', effectKey: ['def']),

  maxSP(desc: 'Max Energy', icon: 'starrailres/icon/property/IconEnergyLimit.png'),
  sPRatio(desc: 'energyregenrate', icon: 'starrailres/icon/property/IconEnergyRecovery.png', effectKey: ['sprate', 'energyregenrate']),
  sPRatioBase(desc: 'Energy Regeneration Rate', icon: 'starrailres/icon/property/IconEnergyRecovery.png'),

  speed(desc: 'Speed', icon: 'starrailres/icon/property/IconSpeed.png', effectKey: ['spd']),
  baseSpeed(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png'),
  speedDelta(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png', effectKey: ['speed']),

  aggro(desc: 'Taunt', icon: 'starrailres/icon/property/IconTaunt.png', effectKey: ['taunt']),
  stanceBreakAddedRatio(desc: ''),

  healRatio(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png', effectKey: ['healrate']),
  healRatioBase(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  healTakenRatio(desc: 'Incoming Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  shieldAddRatio(desc: 'Shield Boost', effectKey: ['shielddmgabsorb']),

  statusProbability(desc: 'effecthit', icon: 'starrailres/icon/property/IconStatusProbability.png', effectKey: ['effecthit']),
  statusProbabilityBase(desc: 'Effect Hit Rate', icon: 'starrailres/icon/property/IconStatusProbability.png'),
  statusResistance(desc: 'effectres', icon: 'starrailres/icon/property/IconStatusResistance.png', effectKey: ['effectres']),
  statusResistanceBase(desc: 'Effect RES', icon: 'starrailres/icon/property/IconStatusResistance.png'),

  criticalChance(desc: 'critrate', icon: 'starrailres/icon/property/IconCriticalChance.png', effectKey: ['critrate']),
  criticalChanceBase(desc: 'CRIT Rate', icon: 'starrailres/icon/property/IconCriticalChance.png'),
  criticalDamage(desc: 'critdmg', icon: 'starrailres/icon/property/IconCriticalDamage.png', effectKey: ['critdmg']),
  criticalDamageBase(desc: 'CRIT DMG', icon: 'starrailres/icon/property/IconCriticalDamage.png'),
  basicAttackCriticalChange(desc: 'Basic Critical Change', effectKey: ['basiccrit', 'normalcrit']),
  skillAttackCriticalChange(desc: 'Skill Critical Change', effectKey: ['skillcrit']),
  ultimateAttackCriticalChange(desc: 'Ultimate Critical Change', effectKey: ['ultcrit']),
  followupAttackCriticalChange(desc: 'Followup Critical Change', effectKey: ['followupcrit']),
  basicAttackCriticalDamage(desc: 'Basic Critical Damage', effectKey: ['basiccritdmg', 'normalcritdmg']),
  skillAttackCriticalDamage(desc: 'Skill Critical Damage', effectKey: ['skillcritdmg']),
  ultimateAttackCriticalDamage(desc: 'Ultimate Critical Damage', effectKey: ['ultcritdmg']),
  followupAttackCriticalDamage(desc: 'Followup Critical Damage', effectKey: ['followupcritdmg']),

  breakDamageAddedRatio(desc: 'breakeffect', icon: 'starrailres/icon/property/IconBreakUp.png', effectKey: ['breakeffect', 'breakdmg']),
  breakDamageAddedRatioBase(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png'),

  allDamageAddRatio(desc: 'All DMG Boost', effectKey: ['alldmg']),
  physicalAddedRatio(desc: 'Physical DMG Boost', icon: 'starrailres/icon/property/IconPhysicalAddedRatio.png', effectKey: ['physicaldmg']),
  fireAddedRatio(desc: 'Fire DMG Boost', icon: 'starrailres/icon/property/IconFireAddedRatio.png', effectKey: ['firedmg']),
  iceAddedRatio(desc: 'Ice DMG Boost', icon: 'starrailres/icon/property/IconIceAddedRatio.png', effectKey: ['icedmg']),
  lightningAddedRatio(desc: 'Lightning DMG Boost', icon: 'starrailres/icon/property/IconThunderAddedRatio.png', effectKey: ['lightningdmg']),
  windAddedRatio(desc: 'Wind DMG Boost', icon: 'starrailres/icon/property/IconWindAddedRatio.png', effectKey: ['winddmg']),
  quantumAddedRatio(desc: 'Quantum DMG Boost', icon: 'starrailres/icon/property/IconQuantumAddedRatio.png', effectKey: ['quantumdmg']),
  imaginaryAddedRatio(desc: 'Imaginary DMG Boost', icon: 'starrailres/icon/property/IconImaginaryAddedRatio.png', effectKey: ['imaginarydmg']),
  dotDamageAddRatio(desc: 'Dot ATK Boost', effectKey: ['dotatk']),
  basicAttackAddRatio(desc: 'Basic ATK Boost', effectKey: ['basicatk', 'normalatk']),
  skillAttackAddRatio(desc: 'Skill ATK Boost', effectKey: ['skillatk']),
  ultimateAttackAddRatio(desc: 'Ultimate ATK Boost', effectKey: ['ultatk']),
  followupAttackAddRatio(desc: 'Followup ATK Boost', effectKey: ['followupatk']),

  physicalResistance(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  fireResistance(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceResistance(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  lightningResistance(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windResistance(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumResistance(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryResistance(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),

  allResistanceIgnore(desc: 'All RES Ignore', effectKey: ['allres']),
  physicalResistanceIgnore(desc: 'physicalpen', effectKey: ['physicalpen']),
  fireResistanceIgnore(desc: 'firepen', effectKey: ['firepen']),
  iceResistanceIgnore(desc: 'icepen', effectKey: ['icepen']),
  lightningResistanceIgnore(desc: 'lightningpen', effectKey: ['lightningpen']),
  windResistanceIgnore(desc: 'windpen', effectKey: ['windpen']),
  quantumResistanceIgnore(desc: 'quantumpen', effectKey: ['quantumpen']),
  imaginaryResistanceIgnore(desc: 'imaginarypen', effectKey: ['imaginarypen']),

  physicalResistanceDelta(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  fireResistanceDelta(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceResistanceDelta(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  lightningResistanceDelta(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windResistanceDelta(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumResistanceDelta(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryResistanceDelta(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),

  allDamageReceiveRatio(desc: 'All Damage Receive', debuff: true, effectKey: ['dmgreceive']),
  physicalDamageReceiveRatio(desc: 'Physical Damage Receive', debuff: true, effectKey: ['physicaldmgreceive']),
  fireDamageReceiveRatio(desc: 'Fire Damage Receive', debuff: true, effectKey: ['firedmgreceive']),
  iceDamageReceiveRatio(desc: 'Ice Damage Receive', debuff: true, effectKey: ['icedmgreceive']),
  lightningDamageReceiveRatio(desc: 'Lightning Damage Receive', debuff: true, effectKey: ['lightningdmgreceive']),
  windDamageReceiveRatio(desc: 'Wind Damage Receive', debuff: true, effectKey: ['winddmgreceive']),
  quantumDamageReceiveRatio(desc: 'Quantum Damage Receive', debuff: true, effectKey: ['quantumdmgreceive']),
  imaginaryDamageReceiveRatio(desc: 'Imaginary Damage Receive', debuff: true, effectKey: ['imaginarydmgreceive']),
  dotDamageReceiveRatio(desc: 'Dot Damage Receive', debuff: true, effectKey: ['dotdmgreceive']),

  defenceIgnoreRatio(desc: 'Defence Ignore', effectKey: ['ignoredef']),
  defenceReduceRatio(desc: 'Defence Reduce', debuff: true, effectKey: ['reducedef']),

  controlResist(desc: 'Control Resist', effectKey: ['controlresist']),

  none(desc: 'No multiplier'),
  unknown(desc: 'Unknown');

  final String desc;
  final String icon;
  final bool debuff;
  final List<String> effectKey;

  const FightProp({
    required this.desc,
    this.icon = '',
    this.debuff = false,
    this.effectKey = const [],
  });

  bool isPercent() {
    return this.name.contains("Ratio") || this.name.contains("Resistance") || this.name.contains("Probability") || this.name.contains("critical") || this.name.contains("Critical");
  }

  String getPropText(double value) {
    return getDisplayText(value, isPercent());
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
    } else if (multiplierTarget == 'maxhp') {
      return FightProp.maxHP;
    } else if (multiplierTarget == 'def') {
      return FightProp.defence;
    } else if (multiplierTarget == 'losthp') {
      return FightProp.lostHP;
    } else if (multiplierTarget == '') {
      return FightProp.none;
    }
    return FightProp.unknown;
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
        return PropSourceDisplay('manual'.tr(), Colors.brown);
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
