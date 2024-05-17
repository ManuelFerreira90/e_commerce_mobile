class User{
  final int? _ssn;
  final String? _name;
  final String? _lastName;
  final String? _email;
  final String? _image;
  final String? _phone;
  final Map<String, dynamic>? _address;

  User(int? ssn, String? name, String? lastName, String? email, String? image, String? phone, Map<String, dynamic>? address)
      : _ssn = ssn,
        _name = name,
        _lastName = lastName,
        _email = email,
        _image = image,
        _phone = phone,
        _address = address;

  int? get ssn => _ssn;
  String? get name => _name;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get image => _image;
  String? get phone => _phone;
  Map<String, dynamic>? get address => _address;
}
