// class Postm {
//   String postID;
//   String Caption;
//   int lcnt;
//   bool isLiked;
//   String dt;
//   String UserId;

//   Postm({required this.Caption,required this.UserId,required this.dt,required this.isLiked,required this.lcnt,required this.postID});
// }

class post {
  String? caption;
  int? lcnt;
  String? img;
  bool? isLiked;
  String? dt;
  String? userId;

  post({this.caption, this.lcnt, this.img, this.isLiked, this.dt, this.userId});

  post.fromJson(Map<dynamic, dynamic> json) {
    caption = json['caption'];
    lcnt = json['lcnt'];
    img = json['img'];
    isLiked = json['isLiked'];
    dt = json['dt'];
    userId = json['userId'];
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = new Map<dynamic, dynamic>();
    data['caption'] = this.caption;
    data['lcnt'] = this.lcnt;
    data['img'] = this.img;
    data['isLiked'] = this.isLiked;
    data['dt'] = this.dt;
    data['userId'] = this.userId;
    return data;
  }
}
