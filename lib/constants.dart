import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

final kMyInputDecoration = InputDecoration(
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 10),
);

const String kMyPhoneNumber = '+11111111111';

List<MultiSelectItem> kCategories = [
  MultiSelectItem('Electronic', 'Electronic'),
  MultiSelectItem('Wearing', 'Wearing'),
  MultiSelectItem('Building', 'Building'),
  MultiSelectItem('Eating', 'Eating'),
  MultiSelectItem('Cooking', 'Cooking'),
];
