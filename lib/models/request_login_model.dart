class response_login_model {
  String? email;
  String? mobile;
  String? password;

  response_login_model({this.email, this.mobile, this.password});

  response_login_model.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    return data;
  }
}
