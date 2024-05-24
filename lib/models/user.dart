class User {
  final int id;
  final String firstName;
  final String lastName;
  final String? maidenName;
  final int age;
  final String email;
  final String phone;
  final String username;
  final String password;
  final String image;
  final Address address;
  final String university;
  final Bank bank;
  final String ssn;
  final Crypto crypto;
  final String job;

  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.maidenName,
    required this.age,
    required this.email,
    required this.phone,
    required this.username,
    required this.password,
    required this.image,
    required this.address,
    required this.university,
    required this.bank,
    required this.ssn,
    required this.crypto,
    required this.job,
  });

}

class Hair {
  final String color;
  final String type;

  Hair({
    required this.color,
    required this.type,
  });
}

class Address {
  final String address;
  final String city;
  final String postalCode;
  final String state;

  Address({
    required this.address,
    required this.city,
    required this.postalCode,
    required this.state,
  });
}

class Bank {
  final String cardExpire;
  final String cardNumber;
  final String cardType;
  final String currency;

  Bank({
    required this.cardExpire,
    required this.cardNumber,
    required this.cardType,
    required this.currency,
  });
}

class Crypto {
  final String coin;
  final String wallet;
  final String network;

  Crypto({
    required this.coin,
    required this.wallet,
    required this.network,
  });
}
