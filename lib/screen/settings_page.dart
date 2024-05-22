import 'package:e_commerce_mobile/models/user.dart';
import 'package:e_commerce_mobile/screen/address_page.dart';
import 'package:e_commerce_mobile/screen/payments_methods_page.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({
    super.key,
    required this.userLogged,
  });

  final User userLogged;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => PaymentsMethodsPage(userLogged: userLogged)
                    )
                );
              },
              leading: const Icon(Icons.payment_outlined, color: Colors.white,),
              title: const Text('Payment Methods'),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddressPage(userLogged: userLogged)
                    )
                );
              },
              leading: const Icon(Icons.mail_outline, color: Colors.white,),
              title: const Text('Address'),
            ),
          ],
        ),
      ),
    );
  }
}
