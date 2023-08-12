import '../relics/relic.dart';

enum FightProp {
  maxHP(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  attack(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  defence(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  speed(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png'),
  criticalChance(desc: 'CRIT Rate', icon: 'starrailres/icon/property/IconCriticalChance.png'),
  criticalDamage(desc: 'CRIT DMG', icon: 'starrailres/icon/property/IconCriticalDamage.png'),
  breakDamageAddedRatio(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png'),
  breakDamageAddedRatioBase(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png'),
  healRatio(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  maxSP(desc: 'Max Energy', icon: 'starrailres/icon/property/IconEnergyLimit.png'),
  sPRatio(desc: 'Energy Regeneration Rate', icon: 'starrailres/icon/property/IconEnergyRecovery.png'),
  statusProbability(desc: 'Effect Hit Rate', icon: 'starrailres/icon/property/IconStatusProbability.png'),
  statusResistance(desc: 'Effect RES', icon: 'starrailres/icon/property/IconStatusResistance.png'),
  criticalChanceBase(desc: 'CRIT Rate', icon: 'starrailres/icon/property/IconCriticalChance.png'),
  criticalDamageBase(desc: 'CRIT DMG', icon: 'starrailres/icon/property/IconCriticalDamage.png'),
  healRatioBase(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  stanceBreakAddedRatio(desc: '', icon: ''),
  sPRatioBase(desc: 'Energy Regeneration Rate', icon: 'starrailres/icon/property/IconEnergyRecovery.png'),
  statusProbabilityBase(desc: 'Effect Hit Rate', icon: 'starrailres/icon/property/IconStatusProbability.png'),
  statusResistanceBase(desc: 'Effect RES', icon: 'starrailres/icon/property/IconStatusResistance.png'),
  physicalAddedRatio(desc: 'Physical DMG Boost', icon: 'starrailres/icon/property/IconPhysicalAddedRatio.png'),
  physicalResistance(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  fireAddedRatio(desc: 'Fire DMG Boost', icon: 'starrailres/icon/property/IconFireAddedRatio.png'),
  fireResistance(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceAddedRatio(desc: 'Ice DMG Boost', icon: 'starrailres/icon/property/IconIceAddedRatio.png'),
  iceResistance(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  thunderAddedRatio(desc: 'Lightning DMG Boost', icon: 'starrailres/icon/property/IconThunderAddedRatio.png'),
  thunderResistance(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windAddedRatio(desc: 'Wind DMG Boost', icon: 'starrailres/icon/property/IconWindAddedRatio.png'),
  windResistance(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumAddedRatio(desc: 'Quantum DMG Boost', icon: 'starrailres/icon/property/IconQuantumAddedRatio.png'),
  quantumResistance(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryAddedRatio(desc: 'Imaginary DMG Boost', icon: 'starrailres/icon/property/IconImaginaryAddedRatio.png'),
  imaginaryResistance(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),
  baseHP(desc: 'Base HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  hPDelta(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  hPAddedRatio(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  baseAttack(desc: 'Base ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  attackDelta(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  attackAddedRatio(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  baseDefence(desc: 'Base DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  defenceDelta(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  defenceAddedRatio(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  baseSpeed(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png'),
  healTakenRatio(desc: 'Incoming Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  physicalResistanceDelta(desc: 'Physical RES Boost', icon: 'starrailres/icon/property/IconPhysicalResistanceDelta.png'),
  fireResistanceDelta(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceResistanceDelta(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  thunderResistanceDelta(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windResistanceDelta(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumResistanceDelta(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryResistanceDelta(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),
  speedDelta(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png'),
  aggro(desc: 'Taunt', icon: 'starrailres/icon/property/IconTaunt.png'),
  allDamageAddRatio(desc: '', icon: ''),
  none(desc: '', icon: '');

  final String desc;
  final String icon;

  const FightProp({
    required this.desc,
    required this.icon,
  });

  bool isPercent() {
    return this.name.contains("Ratio") || this.name.contains("Resistance") || this.name.contains("Probability") || this.name.contains("critical");
  }

  static FightProp fromName(String name) {
    return FightProp.values.firstWhere((p) => p.name == name, orElse: () => FightProp.none);
  }

  static FightProp fromImportType(String importType) {
    String type = importType.replaceFirst('Base', '').toLowerCase();
    return FightProp.values.firstWhere((p) => p.name.toLowerCase() == type, orElse: () => FightProp.none);
  }
}

class PropSource {
  static final int selfBasic = 0;
  static final int lightconeBasic = 1;
  static final int selfSkill = 2;
  static final int selfTrace = 3;
  static final int selfEidolon = 4;
  static final int lightconeSkill = 5;
  static final int relicMain = 6;
  static final int relicSub = 7;
  static final int otherSkill = 8;
  static final int otherTrace = 9;
  static final int otherEidolon = 10;
  static final int unknown = 99;

  String id = '';
  String name = '';
  String desc = '';
  int source = PropSource.unknown;

  PropSource.characterBasic(String id, String name, {desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.selfBasic;
  }

  PropSource.characterSkill(String id, String name, {desc = '', self = false}) {
    _setBase(id, name, desc);
    this.source = self ? PropSource.selfSkill : PropSource.otherSkill;
  }

  PropSource.characterTrace(String id, String name, {desc = '', self = false}) {
    _setBase(id, name, desc);
    this.source = self ? PropSource.selfTrace : PropSource.otherTrace;
  }

  PropSource.characterEidolon(String id, String name, {desc = '', self = false}) {
    _setBase(id, name, desc);
    this.source = self ? PropSource.selfEidolon : PropSource.otherEidolon;
  }

  PropSource.lightconeAttr(String id, String name, {desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.lightconeBasic;
  }

  PropSource.lightconeEffect(String id, String name, {desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.lightconeSkill;
  }

  PropSource.relicAttr(RelicPart relicPart, {desc = '', mainAttr = false}) {
    _setBase(relicPart.name, relicPart.name, desc);
    this.source = mainAttr ? PropSource.relicMain : PropSource.relicSub;
  }

  _setBase(String id, String name, String desc) {
    this.id = id;
    this.name = name;
    this.desc = desc;
  }
}
