import 'package:flutter/material.dart';

const etocolor = {
  'fire': Colors.red,
  'ice': Colors.lightBlue,
  'lightning': Colors.purple,
  'imaginary': Colors.yellow,
  'quantum': Colors.indigo,
  'wind': Colors.green,
  'physical': Colors.grey,
};

const etoimage = {
  'fire': "https://hsrwikidata.kchlu.com/images/icons/fire.webp",
  'ice': "https://hsrwikidata.kchlu.com/images/icons/ice.webp",
  'lightning': "https://hsrwikidata.kchlu.com/images/icons/lightning.webp",
  'imaginary': "https://hsrwikidata.kchlu.com/images/icons/imaginary.webp",
  'quantum': "https://hsrwikidata.kchlu.com/images/icons/quantum.webp",
  'wind': "https://hsrwikidata.kchlu.com/images/icons/wind.webp",
  'physical': "https://hsrwikidata.kchlu.com/images/icons/physical.webp",
};

const wtoimage = {
  'destruction': "https://hsrwikidata.kchlu.com/images/icons/destruction.webp",
  'erudition': "https://hsrwikidata.kchlu.com/images/icons/erudition.webp",
  'harmony': "https://hsrwikidata.kchlu.com/images/icons/harmony.webp",
  'thehunt': "https://hsrwikidata.kchlu.com/images/icons/thehunt.webp",
  'nihility': "https://hsrwikidata.kchlu.com/images/icons/nihility.webp",
  'abundance': "https://hsrwikidata.kchlu.com/images/icons/abundance.webp",
  'preservation': "https://hsrwikidata.kchlu.com/images/icons/preservation.webp",
};

const stattoimage = {
  'hp': AssetImage('images/IconMaxHP.png'),
  'atk': AssetImage('images/IconAttack.png'),
  'def': AssetImage('images/IconDefence.png'),
  'speed': AssetImage('images/IconSpeed.png'),
  'taunt': AssetImage('images/IconBuffTaunt.png'),
  'critdmg': AssetImage('images/IconCriticalDamage.png'),
  'energylimit': AssetImage('images/IconEnergyLimit.png'),
  'winddmg': AssetImage('images/IconWindAddedRatio.png'),
  'icedmg': AssetImage('images/IconIceAddedRatio.png'),
  'effectres': AssetImage('images/IconStatusResistance.png'),
  'effecthit': AssetImage('images/IconStatusProbability.png'),
  'energyrecovery': AssetImage('images/IconEnergyRecovery.png'),
  'breakup': AssetImage('images/IconBreakUp.png'),
  'imaginarydmg': AssetImage('images/IconImaginaryAddedRatio.png'),
  'critrate': AssetImage('images/IconCriticalChance.png'),
  'lightningdmg': AssetImage('images/IconThunderAddedRatio.png'),
  'physicaldmg': AssetImage('images/IconPhysicalAddedRatio.png'),
  'firedmg': AssetImage('images/IconFireAddedRatio.png'),
  'quantumdmg': AssetImage('images/IconQuantumAddedRatio.png'),
  'breakeffect': AssetImage('images/IconBreakUp.png'),
};

const sicontoimage = {
  'avatar': AssetImage('images/DataBankIconAvatar.png'),
  'lightcone': AssetImage('images/DataBankIconLightCone.png'),
  'relic': AssetImage('images/DataBankIconRelics.png'),
};

var typetocolor = {'dmg': Colors.redAccent, 'debuff': Colors.grey[400], 'shield': Colors.blueAccent, 'heal': Colors.lime, 'revive': Colors.green};

bool gender = true;
bool spoilermode = false;
bool testmode = false;
