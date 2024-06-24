import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/main.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:e_commerce_mobile/utils/functions.dart';
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
  bool hasConnection = true;

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    this.hasConnection = hasConnection;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Methods'),
        actions: [
          widget.userLogged.bank.cardNumber != 'none'
              ? IconButton(
                  onPressed: () {
                    editPaymentMethod(context, hasConnection);
                  },
                  icon: const Icon(Icons.edit))
              : IconButton(
                  onPressed: () {
                    editPaymentMethod(context, hasConnection);
                  },
                  icon: const Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: widget.userLogged.bank.cardNumber != 'none'
            ? Align(
                alignment: Alignment.topCenter,
                child: CreditCardUi(
                  width: 300,
                  validFrom: '****',
                  cardHolderFullName:
                      '${widget.userLogged.firstName} ${widget.userLogged.lastName}',
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
              )
            : const Center(
                child: Text(
                  'No payment method',
                  style: TextStyle(
                    fontSize: 20,
                    color: kColorSlider,
                  ),
                ),
              ),
      ),
    );
  }

  editPaymentMethod(BuildContext context, bool hasConnection) {
    if (!hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No has connection'),
      ));
      return;
    }

    TextEditingController cardNumberController =
        TextEditingController(text: widget.userLogged.bank.cardNumber == 'none' ? '' : widget.userLogged.bank.cardNumber);
    TextEditingController cardExpireController =
        TextEditingController(text:widget.userLogged.bank.cardExpire == 'none' ? '' : widget.userLogged.bank.cardExpire);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: SizedBox(
          height: 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    padding: kPadding,
                    children: [
                      const Text('Payment Method',
                          textAlign: TextAlign.center, style: kTitleTextStyle),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: cardNumberController,
                        keyboardType: TextInputType.number,
                        style: kFormTextStyle,
                        cursorColor: Colors.lime,
                        decoration: const InputDecoration(
                          labelText: 'Card Number',
                          labelStyle: kLabelTextStyle,
                          border: OutlineInputBorder(),
                          focusedBorder: kOutlineInputBorder,
                        ),
                        maxLength: 16,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your card number';
                          }
                          return null;
                        },
                      ),
                      kSpaceHeight,
                      TextFormField(
                        controller: cardExpireController,
                        keyboardType: TextInputType.text,
                        style: kFormTextStyle,
                        cursorColor: Colors.lime,
                        decoration: const InputDecoration(
                          labelText: 'Card Expire',
                          labelStyle: kLabelTextStyle,
                          hintText: '04/25',
                          border: OutlineInputBorder(),
                          focusedBorder: kOutlineInputBorder,
                        ),
                        maxLength: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your card expire';
                          }
                          try {
                            if(isValidDateFormat(value)){
                              return null;
                            }
                            else {
                              throw InvalidCardExpire();
                            }
                          } on InvalidCardExpire catch(e){
                            return e.toString();
                          } catch (e){
                            return 'error';
                          }
                        },
                      ),
                      kSpaceHeight,
                      OvalButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            if (mounted) {
                              setState(() {
                                widget.userLogged.bank = Bank(
                                    cardExpire: cardExpireController.text,
                                    cardNumber: cardNumberController.text,
                                    cardType: 'none',
                                    currency: 'none');
                              });
                            }
                            Navigator.of(context).pop();
                          }
                        },
                        text: 'Edit',
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class InvalidCardExpire implements Exception {
  @override
  String toString() {
    return 'Invalid card expire';
  }
}
