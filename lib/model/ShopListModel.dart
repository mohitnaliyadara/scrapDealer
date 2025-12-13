class ShopListModel {
  String? status;
  List<ShopData>? data;

  ShopListModel({this.status, this.data});

  factory ShopListModel.fromJson(Map<String, dynamic> json) {
    return ShopListModel(
      status: json["status"],
      data: json["data"] != null
          ? (json["data"] as List).map((e) => ShopData.fromJson(e)).toList()
          : [],
    );
  }
}

class ShopData {
  String? id;
  String? shopname;
  String? ownername;
  String? phone;
  String? email;
  String? address;
  String? city;
  String? pincode;

  ShopData({
    this.id,
    this.shopname,
    this.ownername,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.pincode,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) {
    return ShopData(
      id: json["shop_id"],
      shopname: json["shop_name"],
      ownername: json["owner_name"],
      phone: json["phone_number"],
      email: json["shop_email"],
      address: json["address"],
      city: json["city"],
      pincode: json["pincode"],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      "shop_id": id,
      "shop_name": shopname,
      "owner_name": ownername,
      "phone_number": phone,
      "shop_email": email,
      "address": address,
      "city": city,
      "pincode": pincode,
    };
  }
}
