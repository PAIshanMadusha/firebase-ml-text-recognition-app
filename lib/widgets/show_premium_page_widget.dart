import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ml_text_recognition_app/provider/premium_provider.dart';
import 'package:firebase_ml_text_recognition_app/services/stripe/stripe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Text(
                "To View Your Captured History, Please Activate the Premium Version",
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 15),
              SvgPicture.asset(
                "assets/onlinepayments.svg",
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 35),
              Text(
                "Your ID: ${FirebaseAuth.instance.currentUser?.uid}",
                style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
              ),
              SizedBox(height: 35),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  hintText: "Enter Your Name",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  filled: true,
                  // ignore: deprecated_member_use
                  fillColor: Colors.grey.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
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
              SizedBox(height: 25),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 30,
                    vertical: 30,
                  ),
                  hintText: "Enter Your Email",
                  hintStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  filled: true,
                  // ignore: deprecated_member_use
                  fillColor: Colors.grey.withOpacity(0.1),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
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
              SizedBox(height: 25),
              ElevatedButton(
                onPressed: _submit,
                child: Text(
                  "Active Premium for \$2.85",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
