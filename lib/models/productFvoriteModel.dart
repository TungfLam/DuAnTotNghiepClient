class Autogenerated {
  String? message;
  ListFavorite? listFavorite;

  Autogenerated({this.message, this.listFavorite});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    listFavorite = json['listFavorite'] != null
        ? new ListFavorite.fromJson(json['listFavorite'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.listFavorite != null) {
      data['listFavorite'] = this.listFavorite!.toJson();
    }
    return data;
  }
}

class ListFavorite {
  String? sId;
  UserId? userId;
  ProductId? productId;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ListFavorite(
      {this.sId,
      this.userId,
      this.productId,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ListFavorite.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
        json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    productId = json['product_id'] != null
        ? new ProductId.fromJson(json['product_id'])
        : null;
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    if (this.productId != null) {
      data['product_id'] = this.productId!.toJson();
    }
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UserId {
  String? sId;

  UserId({this.sId});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    return data;
  }
}

class ProductId {
  String? sId;
  String? name;
  String? description;
  List<String>? image;
  int? price;

  ProductId({this.sId, this.name,this.description, this.image, this.price});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'].cast<String>();
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['price'] = this.price;
    return data;
  }
}