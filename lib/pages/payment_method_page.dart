import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:paymob_payment/paymob_payment.dart';
import 'package:task6_adv/pages/home_page.dart';
import 'package:task6_adv/utility/color_utility.dart';
import 'package:task6_adv/widgets/app_bar_title_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PaymentMethodPage extends StatefulWidget {
  static const String id = 'PaymentMethodPage';
  final double totalPrice;
  final String courseId;
  const PaymentMethodPage(
      {required this.courseId, required this.totalPrice, super.key});

  @override
  State<PaymentMethodPage> createState() => _PaymentMethodPageState();
}

class _PaymentMethodPageState extends State<PaymentMethodPage> {
  String _selectedMethod = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: const AppBarTitleWidget(title: 'Payment Method'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Select Your Payment Method',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            buildPaymentMethodTile(
              'Paymob',
              () async {
                await _handlePaymobPayment();
              },
            ),
            buildPaymentMethodTile('Apple Pay', () {}),
            buildPaymentMethodTile('Google Pay', () {}),
            buildPaymentMethodTile('Card', () {}, isLast: true),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentMethodTile(String method, void Function() handleOnTap,
      {bool isLast = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMethod = method;
        });
        handleOnTap();
      },
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Container(
          margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          decoration: BoxDecoration(
            color: _selectedMethod == method
                ? ColorUtility.scaffoldBackground
                : ColorUtility.whiteGray,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: _selectedMethod == method
                  ? ColorUtility.secondry
                  : Colors.transparent,
              width: 2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                method,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Radio<String>(
                value: method,
                groupValue: _selectedMethod,
                onChanged: (String? value) {
                  setState(() {
                    _selectedMethod = value!;
                  });
                },
                activeColor: ColorUtility.secondry,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handlePaymobPayment() async {
    try {
      PaymobPayment.instance.initialize(
        apiKey: dotenv.env[
            'apiKey']!,
        integrationID: int.parse(dotenv.env[
            'integrationID']!), 
        iFrameID: int.parse(dotenv
            .env['iFrameID']!), 
      );

      final PaymobResponse? response = await PaymobPayment.instance.pay(
        context: context,
        currency: "EGP",
        amountInCents: "${widget.totalPrice}", 
      );

      if (response != null) {
        print('Transaction ID: ${response.transactionID}');
        print('Payment success: ${response.success}');

        if (response.success) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment Successful'),
                backgroundColor: Colors.green,
              ),
            );
          }

  
          await _addCourseToFirestore();
          Navigator.pushReplacementNamed(context, HomePage.id);
        } else {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Payment Failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error during payment: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Payment Error'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addCourseToFirestore() async {
    try {
      final User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userDoc = _firestore.collection('users').doc(currentUser.uid);

        
        await userDoc.update({
          'courses': FieldValue.arrayUnion([widget.courseId]),
        });

        print('Course added to Firestore.');
      }
    } catch (e) {
      print('Error updating Firestore: $e');
    }
  }
}
