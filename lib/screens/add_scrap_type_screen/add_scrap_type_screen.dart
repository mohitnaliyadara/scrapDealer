import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:scrapdealer/api_services/add_scrap_type_api.dart';
import 'package:scrapdealer/api_services/delete_scrap_type_api.dart';
import 'package:scrapdealer/api_services/get_scrap_categoryApi.dart';
import 'package:scrapdealer/api_services/get_scrap_type_api.dart';

import 'package:scrapdealer/model/scrap_category_model.dart';
import 'package:scrapdealer/model/sub_category_model.dart';

import 'package:scrapdealer/screens/update_scrap/update_scrap_screen.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/shop_list_screen.dart';

import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';
import 'package:scrapdealer/widgets/custom_button.dart';
import 'package:scrapdealer/widgets/custom_text_filed.dart';

class AddScrapTypeScreen extends StatefulWidget {
  final String shop_id;
  const AddScrapTypeScreen({super.key, required this.shop_id});

  @override
  State<AddScrapTypeScreen> createState() => _AddScrapTypeScreenState();
}

class _AddScrapTypeScreenState extends State<AddScrapTypeScreen> {
  late Future<List<ScrapCategory>> categoryFuture;
  late Future<List<SubCategoryData>> subCategoryFuture;

  ScrapCategory? selectedCategory;

  final _scrapNameController = TextEditingController();
  final _scrapRateController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    categoryFuture = GetScrapCategoryApi.getScrapCategory(context);
    subCategoryFuture = GetScrapTypeApi.getScrapType(context, widget.shop_id);
  }

  ///  Refresh list
  void refreshSubCategory() {
    setState(() {
      subCategoryFuture = GetScrapTypeApi.getScrapType(context, widget.shop_id);
    });
  }

  ///  Add Scrap
  void addScrap() {
    if (_formKey.currentState!.validate()) {
      AddScrapTypeApi.addScrapType(
        selectedCategory!.categoryId.toString(),
        _scrapNameController.text.capitalize!,
        _scrapRateController.text,
        widget.shop_id,
        context,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,

      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Add Scrap",
          style: AppTextStyle.bold22(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Get.offAll(() => const ShopListScreen());
          },
        ),
      ),

      body: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            width: 320,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  FutureBuilder<List<ScrapCategory>>(
                    future: categoryFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      }
                      if (!snapshot.hasData) {
                        return const Text("No category found");
                      }

                      return DropdownButtonFormField<ScrapCategory>(
                        value: selectedCategory,
                        hint: const Text("Select Scrap Category"),
                        validator: (value) =>
                            value == null ? "Please select category" : null,
                        items: snapshot.data!.map((cat) {
                          return DropdownMenuItem(
                            value: cat,
                            child: Text(cat.categoryName!),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() => selectedCategory = value);
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  customTextFiled(
                    hintText: "Scrap Name",
                    controller: _scrapNameController,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter scrap name";
                      }
                      if (!value.isAlphabetOnly) {
                        return "Only alphabets allowed";
                      }
                      return null;
                    },
                  ),

                  customTextFiled(
                    hintText: "Scrap Rate",
                    controller: _scrapRateController,
                    textInputType: TextInputType.number,
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter scrap rate";
                      }
                      final rate = double.tryParse(value);
                      if (rate == null || rate <= 0 || rate > 10000) {
                        return "Rate must be between 1–10000";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  customButton(
                    text: "Submit",
                    onPress: addScrap,
                    width: double.infinity,
                    backcolor: AppColors.primaryColor,
                    textstyle: AppTextStyle.semiBold16(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: FutureBuilder<List<SubCategoryData>>(
              future: subCategoryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No scrap found"));
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final item = snapshot.data![index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        leading: Icon(
                          Icons.recycling,
                          color: AppColors.primaryColor,
                        ),
                        title: Text(
                          item.subName!,
                          style: AppTextStyle.semiBold16(),
                        ),
                        subtitle: Text("Rate: ₹ ${item.price}"),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                        ///  UPDATE
                        onTap: () async {
                          Get.to(
                            () => UpdateScrapScreen(subCategoryData: item),
                          )?.then((value) {
                            refreshSubCategory();
                          });
                        },

                        /// DELETE
                        onLongPress: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Delete"),
                              content: const Text(
                                "Are you sure you want to delete this item?",
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () async {
                                    await DeleteScrapTypeApi.deleteScrapType(
                                      item.subcategoryId.toString(),
                                      context,
                                    );
                                    Get.back();
                                    refreshSubCategory();
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                                TextButton(
                                  onPressed: Get.back,
                                  child: const Text("No"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
