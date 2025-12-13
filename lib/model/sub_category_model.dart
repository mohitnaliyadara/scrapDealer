class SubCategoryModel {
  String? status;
  List<SubCategoryData>? subCategoryData;

  SubCategoryModel({this.status, this.subCategoryData});

  SubCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['subCategoryData'] != null) {
      subCategoryData = <SubCategoryData>[];
      json['subCategoryData'].forEach((v) {
        subCategoryData!.add(new SubCategoryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.subCategoryData != null) {
      data['subCategoryData'] =
          this.subCategoryData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubCategoryData {
  String? subcategoryId;
  String? categoryId;
  String? shopId;
  String? subName;
  String? price;

  SubCategoryData(
      {this.subcategoryId,
        this.categoryId,
        this.shopId,
        this.subName,
        this.price});

  SubCategoryData.fromJson(Map<String, dynamic> json) {
    subcategoryId = json['subcategory_id'];
    categoryId = json['category_id'];
    shopId = json['shop_id'];
    subName = json['sub_name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['subcategory_id'] = this.subcategoryId;
    data['category_id'] = this.categoryId;
    data['shop_id'] = this.shopId;
    data['sub_name'] = this.subName;
    data['price'] = this.price;
    return data;
  }
}
