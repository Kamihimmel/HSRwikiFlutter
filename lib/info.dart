import 'package:flutter/material.dart';

const bannericon = {
  'apple': AssetImage('images/applebanner.png'),
  'google': AssetImage('images/googlebanner.png'),
  'microsoft': AssetImage('images/microsoftbanner.png'),
};

var typetocolor = {'dmg': Colors.redAccent, 'debuff': Colors.grey[400], 'shield': Colors.blueAccent, 'heal': Colors.lime, 'revive': Colors.green};

bool gender = true;
bool spoilermode = false;
bool testmode = false;
bool cnmode = false;

String urlendpoint = "https://hsrwikidata.kchlu.com/";

Map<String, String> idtoimage = {};

String versionstring = "2.0.1.48";
