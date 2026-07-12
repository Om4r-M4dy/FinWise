class UserModel {
  final String? name;
  final String? email;
  final String? phone;
  final DateTime dob;
  final String id;
  final String? photoUrl;
  final double? balance;
  final double? totalIncome;
  final double? totalExpenses;

  UserModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.id,
    required this.photoUrl,
    this.balance,
    this.totalIncome,
    this.totalExpenses,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String,
        phone = json['phone'] as String,
        dob = DateTime.parse(json['dob'] as String),
        id = json['id'] as String,
        photoUrl = json['photoUrl'] as String,
        balance = json['balance'] as double?,
        totalIncome = json['totalIncome'] as double?,
        totalExpenses = json['totalExpenses'] as double?;

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'phone': phone,
        'dob': dob.toIso8601String(),
        'id': id,
        'photoUrl': photoUrl,
        'balance': balance,
        'totalIncome': totalIncome,
  };
}