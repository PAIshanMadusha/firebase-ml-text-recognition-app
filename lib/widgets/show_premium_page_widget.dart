import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_text_recognition_app/provider/premium_provider.dart';
import 'package:firebase_ml_text_recognition_app/services/stripe/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ShowPremiumPageWidget extends StatefulWidget {
  const ShowPremiumPageWidget({super.key});

  @override
  State<ShowPremiumPageWidget> createState() => _ShowPremiumPageWidgetState();
}

class _ShowPremiumPageWidgetState extends State<ShowPremiumPageWidget> {
  final _formKey = GlobalKey<FormState>();
  String email = "";
  String name = "";
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  //Email Validation
  final RegExp _emailRegex = RegExp(
    r'^[^@]+@[^@]+\.[^@]+$',
    caseSensitive: false,
  );

  //Form Submission Handler
  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await init(name: name, email: email);
      if (mounted) {
        Provider.of<PremiumProvider>(
          context,
          listen: false,
        ).checkPremiumStates();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              "To View Your Capture History, Please Activate the Premium Feature",
            ),
            SizedBox(height: 15),
            Text("User Id: ${FirebaseAuth.instance.currentUser?.uid}"),
            SizedBox(height: 15),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Enter Your Name"),
              onChanged: (value) {
                setState(() {
                  name = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Your Name";
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Enter Your Email"),
              onChanged: (value) {
                setState(() {
                  email = value;
                });
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please Enter Your Email";
                }
                if (!_emailRegex.hasMatch(value)) {
                  return "Please Enter a Valid Email Address";
                }
                return null;
              },
            ),
            SizedBox(height: 15),
            ElevatedButton(
              onPressed: _submit,
              child: Text("Active Premium for \$2.85"),
            ),
          ],
        ),
      ),
    );
  }
}
