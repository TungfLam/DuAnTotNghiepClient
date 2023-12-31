class Autogenerated {
  int? status;
  String? msg;
  List<BiilModel>? biilModel;

  Autogenerated({this.status, this.msg, this.biilModel});

  Autogenerated.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      biilModel = <BiilModel>[];
      json['data'].forEach((v) {
        biilModel!.add(new BiilModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['msg'] = this.msg;
    if (this.biilModel != null) {
      data['data'] = this.biilModel!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BiilModel {
  String? sId;
  UserId? userId;
  List<CartId>? cartId;
  UserData? userData;
  List<CartData>? cartData;
  int? payments;
  int? totalAmount;
  int? status;
  String? createdAt;
  int? iV;

  BiilModel(
      {this.sId,
      this.userId,
      this.cartId,
      this.userData,
      this.cartData,
      this.payments,
      this.totalAmount,
      this.status,
      this.createdAt,
      this.iV});

  BiilModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId =
        json['user_id'] != null ? new UserId.fromJson(json['user_id']) : null;
    if (json['cart_id'] != null) {
      cartId = <CartId>[];
      json['cart_id'].forEach((v) {
        cartId!.add(new CartId.fromJson(v));
      });
    }
    userData = json['user_data'] != null
        ? new UserData.fromJson(json['user_data'])
        : null;
    if (json['cart_data'] != null) {
      cartData = <CartData>[];
      json['cart_data'].forEach((v) {
        cartData!.add(new CartData.fromJson(v));
      });
    }
    payments = json['payments'];
    totalAmount = json['total_amount'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    if (this.cartId != null) {
      data['cart_id'] = this.cartId!.map((v) => v.toJson()).toList();
    }
    if (this.userData != null) {
      data['user_data'] = this.userData!.toJson();
    }
    if (this.cartData != null) {
      data['cart_data'] = this.cartData!.map((v) => v.toJson()).toList();
    }
    data['payments'] = this.payments;
    data['total_amount'] = this.totalAmount;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class UserId {
  String? sId;
  String? username;
  String? password;
  String? email;
  String? fullName;
  String? phoneNumber;
  String? role;
  bool? status;
  String? address;
  String? avata;
  String? token;
  String? deviceId;

  UserId(
      {this.sId,
      this.username,
      this.password,
      this.email,
      this.fullName,
      this.phoneNumber,
      this.role,
      this.status,
      this.address,
      this.avata,
      this.token,
      this.deviceId});

  UserId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    status = json['status'];
    address = json['address'];
    avata = json['avata'];
    token = json['token'];
    deviceId = json['deviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['password'] = this.password;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['phone_number'] = this.phoneNumber;
    data['role'] = this.role;
    data['status'] = this.status;
    data['address'] = this.address;
    data['avata'] = this.avata;
    data['token'] = this.token;
    data['deviceId'] = this.deviceId;
    return data;
  }
}

class CartId {
  String? sId;
  String? userId;
  ProductId? productId;
  int? quantity;
  String? status;
  String? createdAt;
  int? iV;

  CartId(
      {this.sId,
      this.userId,
      this.productId,
      this.quantity,
      this.status,
      this.createdAt,
      this.iV});

  CartId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    productId = json['product_id'] != null
        ? new ProductId.fromJson(json['product_id'])
        : null;
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['createdAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    if (this.productId != null) {
      data['product_id'] = this.productId!.toJson();
    }
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    data['__v'] = this.iV;
    return data;
  }
}

class DetailProductId {
  String? sId;
  ProductId? productId;
  SizeId? sizeId;
  ColorId? colorId;
  int? quantity;
  String? createdAt;
  int? iV;

  DetailProductId(
      {this.sId,
      this.productId,
      this.sizeId,
      this.colorId,
      this.quantity,
      this.createdAt,
      this.iV});

  DetailProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['product_id'] != null
        ? new ProductId.fromJson(json['product_id'])
        : null;
    sizeId =
        json['size_id'] != null ? new SizeId.fromJson(json['size_id']) : null;
    colorId = json['color_id'] != null
        ? new ColorId.fromJson(json['color_id'])
        : null;
    quantity = json['quantity'];
    createdAt = json['createdAt'];
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
    data['__v'] = this.iV;
    return data;
  }
}

class ProductId {
  String? sId;
  String? name;
  String? description;
  List<String>? image;
  String? categoryId;
  int? price;
  String? createdAt;
  int? iV;
  String? updatedAt;

  ProductId(
      {this.sId,
      this.name,
      this.description,
      this.image,
      this.categoryId,
      this.price,
      this.createdAt,
      this.iV,
      this.updatedAt});

  ProductId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    description = json['description'];
    if (json['image'] != null) {
      image = json['image'].cast<String>();
    } else {
      image = [];
    }
    categoryId = json['category_id'];
    price = json['price'];
    createdAt = json['createdAt'];
    iV = json['__v'];
    updatedAt = json['updatedAt'];
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
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}

class SizeId {
  String? sId;
  String? name;
  int? iV;

  SizeId({this.sId, this.name, this.iV});

  SizeId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['__v'] = this.iV;
    return data;
  }
}

class ColorId {
  String? sId;
  String? name;
  String? colorcode;
  int? iV;

  ColorId({this.sId, this.name, this.colorcode, this.iV});

  ColorId.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    colorcode = json['colorcode'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['colorcode'] = this.colorcode;
    data['__v'] = this.iV;
    return data;
  }
}

class UserData {
  String? username;
  String? phoneNumber;
  String? role;
  String? address;
  String? fullName;
  String? email;

  UserData(
      {this.username,
      this.phoneNumber,
      this.role,
      this.address,
      this.fullName,
      this.email});

  UserData.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    address = json['address'];
    fullName = json['full_name'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['phone_number'] = this.phoneNumber;
    data['role'] = this.role;
    data['address'] = this.address;
    data['full_name'] = this.fullName;
    data['email'] = this.email;
    return data;
  }
}

class CartData {
  String? productId;
  int? quantity;
  String? status;
  String? createdAt;
  ProductData? productData;

  CartData(
      {this.productId,
      this.quantity,
      this.status,
      this.createdAt,
      this.productData});

  CartData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    quantity = json['quantity'];
    status = json['status'];
    createdAt = json['createdAt'];
    productData = json['product_data'] != null
        ? new ProductData.fromJson(json['product_data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['quantity'] = this.quantity;
    data['status'] = this.status;
    data['createdAt'] = this.createdAt;
    if (this.productData != null) {
      data['product_data'] = this.productData!.toJson();
    }
    return data;
  }
}

class ProductData {
  String? productId;
  String? createdAt;
  String? name;
  String? description;
  List<String>? image;
  String? categoryId;
  int? price;
  String? categoryName;
  String? sizeName;
  String? colorName;
  String? colorCode;

  ProductData(
      {this.productId,
      this.createdAt,
      this.name,
      this.description,
      this.image,
      this.categoryId,
      this.price,
      this.categoryName,
      this.sizeName,
      this.colorName,
      this.colorCode});

  ProductData.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    createdAt = json['createdAt'];
    name = json['name'];
    description = json['description'];
    image = json['image'].cast<String>();
    categoryId = json['category_id'];
    price=json['price'];
    categoryName = json['category_name'];
    sizeName = json['size_name'];
    colorName = json['color_name'];
    colorCode = json['color_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['createdAt'] = this.createdAt;
    data['name'] = this.name;
    data['description'] = this.description;
    data['image'] = this.image;
    data['category_id'] = this.categoryId;
    data['price']=this.price;
    data['category_name'] = this.categoryName;
    data['size_name'] = this.sizeName;
    data['color_name'] = this.colorName;
    data['color_code'] = this.colorCode;
    return data;
  }
}
