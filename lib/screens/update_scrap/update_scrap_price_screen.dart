import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';
import 'package:scrapdealer/widgets/custom_snakbar.dart';

class UpdateScrapPriceScreen extends StatefulWidget {
  final String shopName;
  final String scraptype;

  const UpdateScrapPriceScreen({
    super.key,
    required this.shopName,
    required this.scraptype,
  });

  @override
  State<UpdateScrapPriceScreen> createState() => _UpdateScrapPriceScreenState();
}

class _UpdateScrapPriceScreenState extends State<UpdateScrapPriceScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> subtypes = [];
  final Map<String, TextEditingController> _controllers = {}; // ✅ store controllers

  @override
  void initState() {
    super.initState();
    fetchSubtypes();
  }

  /// 🔹 Fetch subtypes and create controllers
  Future<void> fetchSubtypes() async {
    try {
      final dealerEmail = GetStorage().read("dealerEmail");
      final snapshot = await FirebaseFirestore.instance
          .collection("dealer")
          .doc(dealerEmail)
          .collection("shops")
          .doc(widget.shopName)
          .collection("scraptypes")
          .doc(widget.scraptype)
          .collection("subtypes")
          .get();

      subtypes = snapshot.docs
          .map((doc) => {
        "id": doc.id,
        "name": doc["name"],
        "price": doc["price"].toString(),
        "unit": doc["unit"],
      })
          .toList();

      // ✅ Create a TextEditingController for each subtype
      for (var s in subtypes) {
        _controllers[s['id']] = TextEditingController(text: s['price']);
      }

      setState(() => isLoading = false);
    } catch (e) {
      AppSnackbar.show("Error loading subtypes: $e", SnackbarType.error);
      setState(() => isLoading = false);
    }
  }

  /// 🔹 Update subtype price in Firestore
  Future<void> updatePrice(String subtypeId, String newPrice) async {
    if (newPrice.isEmpty) {
      AppSnackbar.show("Price cannot be empty", SnackbarType.warning);
      return;
    }

    final dealerEmail = GetStorage().read("dealerEmail");
    try {
      await FirebaseFirestore.instance
          .collection("dealer")
          .doc(dealerEmail)
          .collection("shops")
          .doc(widget.shopName)
          .collection("scraptypes")
          .doc(widget.scraptype)
          .collection("subtypes")
          .doc(subtypeId)
          .update({
        "price": double.parse(newPrice),
        "updatedAt": DateTime.now(),
      });

      // ✅ Update local state so UI shows new value instantly
      setState(() {
        subtypes
            .firstWhere((s) => s['id'] == subtypeId)['price'] = newPrice;
      });

      AppSnackbar.show("Price updated successfully!", SnackbarType.success);
    } catch (e) {
      AppSnackbar.show("Error updating price: $e", SnackbarType.error);
    }
  }

  @override
  void dispose() {
    // ✅ Dispose all controllers to avoid memory leaks
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
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
          "Update ${widget.scraptype} Prices",
          style: AppTextStyle.bold18(color: Colors.white),
        ),
      ),
      body: Container(
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
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : subtypes.isEmpty
              ? const Center(child: Text("No subtypes found"))
              : SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: subtypes.map((item) {
                  final controller = _controllers[item['id']]!;
                  return Container(
                    margin:
                    const EdgeInsets.symmetric(vertical: 10),
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name'],
                              style: AppTextStyle.bold16(
                                  color: AppColors.blackColor),
                            ),
                            Text(
                              "/${item['unit']}",
                              style: AppTextStyle.regular14(
                                  color: AppColors.darkGreyColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: controller,
                                keyboardType:
                                TextInputType.number,
                                onSubmitted: (value) {
                                  updatePrice(
                                      item['id'], value.trim());
                                },
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                      Icons.currency_rupee),
                                  labelText: "Enter new price",
                                  border: OutlineInputBorder(
                                    borderRadius:
                                    BorderRadius.circular(12),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                AppColors.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                  BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: () {
                                updatePrice(
                                  item['id'],
                                  controller.text.trim(),
                                );
                              },
                              child: const Text(
                                "Update",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
