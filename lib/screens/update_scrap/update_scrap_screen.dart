import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/controller/controller.dart';
import 'package:scrapdealer/screens/update_scrap/update_scrap_price_screen.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scrapdealer/widgets/custom_snakbar.dart';

class UpdateScrapScreen extends StatefulWidget {
  final String shopName;
  const UpdateScrapScreen({super.key, required this.shopName});

  @override
  State<UpdateScrapScreen> createState() => _UpdateScrapScreenState();
}

class _UpdateScrapScreenState extends State<UpdateScrapScreen> {
  List<Map<String, dynamic>> data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  /// 🔹 Fetch all scrap types for this shop
  Future<void> loadData() async {
    try {
      final result = await Controller.getScrapTypes(widget.shopName);
      setState(() {
        data = result;
        isLoading = false;
      });
    } catch (e) {
      print("Error loading scrap types: $e");
      setState(() => isLoading = false);
    }
  }

  /// 🔹 Delete scrap type (and all subtypes)
  Future<void> deleteScrapType(String scrapTypeName) async {
    final dealerEmail = GetStorage().read("dealerEmail");

    try {
      // Get the scrapType document reference
      final scrapTypeRef = FirebaseFirestore.instance
          .collection("dealer")
          .doc(dealerEmail)
          .collection("shops")
          .doc(widget.shopName)
          .collection("scraptypes")
          .doc(scrapTypeName);

      // Delete all subtypes first
      final subtypesSnapshot = await scrapTypeRef.collection("subtypes").get();
      for (var subtype in subtypesSnapshot.docs) {
        await subtype.reference.delete();
      }

      // Then delete the main scrapType doc
      await scrapTypeRef.delete();

      AppSnackbar.show(
        "Scrap type '$scrapTypeName' deleted successfully",
        SnackbarType.success,
      );

      // Refresh UI
      loadData();
    } catch (e) {
      AppSnackbar.show("Error deleting scrap type: $e", SnackbarType.error);
    }
  }

  ///  Show confirmation popup before delete
  void showDeleteDialog(String scrapTypeName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: AppColors.whiteColor,
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: AppColors.primaryColor),
              const SizedBox(width: 8),
              Text(
                "Delete Scrap Type",
                style: AppTextStyle.bold16(color: AppColors.blackColor),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to delete '$scrapTypeName' permanently?\nThis will also remove all its subtypes.",
            style: AppTextStyle.regular14(color: AppColors.darkGreyColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Cancel",
                style: AppTextStyle.bold14(color: AppColors.darkGreyColor),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                deleteScrapType(scrapTypeName);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Manage Scrap Types",
          style: AppTextStyle.bold18(color: Colors.white),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primaryColor,
              AppColors.primaryColor.withOpacity(0.85),
              AppColors.primaryColor.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : data.isEmpty
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: 70,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "No Scrap Types Found",
                            style: AppTextStyle.bold18(
                              color: AppColors.darkGreyColor,
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shop: ${widget.shopName}",
                            style: AppTextStyle.bold18(
                              color: AppColors.primaryColor,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text(
                            "Long press a scrap type to delete it permanently.",
                            style: AppTextStyle.regular14(
                              color: AppColors.darkGreyColor,
                            ),
                          ),
                          const SizedBox(height: 25),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: data.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 1.1,
                                ),
                            itemBuilder: (context, index) {
                              final item = data[index];
                              final scrapType = item['scrapType'] ?? 'Unnamed';
                              return InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  Get.to(()=> UpdateScrapPriceScreen(shopName: widget.shopName,scraptype: scrapType,));

                                },
                                onLongPress: () {
                                  showDeleteDialog(scrapType);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 6,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: AppColors.primaryColor
                                            .withOpacity(0.1),
                                        radius: 28,
                                        child: Icon(
                                          Icons.recycling_outlined,
                                          color: AppColors.primaryColor,
                                          size: 28,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        scrapType,
                                        textAlign: TextAlign.center,
                                        style: AppTextStyle.bold16(
                                          color: AppColors.blackColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
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
