// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class ADS extends StatelessWidget {
  AdWithView ad;
  ADS({Key? key, required this.ad}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: AdSize.banner.width.toDouble(),
      height: AdSize.banner.height.toDouble(),
      child: AdWidget(ad: ad),
    );
  }
}
