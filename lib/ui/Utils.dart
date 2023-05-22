import 'package:flutter/widgets.dart';

Widget image(String? imagePath) {
  if (imagePath != null) {
    return Image.network(getImageUrl(imagePath));
  } else {
    return Image.asset(
      'assets/images/profile_placeholder.png',
      fit: BoxFit.cover,
    );
  }
}

String getImageUrl(String imagePath) =>
    "https://image.tmdb.org/t/p/w500/$imagePath";
