// ignore_for_file: deprecated_member_use, must_be_immutable

import 'package:byte_converter/byte_converter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_compressor/controller/ads.dart';
import 'package:image_compressor/controller/controller.dart';

class CompressPage extends StatelessWidget {
  const CompressPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompressorController controller = Get.put(CompressorController());
    return Column(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: const <Widget>[
                  Expanded(child: DeleteAllButton()),
                  SizedBox(width: 10),
                  Expanded(child: PickCameraButton()),
                  SizedBox(width: 10),
                  Expanded(child: PickGalleryButton()),
                ],
              ),
              const SizedBox(height: 10),
              const Expanded(child: ImagePreview()),
              const SizedBox(height: 10),
              const CompressButton(),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ADS(ad: controller.homeBanner)
      ],
    );
  }
}

class ImagePreview extends StatelessWidget {
  const ImagePreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompressorController controller = Get.put(CompressorController());
    return Obx(
      () {
        if (controller.imagesList.isEmpty) {
          return const Center(
            child: Text("Choose Image"),
          );
        } else {
          if (controller.isCompressing.value) {
            return Center(
              child: CircularProgressIndicator(
                color: Colors.grey.shade700,
                semanticsLabel: "Compressing",
              ),
            );
          } else {
            return ListView.separated(
              padding: const EdgeInsets.all(0),
              itemCount: controller.imagesList.length,
              separatorBuilder: (context, index) {
                return const SizedBox(height: 10);
              },
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () async {
                    controller.textController.text =
                        controller.compressQuality[index].toString();
                    debugPrint(index.toString());
                    Get.bottomSheet(CompressQualityEdit(index: index));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    color: Colors.grey.shade800,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Stack(
                          children: <Widget>[
                            Image.file(
                              controller.imagesList[index],
                              fit: BoxFit.fill,
                            ),
                            Align(
                              alignment: Alignment.topRight,
                              child: Material(
                                color: Colors.transparent,
                                child: Container(
                                  color: Colors.grey.shade800.withOpacity(0.7),
                                  child: IconButton(
                                    onPressed: () =>
                                        controller.deleteImageOnIndex(index),
                                    icon: const Icon(Icons.delete_rounded),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Text(
                            "Original image size ${(ByteConverter(controller.imagesList[index].lengthSync().toDouble()).kiloBytes).toStringAsFixed(2)} KB",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Text(
                            "Set quality to ${controller.compressQuality[index]}%",
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(
                          () => Text(
                            "Size after compression ${(ByteConverter(controller.imagesList[index].lengthSync().toDouble()).kiloBytes * (controller.compressQuality[index] / 100)).toStringAsFixed(2)} KB",
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        }
      },
    );
  }
}

class PickGalleryButton extends StatelessWidget {
  const PickGalleryButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompressorController controller = Get.put(CompressorController());
    return ElevatedButton.icon(
      onPressed: () => controller.getImage(),
      // padding: const EdgeInsets.all(10),
      // color: Colors.grey.shade800,
      icon: const Icon(Icons.add_photo_alternate_rounded),
      label: const Text("Gallery"),
    );
    // FlatButton.icon(
    //   onPressed: () => controller.getImage(),
    //   padding: const EdgeInsets.all(10),
    //   color: Colors.grey.shade800,
    //   icon: const Icon(Icons.add_photo_alternate_rounded),
    //   label: const Text("Gallery"),
    // );
  }
}

class DeleteAllButton extends StatelessWidget {
  const DeleteAllButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompressorController controller = Get.put(CompressorController());
    return ElevatedButton.icon(
      onPressed: () => controller.deleteImage(),
      // padding: const EdgeInsets.all(10),
      // color: Colors.grey.shade800,
      icon: const Icon(Icons.delete_sweep_rounded),
      label: const Text("Delete All"),
    );
    // return FlatButton.icon(
    //   onPressed: () => controller.deleteImage(),
    //   padding: const EdgeInsets.all(10),
    //   color: Colors.grey.shade800,
    //   icon: const Icon(Icons.delete_sweep_rounded),
    //   label: const Text("Delete All"),
    // );
  }
}

class PickCameraButton extends StatelessWidget {
  const PickCameraButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompressorController controller = Get.put(CompressorController());
    return ElevatedButton.icon(
      onPressed: () => controller.getImageCamera(),
      // padding: const EdgeInsets.all(10),
      // color: Colors.grey.shade800,
      icon: const Icon(Icons.add_a_photo_rounded),
      label: const Text("Camera"),
    );
    // return FlatButton.icon(
    //   onPressed: () => controller.getImageCamera(),
    //   padding: const EdgeInsets.all(10),
    //   color: Colors.grey.shade800,
    //   icon: const Icon(Icons.add_a_photo_rounded),
    //   label: const Text("Camera"),
    // );
  }
}

class CompressQualityEdit extends StatelessWidget {
  int index;
  CompressQualityEdit({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompressorController controller = Get.put(CompressorController());
    return Container(
      padding: const EdgeInsets.all(10),
      height: MediaQuery.of(context).size.height / 2,
      color: Colors.grey.shade800,
      child: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: <Widget>[
                Obx(
                  () => CheckboxListTile(
                    value: controller.isFixedValue.value,
                    onChanged: (value) =>
                        controller.isFixedValue.value = value!,
                    title: const Text("Use fixed size?"),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: !controller.isFixedValue.value,
                    child: TextField(
                      controller: controller.textController,
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      onChanged: (value) {
                        if ((int.tryParse(value) ?? 0) > 100) {
                          controller.textController.text = "100";
                        }
                      },
                      decoration: const InputDecoration(
                        label: Text("Size"),
                        hintText: "size in percentage",
                        suffix: Text("%"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Obx(
                    () => Visibility(
                      visible: controller.isFixedValue.value,
                      child: ToggleButtons(
                        color: Colors.grey.shade400,
                        selectedColor: Colors.white,
                        fillColor: Colors.blueGrey.shade700,
                        onPressed: (int index) {
                          for (int buttonIndex = 0;
                              buttonIndex < controller.isValueSelected.length;
                              buttonIndex++) {
                            if (buttonIndex == index) {
                              controller.isValueSelected[buttonIndex] =
                                  !controller.isValueSelected[buttonIndex];
                              controller.getCompressQualityByte(
                                  context,
                                  int.tryParse(controller
                                          .valueSeletedItem[buttonIndex].data
                                          .toString()
                                          .split(" ")
                                          .first) ??
                                      0);
                            } else {
                              controller.isValueSelected[buttonIndex] = false;
                            }
                          }
                        },
                        isSelected: controller.isValueSelected,
                        children: controller.valueSeletedItem
                            .map((element) => Padding(
                                  padding: EdgeInsets.all(10),
                                  child: element,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                ),
                Obx(
                  () => CheckboxListTile(
                    value: controller.isApplyToAll.value,
                    onChanged: (newValue) {
                      controller.isApplyToAll.value = newValue!;
                    },
                    title: const Text("Apply to all"),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: () =>
                      controller.getCompressQuality(context, index),
                  // padding: const EdgeInsets.all(10),
                  // color: Colors.grey.shade700,
                  icon: const Icon(Icons.save_rounded),
                  label: const Text("Saved"),
                ),
                // FlatButton.icon(
                //   onPressed: () =>
                //       controller.getCompressQuality(context, index),
                //   padding: const EdgeInsets.all(10),
                //   color: Colors.grey.shade700,
                //   icon: const Icon(Icons.save_rounded),
                //   label: const Text("Saved"),
                // ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          ADS(ad: controller.compressBanner),
        ],
      ),
    );
  }
}

class CompressButton extends StatelessWidget {
  const CompressButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CompressorController controller = Get.put(CompressorController());
    return ElevatedButton.icon(
      onPressed: () => controller.compressImage(context),
      // padding: const EdgeInsets.all(10),
      // color: Colors.grey.shade800,
      icon: const Icon(Icons.compress_rounded),
      label: const Text("Start Compressing"),
    );
    // FlatButton.icon(
    //   onPressed: () => controller.compressImage(context),
    //   padding: const EdgeInsets.all(10),
    //   color: Colors.grey.shade800,
    //   icon: const Icon(Icons.compress_rounded),
    //   label: const Text("Start Compressing"),
    // );
  }
}
