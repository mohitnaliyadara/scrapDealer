import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:scrapdealer/screens/dashboard.dart';
import 'package:scrapdealer/utils/app_colors.dart';
import 'package:scrapdealer/utils/app_style.dart';

class DealerTransactionsScreen extends StatefulWidget {
  const DealerTransactionsScreen({super.key});

  @override
  State<DealerTransactionsScreen> createState() =>
      _DealerTransactionsScreenState();
}

class _DealerTransactionsScreenState extends State<DealerTransactionsScreen> {
  final String dealerEmail = GetStorage().read("dealerEmail") ?? "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Get.off(()=> DealerDashboardScreen());
        }, icon: Icon(Icons.arrow_back_ios_new)),
        backgroundColor: AppColors.primaryColor,
        centerTitle: true,
        title: Text(
          "Scrap Requests",
          style: AppTextStyle.bold18(color: Colors.white),
        ),
      ),

      body: dealerEmail.isEmpty
          ? Center(child: Text("Dealer not logged in"))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("transactions")
            .where("dealerEmail", isEqualTo: dealerEmail)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "No Requests Found",
                style: AppTextStyle.bold18(),
              ),
            );
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final scrapItems = data["scrapItems"] ?? [];

              return Container(
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Customer: ${docs[index].id}", // user email
                      style: AppTextStyle.bold16(),
                    ),
                    SizedBox(height: 5),

                    Text("Shop: ${data["shopName"] ?? ""}",
                        style: AppTextStyle.regular14()),

                    SizedBox(height: 10),
                    Text(
                      "Scrap Items:",
                      style: AppTextStyle.bold16(
                          color: AppColors.primaryColor),
                    ),

                    ...scrapItems.map((item) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${item["name"]} (${item["weight"]} kg)",
                              style: AppTextStyle.regular14(),
                            ),
                            Text(
                              "₹${item["total"]}",
                              style: AppTextStyle.bold14(
                                  color: AppColors.primaryColor),
                            ),
                          ],
                        ),
                      );
                    }).toList(),

                    Divider(),
                    SizedBox(height: 5),

                    Text("Pickup Address:",
                        style: AppTextStyle.bold14()),
                    Text("${data["pickupAddress"]}",
                        style: AppTextStyle.regular14()),

                    SizedBox(height: 10),
                    Text("Pickup Date: ${data["pickupDate"]}",
                        style: AppTextStyle.regular14()),
                    Text("Pickup Time: ${data["pickupTime"]}",
                        style: AppTextStyle.regular14()),

                    SizedBox(height: 10),
                    Text(
                      "Created: ${data["createdAt"].toDate()}",
                      style: AppTextStyle.regular12(),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
