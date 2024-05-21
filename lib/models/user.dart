class User{
  final String? _ssn;
  final String? _name;
  final String? _lastName;
  final String? _email;
  final String? _image;
  final String? _phone;
  final Map<String, dynamic>? _address;

  User(String? ssn, String? name, String? lastName, String? email, String? image, String? phone, Map<String, dynamic>? address)
      : _ssn = ssn,
        _name = name,
        _lastName = lastName,
        _email = email,
        _image = image,
        _phone = phone,
        _address = address;

  String? get ssn => _ssn;
  String? get name => _name;
  String? get lastName => _lastName;
  String? get email => _email;
  String? get image => _image;
  String? get phone => _phone;
  Map<String, dynamic>? get address => _address;
}
