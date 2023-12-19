class Comment {
  Id? iId;
  Id? productId;
  Id? userId;
  String? comment;
  int? rating;
  String? date;
  int? iV;
  List<String>? images;

  Comment(
      {this.iId,
        this.productId,
        this.userId,
        this.comment,
        this.rating,
        this.date,
        this.iV,
        this.images});

  Comment.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    productId =
    json['product_id'] != null ? new Id.fromJson(json['product_id']) : null;
    userId = json['user_id'] != null ? new Id.fromJson(json['user_id']) : null;
    comment = json['comment'];
    rating = json['rating'];
    date = json['date'];
    iV = json['__v'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId!.toJson();
    }
    if (this.productId != null) {
      data['product_id'] = this.productId!.toJson();
    }
    if (this.userId != null) {
      data['user_id'] = this.userId!.toJson();
    }
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['date'] = this.date;
    data['__v'] = this.iV;
    data['images'] = this.images;
    return data;
  }
}

class Id {
  String? oid;

  Id({this.oid});

  Id.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}