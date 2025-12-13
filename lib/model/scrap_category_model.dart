class ScrapCategoryModel {
  String? status;
  List<ScrapCategory>? scrapcategory;

  ScrapCategoryModel({this.status, this.scrapcategory});

  ScrapCategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['scrapcategory'] != null) {
      scrapcategory = <ScrapCategory>[];
      json['scrapcategory'].forEach((v) {
        scrapcategory!.add(new ScrapCategory.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.scrapcategory != null) {
      data['scrapcategory'] =
          this.scrapcategory!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScrapCategory {
  String? categoryId;
  String? categoryName;

  ScrapCategory({this.categoryId, this.categoryName});

  ScrapCategory.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    return data;
  }
}
