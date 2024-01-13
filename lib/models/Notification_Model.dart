class NotificationM {
  String? sId;
  String? idUser;
  String? image;
  String? statuPayload;
  String? payload;
  String? title;
  String? content;
  String? date;
  bool? status;
  int? iV;

  NotificationM(
      {this.sId,
        this.idUser,
        this.image,
        this.statuPayload,
        this.payload,
        this.title,
        this.content,
        this.date,
        this.status,
        this.iV});

  NotificationM.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    idUser = json['id_user'];
    image = json['image'];
    statuPayload = json['statu_payload'];
    payload = json['payload'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
    status = json['status'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['id_user'] = this.idUser;
    data['image'] = this.image;
    data['statu_payload'] = this.statuPayload;
    data['payload'] = this.payload;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    data['status'] = this.status;
    data['__v'] = this.iV;
    return data;
  }
}