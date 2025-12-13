import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:scrapdealer/api_services/add_scrap_type_api.dart';
import 'package:scrapdealer/api_services/get_scrap_categoryApi.dart';
import 'package:scrapdealer/api_services/get_scrap_type_api.dart';
import 'package:scrapdealer/model/scrap_category_model.dart';
import 'package:scrapdealer/model/sub_category_model.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/shop_list_screen.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/widgets/custom_button.dart';
import 'package:scrapdealer/widgets/custom_text_filed.dart';

import '../../utils/app_style.dart';

class AddScrapTypeScreen extends StatefulWidget {
  final String shop_id;
  const AddScrapTypeScreen({super.key, required this.shop_id});

  @override
  State<AddScrapTypeScreen> createState() => _AddScrapTypeScreenState();
}

class _AddScrapTypeScreenState extends State<AddScrapTypeScreen> {
  late Future<List<ScrapCategory>> data;
  late Future<List<SubCategoryData>> subCategory;
  ScrapCategory? selectedCategory;
  final TextEditingController _scrapNameController = TextEditingController();
  final TextEditingController _scrapRateController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    data = GetScrapCategoryApi.getScrapCategory(context);
    subCategory = GetScrapTypeApi.getScrapType(context, widget.shop_id);
  }

  void pageRefresh() {
    Future.delayed(Duration(seconds: 3), () {
      setState(() {
        subCategory = GetScrapTypeApi.getScrapType(context, widget.shop_id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          "Add Scrap",
          style: AppTextStyle.bold22(color: Colors.white),
        ),
        leading: IconButton(
          onPressed: () {
            Get.offAll(() => ShopListScreen());
          },
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.whiteColor),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Container(
              height: 370,
              width: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),

                color: AppColors.whiteColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _globalKey,
                  child: Column(
                    children: [
                      FutureBuilder(
                        future: data,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text("Error: ${snapshot.error}"),
                            );
                          } else if (!snapshot.hasData) {
                            return Center(child: Text("No category found"));
                          } else {
                            final category = snapshot.data!;

                            return DropdownButtonFormField<ScrapCategory>(
                              value: selectedCategory,
                              hint: Text("Select Scrap Category"),
                              borderRadius: BorderRadius.circular(15),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value == null) {
                                  return "Please select category";
                                }
                                return null;
                              },
                              items: category.map((cat) {
                                return DropdownMenuItem<ScrapCategory>(
                                  value: cat,
                                  child: Text(cat.categoryName.toString()),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedCategory = value;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      customTextFiled(
                        hintText: "Scrap Name",
                        controller: _scrapNameController,

                        validation: (value) {
                          if (value!.isEmpty) {
                            return "Please enter scrap name";
                          }
                          if (!value.isAlphabetOnly) {
                            return "Please enter valid scrap name";
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
                        text: "Submit",
                        onPress: () {
                          if (_globalKey.currentState!.validate()) {
                            AddScrapTypeApi.addScrapType(
                              selectedCategory!.categoryId.toString(),
                              _scrapNameController.text.capitalize.toString(),
                              _scrapRateController.text,
                              widget.shop_id,
                              context,
                            );
                          }
                          pageRefresh();
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
            SizedBox(height: 30),

            Expanded(
              child: FutureBuilder(
                future: subCategory,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error ${snapshot.error}"));
                  } else if (!snapshot.hasData) {
                    return Center(child: Text("No Data found"));
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final category = snapshot.data![index];

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
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),

                            leading: Container(
                              height: 45,
                              width: 45,
                              decoration: BoxDecoration(
                                color: AppColors.primaryColor.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.recycling,
                                color: AppColors.primaryColor,
                              ),
                            ),

                            title: Text(
                              category.subName ?? "Untitled",
                              style: AppTextStyle.semiBold16(
                                color: Colors.black,
                              ),
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                "Rate: ₹ ${category.price}",
                                style: AppTextStyle.medium14(
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),

                            trailing: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.black54,
                              ),
                            ),

                            onTap: () {},
                            onLongPress: () {
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Delete"),
                                    content: Text(
                                      "Do you really want to delete this scrap?",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {

                                        },
                                        child: Text(
                                          "Yes",
                                          style: AppTextStyle.regular14(
                                            color: AppColors.redColor,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: Text(
                                          "No",
                                          style: AppTextStyle.regular14(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
