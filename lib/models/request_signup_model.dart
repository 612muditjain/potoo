class request_sign_model {
  String? username;
  String? email;
  String? mobile;
  String? password;
  String? confirmPassword;
  String? referralCode;

  request_sign_model(
      {this.username,
        this.email,
        this.mobile,
        this.password,
        this.confirmPassword,
        this.referralCode});

  request_sign_model.fromJson(Map<String, dynamic> json) {
    username = json['username'];
    email = json['email'];
    mobile = json['mobile'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
    referralCode = json['referralCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['username'] = this.username;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['password'] = this.password;
    data['confirmPassword'] = this.confirmPassword;
    data['referralCode'] = this.referralCode;
    return data;
  }
}
