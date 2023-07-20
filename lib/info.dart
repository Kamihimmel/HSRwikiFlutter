import 'package:flutter/material.dart';

const etocolor = {
  'fire': Colors.red,
  'ice': Colors.lightBlue,
  'lightning': Colors.purple,
  'thunder': Colors.purple,
  'imaginary': Colors.yellow,
  'quantum': Colors.indigo,
  'wind': Colors.green,
  'physical': Colors.grey,
};

const etoimage = {
  'fire': "images/icons/fire.webp",
  'ice': "images/icons/ice.webp",
  'lightning': "images/icons/lightning.webp",
  'imaginary': "images/icons/imaginary.webp",
  'quantum': "images/icons/quantum.webp",
  'wind': "images/icons/wind.webp",
  'physical': "images/icons/physical.webp",
};

const wtoimage = {
  'destruction': "images/icons/destruction.webp",
  'erudition': "images/icons/erudition.webp",
  'harmony': "images/icons/harmony.webp",
  'thehunt': "images/icons/thehunt.webp",
  'nihility': "images/icons/nihility.webp",
  'abundance': "images/icons/abundance.webp",
  'preservation': "images/icons/preservation.webp",
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
bool cnmode = false;

String urlendpoint = "https://hsrwikidata.kchlu.com/";

Map<String, String> idtoimage = {};
