class response_sign_model {
  String? username;
  String? email;
  int? mobile;
  String? password;
  String? referralCode;
  String? sId;
  int? iV;

  response_sign_model(
      {this.username,
        this.email,
        this.mobile,
        this.password,
        this.referralCode,
        this.sId,
        this.iV});

  response_sign_model.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    referralCode = json['referralCode'];
    sId = json['_id'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['referralCode'] = this.referralCode;
    data['_id'] = this.sId;
    data['__v'] = this.iV;
    return data;
  }
}
