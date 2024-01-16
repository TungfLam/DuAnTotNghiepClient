class AddressModel {
  bool? err;
  ObjAddress? objAddress;

  AddressModel({this.err, this.objAddress});

  AddressModel.fromJson(Map<String, dynamic> json) {
    err = json['err'];
    objAddress = json['objAddress'] != null
        ? new ObjAddress.fromJson(json['objAddress'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['err'] = this.err;
    if (this.objAddress != null) {
      data['objAddress'] = this.objAddress!.toJson();
    }
    return data;
  }
}

class ObjAddress {
  String? sId;
  String? userId;
  String? address;
  String? specificAddres;
  int? iV;

  ObjAddress(
      {this.sId, this.userId, this.address, this.specificAddres, this.iV});

  ObjAddress.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['user_id'];
    address = json['address'];
    specificAddres = json['specific_addres'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['user_id'] = this.userId;
    data['address'] = this.address;
    data['specific_addres'] = this.specificAddres;
    data['__v'] = this.iV;
    return data;
  }
}