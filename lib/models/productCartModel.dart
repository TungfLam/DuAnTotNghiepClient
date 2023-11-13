class productCartModel {
  String? _message;
  List<ListCart>? _listCart;

  productCartModel({String? message, List<ListCart>? listCart}) {
    if (message != null) {
      this._message = message;
    }
    if (listCart != null) {
      this._listCart = listCart;
    }
  }

  String? get message => _message;
  set message(String? message) => _message = message;
  List<ListCart>? get listCart => _listCart;
  set listCart(List<ListCart>? listCart) => _listCart = listCart;

  productCartModel.fromJson(Map<String, dynamic> json) {
    _message = json['message'];
    if (json['listCart'] != null) {
      _listCart = <ListCart>[];
      json['listCart'].forEach((v) {
        _listCart!.add(new ListCart.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this._message;
    if (this._listCart != null) {
      data['listCart'] = this._listCart!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListCart {
  String? _sId;
  String? _userId;
  ProductId? _productId;
  int? _quantity;
  String? _status;
  String? _createdAt;
  String? _updatedAt;
  int? _iV;

  ListCart(
      {String? sId,
      String? userId,
      ProductId? productId,
      int? quantity,
      String? status,
      String? createdAt,
      String? updatedAt,
      int? iV}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (userId != null) {
      this._userId = userId;
    }
    if (productId != null) {
      this._productId = productId;
    }
    if (quantity != null) {
      this._quantity = quantity;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (iV != null) {
      this._iV = iV;
    }
  }

  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  String? get userId => _userId;
  set userId(String? userId) => _userId = userId;
  ProductId? get productId => _productId;
  set productId(ProductId? productId) => _productId = productId;
  int? get quantity => _quantity;
  set quantity(int? quantity) => _quantity = quantity;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  int? get iV => _iV;
  set iV(int? iV) => _iV = iV;

  ListCart.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _userId = json['user_id'];
    _productId = json['product_id'] != null
        ? new ProductId.fromJson(json['product_id'])
        : null;
    _quantity = json['quantity'];
    _status = json['status'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['user_id'] = this._userId;
    if (this._productId != null) {
      data['product_id'] = this._productId!.toJson();
    }
    data['quantity'] = this._quantity;
    data['status'] = this._status;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['__v'] = this._iV;
    return data;
  }
}

class ProductId {
  String? _sId;
  ProductId? _productId;
  SizeId? _sizeId;
  SizeId? _colorId;
  int? _quantity;
  String? _createdAt;
  String? _updatedAt;
  int? _iV;

  ProductId(
      {String? sId,
      ProductId? productId,
      SizeId? sizeId,
      SizeId? colorId,
      int? quantity,
      String? createdAt,
      String? updatedAt,
      int? iV}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (productId != null) {
      this._productId = productId;
    }
    if (sizeId != null) {
      this._sizeId = sizeId;
    }
    if (colorId != null) {
      this._colorId = colorId;
    }
    if (quantity != null) {
      this._quantity = quantity;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
    if (iV != null) {
      this._iV = iV;
    }
  }

  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  ProductId? get productId => _productId;
  set productId(ProductId? productId) => _productId = productId;
  SizeId? get sizeId => _sizeId;
  set sizeId(SizeId? sizeId) => _sizeId = sizeId;
  SizeId? get colorId => _colorId;
  set colorId(SizeId? colorId) => _colorId = colorId;
  int? get quantity => _quantity;
  set quantity(int? quantity) => _quantity = quantity;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;
  int? get iV => _iV;
  set iV(int? iV) => _iV = iV;

  ProductId.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _productId = json['product_id'] != null
        ? new ProductId.fromJson(json['product_id'])
        : null;
    _sizeId =
        json['size_id'] != null ? new SizeId.fromJson(json['size_id']) : null;
    _colorId =
        json['color_id'] != null ? new SizeId.fromJson(json['color_id']) : null;
    _quantity = json['quantity'];
    _createdAt = json['createdAt'];
    _updatedAt = json['updatedAt'];
    _iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    if (this._productId != null) {
      data['product_id'] = this._productId!.toJson();
    }
    if (this._sizeId != null) {
      data['size_id'] = this._sizeId!.toJson();
    }
    if (this._colorId != null) {
      data['color_id'] = this._colorId!.toJson();
    }
    data['quantity'] = this._quantity;
    data['createdAt'] = this._createdAt;
    data['updatedAt'] = this._updatedAt;
    data['__v'] = this._iV;
    return data;
  }
}



class SizeId {
  String? _sId;
  String? _name;

  SizeId({String? sId, String? name}) {
    if (sId != null) {
      this._sId = sId;
    }
    if (name != null) {
      this._name = name;
    }
  }

  String? get sId => _sId;
  set sId(String? sId) => _sId = sId;
  String? get name => _name;
  set name(String? name) => _name = name;

  SizeId.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['name'] = this._name;
    return data;
  }
}