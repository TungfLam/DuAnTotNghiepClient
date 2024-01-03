class slideshow {
  String? message;
  List<ListBanners>? listBanners;

  slideshow({this.message, this.listBanners});

  slideshow.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['listBanners'] != null) {
      listBanners = <ListBanners>[];
      json['listBanners'].forEach((v) {
        listBanners!.add(new ListBanners.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.listBanners != null) {
      data['listBanners'] = this.listBanners!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListBanners {
  String? sId;
  String? imageBanner;
  List<ProductIdDC>? productId;
  String? description;
  String? createdAt;
  int? iV;

  ListBanners(
      {this.sId,
      this.imageBanner,
      this.productId,
      this.description,
      this.createdAt,
      this.iV});

  ListBanners.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    imageBanner = json['image_banner'];
    if (json['product_id'] != null) {
      productId = <ProductIdDC>[];
      json['product_id'].forEach((v) {
        productId!.add(new ProductIdDC.fromJson(v));
      });
    }
    description = json['description'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['image_banner'] = this.imageBanner;
    if (this.productId != null) {
      data['product_id'] = this.productId!.map((v) => v.toJson()).toList();
    }
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class ProductIdDC {
  String? sId;
  String? name;
  String? description;
  List<String>? image;
  String? categoryId;
  int? price;
  String? createdAt;
  int? iV;
  int? rating;
  String? updatedAt;
  int? discount;

  ProductIdDC(
      {this.sId,
      this.name,
      this.description,
      this.image,
      this.categoryId,
      this.price,
      this.createdAt,
      this.iV,
      this.rating,
      this.updatedAt,
      this.discount});

  ProductIdDC.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'].cast<String>();
    categoryId = json['category_id'];
    price = json['price'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    rating = json['rating'];
    updatedAt = json['updatedAt'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['price'] = this.price;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    data['rating'] = this.rating;
    data['updatedAt'] = this.updatedAt;
    data['discount'] = this.discount;
    return data;
  }
}