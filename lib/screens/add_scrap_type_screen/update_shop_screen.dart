import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/api_services/add_shop.dart';
import 'package:scrapdealer/api_services/update_shop_api.dart';
import 'package:scrapdealer/controller/controller.dart';
import 'package:scrapdealer/model/ShopListModel.dart';
import 'package:scrapdealer/res/app_route.dart';
import 'package:scrapdealer/screens/add_scrap_type_screen/shop_list_screen.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';
import 'package:scrapdealer/widgets/custom_button.dart';
import 'package:scrapdealer/widgets/custom_snakbar.dart';
import 'package:scrapdealer/widgets/custom_text_filed.dart';
import 'package:flutter/services.dart';

class UpdateShopScreen extends StatefulWidget {
  final ShopData shop;
  const UpdateShopScreen({super.key, required this.shop});

  @override
  State<UpdateShopScreen> createState() => _UpdateShopScreenState();
}

class _UpdateShopScreenState extends State<UpdateShopScreen> {
  late TextEditingController _ownerNameController;
  late TextEditingController _emailController ;
  late TextEditingController _shopNameController ;
  late TextEditingController _addressController ;
  late TextEditingController _phoneController ;
  late TextEditingController _cityController;
  late TextEditingController _pincodeController ;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _shopNameController = TextEditingController(text: widget.shop.shopname);
    _ownerNameController = TextEditingController(text: widget.shop.ownername);
    _emailController = TextEditingController(text: widget.shop.email);
    _addressController = TextEditingController(text: widget.shop.address);
    _phoneController = TextEditingController(text: widget.shop.phone);
    _cityController = TextEditingController(text: widget.shop.city);
    _pincodeController = TextEditingController(text: widget.shop.pincode);
  }

  @override
  void dispose() {
    _shopNameController.dispose();
    _pincodeController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ownerNameController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log(GetStorage().read("emailDealer"));
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            AppRoute.navigateOffAll(pageName: DealerDashboardScreen());
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
        centerTitle: true,

        //  Section inside AppBar
        title: Text(
          "Update Shop",
          style: AppTextStyle.bold22(color: Colors.white),
        ),
      ),

      // ⭐ Beautiful Gradient Background
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.85),
              AppColors.primaryColor.withOpacity(0.65),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.90,
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),

              // Form Fields
              child: Form(
                key: _globalKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Shop Details", style: AppTextStyle.bold20()),
                    const SizedBox(height: 15),

                    customTextFiled(
                      hintText: "Shop Name",
                      icon: Icons.storefront_outlined,
                      controller: _shopNameController,
                      validation: (value) {
                        if (value!.isEmpty) {
                          return "Shop name is required";
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),

                    customTextFiled(
                      hintText: "Owner Name",
                      icon: Icons.person_outline,
                      controller: _ownerNameController,
                      validation: (value) {
                        final nameRegex = RegExp(r'^[A-Za-z ]+$');
                        if (value!.isEmpty) {
                          return "Owner name is required";
                        }
                        if (!nameRegex.hasMatch(value)) {
                          return "only alphabets are allowed";
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),

                    customTextFiled(
                      hintText: "Phone",
                      icon: Icons.phone_android_outlined,
                      controller: _phoneController,

                      textInputType: TextInputType.phone,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validation: (value) {
                        final phoneRegex = RegExp(r'^[0-9]{10}$');
                        if (value!.isEmpty) {
                          return "Phone number is required";
                        }
                        if (!phoneRegex.hasMatch(value)) {
                          return "Enter valid phone number";
                        }
                        return null;
                      },
                    ),

                    customTextFiled(
                      hintText: "Email",
                      label: "(Enter Register email)",
                      icon: Icons.email_outlined,
                      controller: _emailController,
                      textInputType: TextInputType.emailAddress,
                      validation: (value) {
                        final emailRegex = RegExp(
                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                        );
                        if (value!.isEmpty) {
                          return "Email is required";
                        }
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter a valid email address";
                        }
                        if (Controller.loginEmail != value) {
                          return "Check Register email !, not match";
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),

                    customTextFiled(
                      hintText: "Shop Address",
                      icon: Icons.location_on_outlined,
                      controller: _addressController,
                      maxLines: 3,
                      validation: (value) {
                        if (value == null || value.isEmpty) {
                          return "Address is required";
                        }

                        final addressRegex = RegExp(r'^[a-zA-Z0-9\s,./]+$');

                        if (!addressRegex.hasMatch(value)) {
                          return "Only letters, numbers, space, comma, dot and slash allowed";
                        }

                        return null;
                      },
                    ),

                    customTextFiled(
                      hintText: "City",
                      icon: Icons.location_city_outlined,
                      controller: _cityController,
                      validation: (value) {
                        final nameRegex = RegExp(r'^[A-Za-z ]+$');
                        if (value!.isEmpty) {
                          return "City name is required";
                        }
                        if (!nameRegex.hasMatch(value)) {
                          return "only alphabets are allowed";
                        }
                        return null;
                      },
                      maxLines: 1,
                    ),

                    customTextFiled(
                      hintText: "Pincode",
                      icon: Icons.pin_drop_outlined,
                      controller: _pincodeController,

                      textInputType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      validation: (value) {
                        final phoneRegex = RegExp(r'^[0-9]{6}$');
                        if (value!.isEmpty) {
                          return "Pincode is required";
                        }
                        if (!phoneRegex.hasMatch(value)) {
                          return "Enter valid phone number";
                        }
                        return null;
                      },
                    ),

                    customButton(
                      text: "Update Shop",
                      width: double.infinity,
                      backcolor: AppColors.primaryColor,
                      textstyle: AppTextStyle.semiBold16(color: Colors.white),
                      onPress: () {
                        if (_globalKey.currentState!.validate()) {
                          final data = ShopData.fromJson({
                            "shop_id": widget.shop.id,
                            "shop_name": _shopNameController.text,
                            "owner_name": _ownerNameController.text,
                            "phone_number": _phoneController.text,
                            "shop_email": _emailController.text,
                            "address": _addressController.text,
                            "city": _cityController.text,
                            "pincode": _pincodeController.text
                          });

                          UpdateShopApi.updateShop(data, context);
                          Get.offAll(()=> ShopListScreen());
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
