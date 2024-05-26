import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePicController extends ChangeNotifier {
 static Map<String, dynamic> photos = {};

  // Method to store the image for a user ID
  void storeImageForUserId(String userId, File image) {
    photos[userId] = image;
    notifyListeners(); // Notify listeners that the data has changed
  }
}