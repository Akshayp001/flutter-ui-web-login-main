class postModel {
  String? iId;
  String? userId;
  LikeCount? likeCount;
  String? caption;
  String? comment;
  bool? isLiked;

  postModel(
      {this.iId,
      this.userId,
      this.likeCount,
      this.caption,
      this.comment,
      this.isLiked});

  postModel.fromJson(Map<String, dynamic> json) {
    iId = json['_id'];
    userId = json['User_Id'];
    likeCount = json['Like_count'] != null
        ? new LikeCount.fromJson(json['Like_count'])
        : null;
    caption = json['Caption'];
    comment = json['Comment'];
    isLiked = json['IsLiked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId;
    }
    data['User_Id'] = this.userId;
    if (this.likeCount != null) {
      data['Like_count'] = this.likeCount!.toJson();
    }
    data['Caption'] = this.caption;
    data['Comment'] = this.comment;
    data['IsLiked'] = this.isLiked;
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

class LikeCount {
  String? numberLong;

  LikeCount({this.numberLong});

  LikeCount.fromJson(Map<String, dynamic> json) {
    numberLong = json['$numberLong'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$numberLong'] = this.numberLong;
    return data;
  }
}