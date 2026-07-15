class UserModel {
  final String? uid;
  final String? username;
  final String? email;
  final String? phone;
  final String? profilePicture;
  final double? totalBalance;
  final double? totalExpense;
  final double? totalIncome;
  final double? dob;
  final double? monthlyBudgetLimit;
  final Map<String, bool>? settings;

  UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.phone,
    required this.profilePicture,
    required this.totalBalance,
    required this.totalExpense,
    required this.totalIncome,
    required this.dob,
    required this.monthlyBudgetLimit,
    required this.settings,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      totalBalance: (map['totalBalance'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (map['totalExpense'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (map['totalIncome'] as num?)?.toDouble() ?? 0.0,
      dob: (map['dob'] as num?)?.toDouble() ?? 0.0,
      monthlyBudgetLimit:
          (map['monthlyBudgetLimit'] as num?)?.toDouble() ?? 0.0,
      settings: Map<String, bool>.from(
        map['settings'] ?? {'pushNotifications': true, 'darkTheme': false},
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'username': username,
      'email': email,
      'phone': phone,
      'profilePicture': profilePicture,
      'totalBalance': totalBalance,
      'totalExpense': totalExpense,
      'totalIncome': totalIncome,
      'dob': dob,
      'monthlyBudgetLimit': monthlyBudgetLimit,
      'settings': settings,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'] ?? '',
      username: map['username'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      profilePicture: map['profilePicture'] ?? '',
      totalBalance: (map['totalBalance'] as num?)?.toDouble() ?? 0.0,
      totalExpense: (map['totalExpense'] as num?)?.toDouble() ?? 0.0,
      totalIncome: (map['totalIncome'] as num?)?.toDouble() ?? 0.0,
      dob: (map['dob'] as num?)?.toDouble() ?? 0.0,
      monthlyBudgetLimit:
          (map['monthlyBudgetLimit'] as num?)?.toDouble() ?? 0.0,
      settings: Map<String, bool>.from(
        map['settings'] ?? {'pushNotifications': true, 'darkTheme': false},
      ),
    );
  }
  Map<String, dynamic> toUpdateData() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (username != null) data['username'] = username;
    if (phone != null) data['phone'] = phone;
    if (profilePicture != null) data['profilePicture'] = profilePicture;
    if (totalBalance != null) data['totalBalance'] = totalBalance;
    if (totalExpense != null) data['totalExpense'] = totalExpense;
    if (totalIncome != null) data['totalIncome'] = totalIncome;
    if (dob != null) data['dob'] = dob;
    if (monthlyBudgetLimit != null)
      data['monthlyBudgetLimit'] = monthlyBudgetLimit;
    if (settings != null) data['settings'] = settings;
    return data;
  }
}
