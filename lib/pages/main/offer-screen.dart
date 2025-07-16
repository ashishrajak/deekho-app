
import 'package:flutter/material.dart';
import 'package:my_flutter_app/config/AppTheme.dart';
import 'package:my_flutter_app/main.dart';

class OffersScreen extends StatelessWidget {
  const OffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        backgroundColor: AppTheme.backgroundColor,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Offers Screen Coming Soon!',
          style: AppTheme.headlineMedium,
        ),
      ),
    );
  }
}
