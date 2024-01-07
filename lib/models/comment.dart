class Comment {
  String? sId;
  String? productId;
  String? userId;
  String? comment;
  int? rating;
  String? date;
  int? iV;
  List<String>? images;

  Comment(
      {this.sId,
        this.productId,
        this.userId,
        this.comment,
        this.rating,
        this.date,
        this.iV,
        this.images});

  Comment.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productId = json['product_id'];
    userId = json['user_id'];
    comment = json['comment'];
    rating = json['rating'];
    date = json['date'];
    iV = json['__v'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['product_id'] = this.productId;
    data['user_id'] = this.userId;
    data['comment'] = this.comment;
    data['rating'] = this.rating;
    data['date'] = this.date;
    data['__v'] = this.iV;
    data['images'] = this.images;
    return data;
  }
}