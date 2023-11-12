class productModel {
  String? sId;
  String? name;
  String? description;
  List<String>? image;
  String? createdAt;
  String? updatedAt;
  String? price;
  int? iV;
  bool? isFavorite;

  productModel(
      {this.sId,
      this.name,
      this.description,
      this.image,
      this.createdAt,
      this.updatedAt,
      this.price,
      this.iV,
      this.isFavorite});

  productModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    image = json['image'].cast<String>();
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    price = json['price'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['price'] = this.price;
    data['__v'] = this.iV;
    return data;
  }
}
