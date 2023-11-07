class Autogenerated {
  List<ProductListSize>? productListSize;

  Autogenerated({this.productListSize});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    if (json['productListSize'] != null) {
      productListSize = <ProductListSize>[];
      json['productListSize'].forEach((v) {
        productListSize!.add(new ProductListSize.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.productListSize != null) {
      data['productListSize'] =
          this.productListSize!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductListSize {
  String? sId;
  ProductId? productId;
  SizeId? sizeId;
  SizeId? colorId;
  int? quantity;
  String? createdAt;
  String? updatedAt;
  int? iV;

  ProductListSize(
      {this.sId,
      this.productId,
      this.sizeId,
      this.colorId,
      this.quantity,
      this.createdAt,
      this.updatedAt,
      this.iV});

  ProductListSize.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['product_id'] != null
        ? new ProductId.fromJson(json['product_id'])
        : null;
    sizeId =
        json['size_id'] != null ? new SizeId.fromJson(json['size_id']) : null;
    colorId =
        json['color_id'] != null ? new SizeId.fromJson(json['color_id']) : null;
    quantity = json['quantity'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.productId != null) {
      data['product_id'] = this.productId!.toJson();
    }
    if (this.sizeId != null) {
      data['size_id'] = this.sizeId!.toJson();
    }
    if (this.colorId != null) {
      data['color_id'] = this.colorId!.toJson();
    }
    data['quantity'] = this.quantity;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ProductId {
  String? sId;
  String? name;
  int? price;

  ProductId({this.sId, this.name, this.price});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['price'] = this.price;
    return data;
  }
}

class SizeId {
  String? sId;
  String? name;

  SizeId({this.sId, this.name});

  SizeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    return data;
  }
}