class userModel {
  String? sId;
  String? username;
  String? password;
  String? email;
  String? fullName;
  String? phoneNumber;
  String? role;
  bool? status;
  String? avata;
  String? token;
  String? deviceId;
  String? createdAt;
  String? socketId;

  userModel(
      {this.sId,
      this.username,
      this.password,
      this.email,
      this.fullName,
      this.phoneNumber,
      this.role,
      this.status,
      this.avata,
      this.token,
      this.deviceId,
      this.createdAt,
      this.socketId});

  userModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    username = json['username'];
    password = json['password'];
    email = json['email'];
    fullName = json['full_name'];
    phoneNumber = json['phone_number'];
    role = json['role'];
    status = json['status'];
    avata = json['avata'];
    token = json['token'];
    deviceId = json['deviceId'];
    createdAt = json['created_at'];
    socketId = json['socketId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['username'] = username;
    data['password'] = password;
    data['email'] = email;
    data['full_name'] = fullName;
    data['phone_number'] = phoneNumber;
    data['role'] = role;
    data['status'] = status;
    data['avata'] = avata;
    data['token'] = token;
    data['deviceId'] = deviceId;
    data['created_at'] = createdAt;
    data['socketId'] = socketId;
    return data;
  }
}
