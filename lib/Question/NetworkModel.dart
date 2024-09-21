class NetworkMember {
  final String username;

  final double earnings;
  final String plan;
  final double joiningAmount;

  NetworkMember({
    required this.username,

    required this.earnings,
    required this.plan,
    required this.joiningAmount,
  });
}

//
// factory NetworkMember{required username}{required username}{required username}.fromJson(Map<String, dynamic> json, int level) {
//     return NetworkMember(
//       username: json['username'],
//       level: level,
//       // email: json['email'],
//       earnings: json['earnings'],
//       plan: json['plan'],
//       joiningAmount: json['joiningAmount'],
//     );
//   }
// }
