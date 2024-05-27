import 'package:e_commerce_mobile/models/user.dart';
import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

class PaymentsMethodsPage extends StatefulWidget {
  const PaymentsMethodsPage({
    super.key,
    required this.userLogged,
  });

  final User userLogged;

  @override
  State<PaymentsMethodsPage> createState() => _PaymentsMethodsPageState();
}

class _PaymentsMethodsPageState extends State<PaymentsMethodsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Align(
          alignment: Alignment.topCenter,
          child: CreditCardUi(
            width: 300,
            validFrom: '****',
            cardHolderFullName: '${widget.userLogged.firstName} ${widget.userLogged.lastName}',
            cardNumber: widget.userLogged.bank.cardNumber,
            validThru: widget.userLogged.bank.cardExpire,
            topLeftColor: Colors.blue,
            doesSupportNfc: true,
            placeNfcIconAtTheEnd: true,
            cardType: CardType.debit,
            cardProviderLogo: const FlutterLogo(),
            cardProviderLogoPosition: CardProviderLogoPosition.right,
            enableFlipping: true,
            cvvNumber: '***',
          ),
        ),
      ),
    );
  }
}


