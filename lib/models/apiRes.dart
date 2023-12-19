
class ApiRes {
  String? msg;
  bool? err;
  String? idUser;
  String? role;
  String? fullname;
  String? avata;
  String? phone;
  String? email;

  ApiRes({this.msg, this.err , this.idUser , this.role , this.avata , this.phone , this.email , this.fullname});

  ApiRes.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    err = json['err'];
    idUser = json['idUser'];
    role = json['role'];
    avata = json['avata'];
    phone = json['phone'];
    email = json['email'];
    fullname = json['fullname'];
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
    return data;
  }
}