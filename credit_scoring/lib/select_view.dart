import 'package:credit_scoring/build_button.dart';
import 'package:flutter/material.dart';

class SelectView extends StatelessWidget {
  const SelectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[500],
        title: const Text(
          textAlign: TextAlign.start,
          'Credit Scoring',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 20,
            ),
            // text to say whether you are checking as individual or bank
            Text(
              'Select the type of credit scoring you want to check',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            buildButton(
                context: context,
                onPressed: () {
                  Navigator.of(context).pushNamed('/input');
                },
                icon: Icons.person,
                label: 'As an Individual'),
            const SizedBox(
              height: 20,
            ),
            buildButton(
                context: context,
                onPressed: () {
                   Navigator.of(context).pushNamed('/upload');
                },
                icon: Icons.business,
                label: 'As a Bank'),
          ],
        ),
      ),
    );
  }
}
