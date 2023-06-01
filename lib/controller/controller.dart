// ignore_for_file: use_build_context_synchronously, avoid_print, unused_local_variable

import 'dart:io';

import 'package:byte_converter/byte_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CompressorController extends GetxController {
  var imagesList = <File>[].obs;
  var compressQuality = <int>[].obs;
  TextEditingController textController = TextEditingController();
  var qualityValue = 0.obs;
  var isApplyToAll = true.obs;
  var isFixedValue = false.obs;
  var isValueSelected = <bool>[].obs;
  var valueSeletedItem = <Text>[
    const Text("10 KB"),
    const Text("25 KB"),
    const Text("50 KB"),
    const Text("100 KB"),
    const Text("150 KB"),
    const Text("250 KB"),
    const Text("300 KB"),
    const Text("400 KB"),
    const Text("500 KB"),
    const Text("750 KB"),
  ].obs;
  var isCompressing = false.obs;

  Future getImage() async {
    try {
      if (await Permission.storage.request().isGranted) {
        final List<XFile>? images = await ImagePicker().pickMultiImage();
        if (images == null) return;

        for (var element in images) {
          imagesList.add(File(element.path));
        }

        for (var element in imagesList) {
          compressQuality.add(100);
        }
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getImageCamera() async {
    try {
      if (await Permission.camera.request().isGranted) {
        final XFile? image = await ImagePicker().pickImage(
          source: ImageSource.camera,
        );
        if (image == null) return;

        imagesList.add(File(image.path));
        compressQuality.add(100);
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future deleteImage() async {
    try {
      imagesList.clear();
      compressQuality.clear();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future deleteImageOnIndex(int index) async {
    try {
      imagesList.removeAt(index);
      compressQuality.removeAt(index);
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getCompressQuality(BuildContext context, int index) async {
    try {
      if (isApplyToAll.value) {
        if (isFixedValue.value) {
          for (var i = 0; i < imagesList.length; i++) {
            compressQuality[i] = ((qualityValue.value /
                        ByteConverter(
                          imagesList[i].lengthSync().toDouble(),
                        ).kiloBytes) *
                    100)
                .toInt();
          }
        } else {
          for (var i = 0; i < imagesList.length; i++) {
            compressQuality[i] = int.tryParse(textController.text) ?? 0;
          }
        }
      } else {
        if (isFixedValue.value) {
          compressQuality[index] = ((qualityValue.value /
                      ByteConverter(
                        imagesList[index].lengthSync().toDouble(),
                      ).kiloBytes) *
                  100)
              .toInt();
        } else {
          compressQuality[index] = int.tryParse(textController.text) ?? 0;
        }
      }

      final List<int> results =
          compressQuality.where((element) => element > 100).toList();

      if (results.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${results.length} ${results.length == 1 ? "image" : "images"} quality cannot more than 100%",
            ),
          ),
        );

        for (var i = 0; i < compressQuality.length; i++) {
          if (compressQuality[i] > 100) {
            compressQuality[i] = 100;
          }
        }
      }

      textController.clear();
      Get.back();
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future getCompressQualityByte(BuildContext context, int value) async {
    try {
      qualityValue.value = value;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Size to $value KB",
          ),
        ),
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  Future compressImage(BuildContext context) async {
    try {
      if (imagesList.isNotEmpty &&
          compressQuality.isNotEmpty &&
          imagesList.length == compressQuality.length) {
        isCompressing.value = true;

        final List<int> results =
            compressQuality.where((element) => element > 100).toList();

        if (results.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "${results.length} ${results.length == 1 ? "image" : "images"} quality cannot more than 100%",
              ),
            ),
          );

          for (var i = 0; i < compressQuality.length; i++) {
            if (compressQuality[i] > 100) {
              compressQuality[i] = 100;
            }
          }
        }

        for (var i = 0; i < imagesList.length; i++) {
          var compressImage = await FlutterImageCompress.compressWithFile(
            imagesList[i].absolute.path,
            quality: compressQuality[i],
          );
          if (compressImage == null) return;
          final saveImage = await ImageGallerySaver.saveImage(
            compressImage,
            quality: 100,
          );
          print(saveImage);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "${imagesList.first.path} and ${imagesList.length - 1} more images have been saved.",
            ),
          ),
        );

        isCompressing.value = false;

        interstitialAd.show();
      }
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }
  }

  final BannerAd homeBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  final BannerAd compressBanner = BannerAd(
    adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    size: AdSize.banner,
    request: const AdRequest(),
    listener: const BannerAdListener(),
  );

  late InterstitialAd interstitialAd;
  var adIsLoaded = false.obs;
  var adsCount = 0.obs;

  Future loadInterstitialAd() async {
    try {
      InterstitialAd.load(
        adUnitId: 'ca-app-pub-3940256099942544/1033173712',
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            // Keep a reference to the ad so you can show it later.
            interstitialAd = ad;
            adIsLoaded.value = true;
            debugPrint(
                "ADS LOADED ADS LOADED ADS LOADED ADS LOADED ADS LOADED");
            interstitialAd.fullScreenContentCallback =
                FullScreenContentCallback(onAdDismissedFullScreenContent: (ad) {
              adIsLoaded.value = false;
              interstitialAd.dispose();
              loadInterstitialAd();
              // Get.back();
            }, onAdFailedToShowFullScreenContent: (ad, error) {
              adIsLoaded.value = false;
              interstitialAd.dispose();
              loadInterstitialAd();
              // Get.back();
            });
          },
          onAdFailedToLoad: (LoadAdError error) {
            debugPrint('InterstitialAd failed to load: $error');
          },
        ),
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void onInit() {
    // ignore: todo
    // TODO: implement onInit
    super.onInit();
    homeBanner.load();
    compressBanner.load();
    loadInterstitialAd();

    for (var element in valueSeletedItem) {
      isValueSelected.add(false);
    }
  }
}
