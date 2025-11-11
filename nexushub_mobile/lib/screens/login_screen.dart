import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nexushub/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _emailOrMobile = '';
  String _otp = '';
  bool _otpSent = false;
  final _storage = const FlutterSecureStorage();

  Future<void> _getOtp() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final url = Uri.parse('http://localhost:3001/generate-otp');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'emailOrMobile': _emailOrMobile}),
        );
        if (response.statusCode == 200) {
          setState(() {
            _otpSent = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP sent to console')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _verifyOtp() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      final url = Uri.parse('http://localhost:3001/verify-otp');
      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({'emailOrMobile': _emailOrMobile, 'otp': _otp}),
        );
        if (response.statusCode == 200) {
          final token = json.decode(response.body)['token'];
          await _storage.write(key: 'jwt', value: token);
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${response.body}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NexusHub'),
      ),
      body: Center(
        child: Card(
          margin: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextFormField(
                      key: const ValueKey('emailOrMobile'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter your email or mobile number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _emailOrMobile = value!;
                      },
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email or Mobile Number',
                      ),
                    ),
                    if (_otpSent)
                      TextFormField(
                        key: const ValueKey('otp'),
                        validator: (value) {
                          if (value!.isEmpty || value.length != 6) {
                            return 'Please enter a valid 6-digit OTP.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _otp = value!;
                        },
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'OTP',
                        ),
                      ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _otpSent ? _verifyOtp : _getOtp,
                      child: Text(_otpSent ? 'Verify OTP' : 'Get OTP'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
