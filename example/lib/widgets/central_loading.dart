import 'package:flutter/material.dart';

class CentralLoading extends StatelessWidget {
  const CentralLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Card.outlined(
        elevation: 6,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Loading..."),
              SizedBox(height: 25),
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
