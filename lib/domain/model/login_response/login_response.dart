class LoginResponse {
  final Token? token;
  final String? phone;
  final bool? status;
  final bool? privilage;
  final String? message;

  LoginResponse({
    this.token,
    this.phone,
    this.status,
    this.privilage,
    this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] != null ? Token.fromJson(json['token']) : null,
      phone: json['phone'],
      status: json['status'],
      privilage: json['privilage'],
      message: json['message'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token?.toJson(),
      'phone': phone,
      'status': status,
      'privilage': privilage,
      'message': message,
    };
  }
}

class Token {
  final String? refresh;
  final String? access;

  Token({
    this.refresh,
    this.access,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      refresh: json['refresh'],
      access: json['access'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'refresh': refresh,
      'access': access,
    };
  }
}
