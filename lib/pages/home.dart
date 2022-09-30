// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:image_compressor/pages/compress.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + 10,
            right: MediaQuery.of(context).padding.right + 10,
            bottom: MediaQuery.of(context).padding.bottom + 10,
            left: MediaQuery.of(context).padding.left + 10,
          ),
          child: const CompressPage(),
        ),
      ),
    );
  }
}
