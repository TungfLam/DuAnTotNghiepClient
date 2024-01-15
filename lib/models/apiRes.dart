class ApiRes {
  String? msg;
  bool? err;
  String? idUser;
  String? role;
  String? avata;
  String? phone;
  String? email;
  String? fullname;
  String? address;
  String? addressCity;
  String? specificAddres;

  ApiRes(
      {this.msg,
        this.err,
        this.idUser,
        this.role,
        this.avata,
        this.phone,
        this.email,
        this.fullname,
        this.address,
        this.addressCity,
        this.specificAddres});

  ApiRes.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    err = json['err'];
    idUser = json['idUser'];
    role = json['role'];
    avata = json['avata'];
    phone = json['phone'];
    email = json['email'];
    fullname = json['fullname'];
    address = json['address'];
    addressCity = json['address_city'];
    specificAddres = json['specific_addres'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['err'] = this.err;
    data['idUser'] = this.idUser;
    data['role'] = this.role;
    data['avata'] = this.avata;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['fullname'] = this.fullname;
    data['address'] = this.address;
    data['address_city'] = this.addressCity;
    data['specific_addres'] = this.specificAddres;
    return data;
  }
}