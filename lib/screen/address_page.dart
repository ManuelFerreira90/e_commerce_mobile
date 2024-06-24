import 'package:e_commerce_mobile/components/oval_button.dart';
import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/styles/const.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({
    super.key,
    required this.userLogged,
  });

  final User userLogged;

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  bool hasConnection = true;

  @override
  Widget build(BuildContext context) {
    final hasConnection = ConnectionNotifier.of(context).value;
    this.hasConnection = hasConnection;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Address'),
        actions: [
          widget.userLogged.address.state != 'none'
              ? IconButton(
              onPressed: () {
                editAddress(context, hasConnection);
              },
              icon: const Icon(Icons.edit))
              : IconButton(
              onPressed: () {
                editAddress(context, hasConnection);
              },
              icon: const Icon(Icons.add))
        ],
      ),
      body: widget.userLogged.address.state != 'none' ? Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      '${widget.userLogged.firstName} ${widget.userLogged.lastName}',
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userLogged.address.address,
                          overflow: TextOverflow.clip,
                          style: kInfoAddress,
                        ),
                        Text(
                          '${widget.userLogged.address.city}, ${widget.userLogged.address.state}',
                          overflow: TextOverflow.clip,
                          style: kInfoAddress,
                        ),
                        Text(
                          widget.userLogged.address.postalCode,
                          overflow: TextOverflow.clip,
                          style: kInfoAddress,
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.orange,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: 12.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ) : const Center(
        child: Text(
          'No address',
          style: TextStyle(
            fontSize: 20,
            color: kColorSlider,
          ),
        ),
      ),
    );
  }

  editAddress(BuildContext context, bool hasConnection) {
    if (!hasConnection) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('No has connection'),
      ));
      return;
    }

    TextEditingController addressController =
    TextEditingController(text: widget.userLogged.address.state == 'none' ? '' : widget.userLogged.address.address);
    TextEditingController cityController =
    TextEditingController(text:widget.userLogged.address.state == 'none' ? '' : widget.userLogged.address.city);
    TextEditingController stateController =
    TextEditingController(text:widget.userLogged.address.state == 'none' ? '' : widget.userLogged.address.state);
    TextEditingController postalCodeController =
    TextEditingController(text:widget.userLogged.address.state == 'none' ? '' : widget.userLogged.address.postalCode);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: SizedBox(
          height: 580,
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
                      const Text('Address',
                          textAlign: TextAlign.center, style: kTitleTextStyle),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: addressController,
                        keyboardType: TextInputType.text,
                        style: kFormTextStyle,
                        cursorColor: Colors.lime,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          labelStyle: kLabelTextStyle,
                          hintText: 'Ex: 1896 Washington Street',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(),
                          focusedBorder: kOutlineInputBorder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      kSpaceHeight,
                      TextFormField(
                        controller: cityController,
                        keyboardType: TextInputType.text,
                        style: kFormTextStyle,
                        cursorColor: Colors.lime,
                        decoration: const InputDecoration(
                          labelText: 'City',
                          labelStyle: kLabelTextStyle,
                          hintText: 'Dallas',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(),
                          focusedBorder: kOutlineInputBorder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your city';
                          }
                          return null;
                        },
                      ),
                      kSpaceHeight,
                      TextFormField(
                        controller: stateController,
                        keyboardType: TextInputType.text,
                        style: kFormTextStyle,
                        cursorColor: Colors.lime,
                        decoration: const InputDecoration(
                          labelText: 'State',
                          hintText: 'Nevada',
                          hintStyle: TextStyle(fontSize: 12),
                          labelStyle: kLabelTextStyle,
                          border: OutlineInputBorder(),
                          focusedBorder: kOutlineInputBorder,
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your state';
                          }
                          return null;
                        },
                      ),
                      kSpaceHeight,
                      TextFormField(
                        controller: postalCodeController,
                        keyboardType: TextInputType.number,
                        style: kFormTextStyle,
                        cursorColor: Colors.lime,
                        decoration: const InputDecoration(
                          labelText: 'Postal Code',
                          labelStyle: kLabelTextStyle,
                          hintText: '88511',
                          hintStyle: TextStyle(fontSize: 12),
                          border: OutlineInputBorder(),
                          focusedBorder: kOutlineInputBorder,
                        ),
                        maxLength: 5,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your portal code';
                          }
                          return null;
                        },
                      ),
                      kSpaceHeight,
                      OvalButton(
                        function: () {
                          if (formKey.currentState!.validate()) {
                            if (mounted) {
                              setState(() {
                                widget.userLogged.address = Address(address: addressController.text, city: cityController.text, postalCode: postalCodeController.text, state: stateController.text);
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
