import 'package:flutter/material.dart';
import 'package:web_buses/pages/home_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  '/': (_) => const HomePage()
};
