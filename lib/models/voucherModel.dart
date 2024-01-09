class voucherModel {
  String? message;
  List<Listdiscount>? listdiscount;

  voucherModel({this.message, this.listdiscount});

  voucherModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['listdiscount'] != null) {
      listdiscount = <Listdiscount>[];
      json['listdiscount'].forEach((v) {
        listdiscount!.add(new Listdiscount.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.listdiscount != null) {
      data['listdiscount'] = this.listdiscount!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Listdiscount {
  String? sId;
  List<UserId>? userId;
  String? codeDiscount;
  String? startDay;
  String? endDay;
  int? price;
  String? description;
  int? usageCount;
  String? createdAt;
  int? iV;

  Listdiscount(
      {this.sId,
      this.userId,
      this.codeDiscount,
      this.startDay,
      this.endDay,
      this.price,
      this.description,
      this.usageCount,
      this.createdAt,
      this.iV});

  Listdiscount.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    if (json['user_id'] != null) {
      userId = <UserId>[];
      json['user_id'].forEach((v) {
        userId!.add(new UserId.fromJson(v));
      });
    }
    codeDiscount = json['code_discount'];
    startDay = json['start_day'];
    endDay = json['end_day'];
    price = json['price'];
    description = json['description'];
    usageCount = json['usageCount'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['user_id'] = this.userId!.map((v) => v.toJson()).toList();
    }
    data['code_discount'] = this.codeDiscount;
    data['start_day'] = this.startDay;
    data['end_day'] = this.endDay;
    data['price'] = this.price;
    data['description'] = this.description;
    data['usageCount'] = this.usageCount;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UserId {
  String? sId;
  String? username;

  UserId({this.sId, this.username});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    return data;
  }
}