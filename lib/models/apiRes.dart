
class ApiRes {
  String? msg;
  bool? err;
  String? idUser;
  String? role;

  ApiRes({this.msg, this.err , this.idUser , this.role});

  ApiRes.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    err = json['err'];
    idUser = json['idUser'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['err'] = this.err;
    data['idUser'] = this.idUser;
    data['role'] = this.role;
    return data;
  }
}