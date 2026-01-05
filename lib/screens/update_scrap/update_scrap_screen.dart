import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/api_services/update_scrap_api.dart';
import 'package:scrapdealer/model/sub_category_model.dart';
import 'package:scrapdealer/utils/app_style.dart';
import 'package:scrapdealer/widgets/custom_text_filed.dart';

import '../../utils/app_colors.dart';
import '../../widgets/custom_button.dart';

class UpdateScrapScreen extends StatefulWidget {
  final SubCategoryData subCategoryData;

  const UpdateScrapScreen({super.key, required this.subCategoryData});

  @override
  State<UpdateScrapScreen> createState() => _UpdateScrapScreenState();
}

class _UpdateScrapScreenState extends State<UpdateScrapScreen> {
  late TextEditingController _subScrapCategoryController;
  late TextEditingController _scrapRateController;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrapRateController = TextEditingController(
      text: widget.subCategoryData.price,
    );
    _subScrapCategoryController = TextEditingController(
      text: widget.subCategoryData.subName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Update Scrap",
          style: AppTextStyle.bold22(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
        ),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            SizedBox(height: 40),
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.whiteColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      customTextFiled(
                        hintText: "Sub Scrap Category",
                        controller: _subScrapCategoryController,
                        enable: false,
                      ),
                      customTextFiled(
                        hintText: "Sub Scrap Rate",
                        controller: _scrapRateController,
                        validation: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter scrap rate";
                          }
                          final digitRegex = RegExp(r'^[0-9]+$');
                          if (!digitRegex.hasMatch(value)) {
                            return "Only digits allowed";
                          }

                          final double rate = double.parse(value);

                          if (rate <= 0 || rate > 10000) {
                            return "Please enter valid rate (1 - 10000)";
                          }

                          return null;
                        },
                      ),
                      customButton(
                        topmargin: 0,
                        text: "Submit",
                        onPress: () {
                          if (_globalKey.currentState!.validate()) {
                            UpdateScrapApi.updateScrap(
                              context,
                              widget.subCategoryData.subcategoryId.toString(),
                              _scrapRateController.text,
                            );
                          }
                        },
                        width: double.infinity,
                        backcolor: AppColors.primaryColor,
                        textstyle: AppTextStyle.semiBold16(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
