import '../relics/relic.dart';

enum FightProp {
  maxHP(desc: 'HP', icon: 'starrailres/icon/property/IconMaxHP.png'),
  attack(desc: 'ATK', icon: 'starrailres/icon/property/IconAttack.png'),
  defence(desc: 'DEF', icon: 'starrailres/icon/property/IconDefence.png'),
  speed(desc: 'SPD', icon: 'starrailres/icon/property/IconSpeed.png'),
  criticalChance(desc: 'CRIT Rate', icon: 'starrailres/icon/property/IconCriticalChance.png', effectKey: ['critrate']),
  criticalDamage(desc: 'CRIT DMG', icon: 'starrailres/icon/property/IconCriticalDamage.png', effectKey: ['critdmg']),
  breakDamageAddedRatio(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png', effectKey: ['breakeffect']),
  breakDamageAddedRatioBase(desc: 'Break Effect', icon: 'starrailres/icon/property/IconBreakUp.png'),
  healRatio(desc: 'Outgoing Healing Boost', icon: 'starrailres/icon/property/IconHealRatio.png'),
  maxSP(desc: 'Max Energy', icon: 'starrailres/icon/property/IconEnergyLimit.png'),
  sPRatio(desc: 'Energy Regeneration Rate', icon: 'starrailres/icon/property/IconEnergyRecovery.png'),
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
  fireAddedRatio(desc: 'Fire DMG Boost', icon: 'starrailres/icon/property/IconFireAddedRatio.png', effectKey: ['firedmg']),
  fireResistance(desc: 'Fire RES Boost', icon: 'starrailres/icon/property/IconFireResistanceDelta.png'),
  iceAddedRatio(desc: 'Ice DMG Boost', icon: 'starrailres/icon/property/IconIceAddedRatio.png', effectKey: ['icedmg']),
  iceResistance(desc: 'Ice RES Boost', icon: 'starrailres/icon/property/IconIceResistanceDelta.png'),
  thunderAddedRatio(desc: 'Lightning DMG Boost', icon: 'starrailres/icon/property/IconThunderAddedRatio.png', effectKey: ['lightningdmg']),
  thunderResistance(desc: 'Lightning RES Boost', icon: 'starrailres/icon/property/IconThunderResistanceDelta.png'),
  windAddedRatio(desc: 'Wind DMG Boost', icon: 'starrailres/icon/property/IconWindAddedRatio.png', effectKey: ['winddmg']),
  windResistance(desc: 'Wind RES Boost', icon: 'starrailres/icon/property/IconWindResistanceDelta.png'),
  quantumAddedRatio(desc: 'Quantum DMG Boost', icon: 'starrailres/icon/property/IconQuantumAddedRatio.png', effectKey: ['quantumdmg']),
  quantumResistance(desc: 'Quantum RES Boost', icon: 'starrailres/icon/property/IconQuantumResistanceDelta.png'),
  imaginaryAddedRatio(desc: 'Imaginary DMG Boost', icon: 'starrailres/icon/property/IconImaginaryAddedRatio.png', effectKey: ['imaginarydmg']),
  imaginaryResistance(desc: 'Imaginary RES Boost', icon: 'starrailres/icon/property/IconImaginaryResistanceDelta.png'),
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
  dotDamageAddRatio(desc: '', icon: '', effectKey: ['dotvulnerability']),
  allDamageAddRatio(desc: '', icon: '', effectKey: ['alldmg']),
  none(desc: '', icon: '');

  final String desc;
  final String icon;
  final List<String> effectKey;

  const FightProp({
    required this.desc,
    required this.icon,
    this.effectKey = const [],
  });

  bool isPercent() {
    return this.name.contains("Ratio") || this.name.contains("Resistance") || this.name.contains("Probability") || this.name.contains("critical");
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
  static final int relicSet = 8;
  static final int otherSkill = 9;
  static final int otherTrace = 10;
  static final int otherEidolon = 11;
  static final int unknown = 99;

  String id = '';
  String name = '';
  String desc = '';
  int source = PropSource.unknown;

  PropSource.characterBasic(String id, {name = '', desc = ''}) {
    _setBase(id, name, desc);
    this.source = PropSource.selfBasic;
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is PropSource) {
      return runtimeType == other.runtimeType &&
          id == other.id &&
          source == other.source;
    } else {
      return false;
    }
  }
  @override
  int get hashCode {
    var result = 17;
    result = 37 * result + id.hashCode;
    result = 37 * result + source.hashCode;
    return result;
  }
}
