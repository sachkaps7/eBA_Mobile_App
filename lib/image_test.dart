import 'package:eyvo_inventory/core/resources/assets_manager.dart';
import 'package:flutter/material.dart';

class ImageTest extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(ImageAssets.inventory),
      ),
    );
  }
}
