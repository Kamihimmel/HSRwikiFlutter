// ignore: avoid_web_libraries_in_flutter
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

Widget adsenseAdsView(double swidth) {
  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'adViewType',
      (int viewID) => IFrameElement()
        ..width = '$swidth'
        ..height = '100'
        ..src = 'adview.html'
        ..style.border = 'none');

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(
      'adViewTypeshort',
      (int viewID) => IFrameElement()
        ..width = '$swidth'
        ..height = '100'
        ..src = 'adviewshort.html'
        ..style.border = 'none');

  if (swidth > 800) {
    return SizedBox(
      height: 100.0,
      width: swidth,
      child: HtmlElementView(
        viewType: 'adViewType',
      ),
    );
  } else {
    return SizedBox(
      height: 100.0,
      width: swidth,
      child: HtmlElementView(
        viewType: 'adViewTypeshort',
      ),
    );
  }
}
