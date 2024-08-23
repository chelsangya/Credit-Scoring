import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'credit_view.dart';

class InputView extends StatefulWidget {
  const InputView({super.key});

  @override
  State<InputView> createState() => _InputViewState();
}

class _InputViewState extends State<InputView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController paymentHistoryController =
      TextEditingController();
  final TextEditingController creditCardsController = TextEditingController();
  final TextEditingController loansController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  bool hasLoans = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[500],
        title: const Text(
          'Input Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 25,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              TextFormField(
                controller: paymentHistoryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Estimated Monthly Savings in NPR',
                  hintText: '20000',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(18),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the estimated cash flow.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: creditCardsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of Credit Cards',
                  hintText: '2',
                  helperStyle: TextStyle(color: Colors.black, fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                  ),
                  contentPadding: EdgeInsets.all(18),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of credit cards.';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Do you have other loans to pay?'),
                  const SizedBox(width: 10),
                  Switch(
                    value: hasLoans,
                    onChanged: (value) {
                      setState(() {
                        hasLoans = value;
                        if (!value) {
                          loansController.clear();
                          durationController.clear();
                          amountController.clear();
                        }
                      });
                    },
                  ),
                ],
              ),
              if (hasLoans)
                Column(
                  children: [
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: loansController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Number of Loans',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(18),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the number of loans.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: durationController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Duration of Loans in Months',
                        hintText: '24',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(18),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the duration of loans.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount of Loans Remaining in NPR',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        contentPadding: EdgeInsets.all(18),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the amount of loans remaining.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 400,
                      child: ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submit();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 128, 128, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 50, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final paymentHistory = double.parse(paymentHistoryController.text);
      final creditCards = int.parse(creditCardsController.text);
      final loans =
          int.parse(loansController.text.isEmpty ? '0' : loansController.text);
      final duration = int.parse(
          durationController.text.isEmpty ? '0' : durationController.text);
      final amount = double.parse(
          amountController.text.isEmpty ? '0' : amountController.text);

      final postData = {
        'payment_history': paymentHistory / 10,
        'credit_mix': creditCards + loans,
        'length_of_credit': duration,
        'amount_owed': amount * 100,
        'num_loans': loans,
        'loan_duration': duration
      };

      var url = Uri.parse('http://127.0.0.1:5000/predict');
      try {
        var response = await http.post(url,
            body: jsonEncode(postData),
            headers: {'Content-Type': 'application/json'});
        print("RESPONSE BODY: ${response.body}");
        if (response.statusCode == 200) {
          var result = json.decode(response.body);
          var predictedScore = result['prediction'];
          var recommendations = result['recommendations'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreditView(
                currentScore: predictedScore,
                recommendations: List<String>.from(recommendations),
              ),
            ),
          );
        } else {
          showErrorDialog(
              'Failed to get prediction. Status: ${response.statusCode}');
        }
      } catch (e) {
        showErrorDialog('Error occurred while sending data: $e');
      }
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
