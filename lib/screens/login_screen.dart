import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:societe_generale_client/helpers/general.dart';
import 'package:societe_generale_client/helpers/localstorage.dart';
import 'package:societe_generale_client/main.dart';
import 'package:societe_generale_client/screens/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _savePhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber = _phoneNumberController.text;
      String name = _nameController.text;

      try {
        await _firestore.collection('user').doc(phoneNumber).set({'phone_number': phoneNumber, 'name': name});
        globalName = name;
        globalPhoneNumber = phoneNumber;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number saved successfully')),
        );
        LocalStorage().storage.setString('user', jsonEncode({'name': name, 'phone':phoneNumber}));
        Navigator.push(context, MaterialPageRoute(builder: (context) => DashboardScren()));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save phone number: $e')),
        );
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Phone Number Form'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a phone number';
                  } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                    return 'Please enter a valid 10 digit phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
                keyboardType: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              AppButton(content: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: const Text('Login', style: TextStyle(color: Colors.white),),
              ), onTap: _savePhoneNumber)
            ],
          ),
        ),
      ),
    );
  }
}
