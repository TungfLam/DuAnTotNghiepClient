class ProfileModel {
  bool? err;
  ObjUser? objUser;

  ProfileModel({this.err, this.objUser});

  ProfileModel.fromJson(Map<String, dynamic> json) {
    err = json['err'];
    objUser =
        json['objUser'] != null ? new ObjUser.fromJson(json['objUser']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['err'] = this.err;
    if (this.objUser != null) {
      data['objUser'] = this.objUser!.toJson();
    }
    return data;
  }
}

class ObjUser {
  String? sId;
  String? username;
  String? email;
  String? fullName;
  String? phoneNumber;
  String? role;
  bool? status;
  String? address;
  String? avata;

  ObjUser(
      {this.sId,
      this.username,
      this.email,
      this.fullName,
      this.phoneNumber,
      this.role,
      this.status,
      this.address,
      this.avata});

  ObjUser.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    email = json['email'];
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    status = json['status'];
    address = json['address'];
    avata = json['avata'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['username'] = this.username;
    data['email'] = this.email;
    data['full_name'] = this.fullName;
    data['phone_number'] = this.phoneNumber;
    data['role'] = this.role;
    data['status'] = this.status;
    data['address'] = this.address;
    data['avata'] = this.avata;
    return data;
  }
}