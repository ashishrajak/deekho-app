// Login/Signup Screen
import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';
import 'package:my_flutter_app/pages/main/login-form.dart';
import 'package:my_flutter_app/pages/main/signup.dart';

class AuthScreen extends StatefulWidget {
  final Function(UserProfile) onAuthComplete;

  const AuthScreen({super.key, required this.onAuthComplete});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final PageController _pageController = PageController();
  bool _isLogin = true;
  
  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
    _pageController.animateToPage(
      _isLogin ? 0 : 1,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Create Account'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _isLogin = index == 0;
          });
        },
        children: [
          LoginForm(
            onLoginSuccess: widget.onAuthComplete,
            onSwitchToSignup: _toggleAuthMode,
          ),
          SignupForm(
            onSignupSuccess: widget.onAuthComplete,
            onSwitchToLogin: _toggleAuthMode,
          ),
        ],
      ),
    );
  }
}
