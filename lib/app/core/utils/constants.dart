import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yesudua_ventures/app/core/utils/assets.dart';

class AppConstants {
  static const String appName = "Yesu Dea Ventures IMS";

  // Drift DB
  static const String localDbName = "inventory_management.db";

  // Table Names
  static const String inventoryTable = "inventory_items";
  static const String salesTable = "sales";
  static const String debtorsTable = "debtors";
  static const String suppliersTable = "suppliers";

  // UI constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double defaultBorderRadius = 8.0;
  static const double defaultElevation = 2.0;

  // Currency formatter
  static final currencyFormatter = NumberFormat.currency(
    symbol: '₵',
    decimalDigits: 2,
  );

  // Date formatter
  static final dateFormatter = DateFormat('dd/MM/yyyy');
  static final dateTimeFormatter = DateFormat('dd/MM/yyyy HH:mm');

  // Updated categoryItems structure in constants.dart

  static final Map<String, Map<String, String>> categoryItems = {
    'Nails': {
      'Roofing': AppAssets.nails,
      'Tackling': AppAssets.nails,
      'Common_n': AppAssets.nails,
      'Supacem': AppAssets.nails,
    },
    'Essah': {
      'Hard 4x4': AppAssets.hard_4x4,
      'Soft 4x4': AppAssets.soft_4x4,
      'Hard 2x4': AppAssets.defaultItem,
      'Soft 2x4': AppAssets.defaultItem,
    },
    'Keys': {
      'Jb': AppAssets.locks,
      'Everlove': AppAssets.locks,
      'Elephant': AppAssets.locks,
      'Zocco': AppAssets.locks,
      'Genesis': AppAssets.locks,
    },
    'Paint': {
      'White Glue': AppAssets.deluxy,
      'Bonder': AppAssets.deluxy,
      'Roller': AppAssets.deluxy,
      'Super Glue': AppAssets.deluxy,
      'Mortar': AppAssets.deluxy,
      'Fomma': AppAssets.deluxy,
      'Par Hock': AppAssets.deluxy,
      'Running Oil': AppAssets.deluxy,
      'Gold Cat 4s': AppAssets.deluxy,
      'Top Coat 4s': AppAssets.deluxy,
    },
    'Tools': {
      'Hammer': AppAssets.tools,
      'Screwdriver': AppAssets.tools,
      'Wrench': AppAssets.tools,
    },
    'Boards': {
      'Red': AppAssets.hard_4x4,
      'Ofram': AppAssets.soft_4x4,
      'Wawa': AppAssets.hard_4x4,
    },
    'Plywood': {
      '3/4 Plywood': AppAssets.hard_4x4,
      '1/2 Plywood': AppAssets.soft_4x4,
      '1/4 Plywood': AppAssets.hard_4x4,
    },
    'Flame': {
      '4x4 Flame': AppAssets.hard_4x4,
      '4x3 Flame': AppAssets.soft_4x4,
      'Door Frame': AppAssets.defaultItem,
      'Trapdoor': AppAssets.defaultItem,
    },
    'Dahoma': {
      '2x6 Dahoma': AppAssets.hard_4x4,
      '2x4 Dahoma': AppAssets.soft_4x4,
      '2x3 Dahoma': AppAssets.hard_4x4,
      '2x2 Dahoma': AppAssets.soft_4x4,
    },
    'Others': {
      'misc': AppAssets.defaultItem,
    },
  };

  // Predefined categories list for easy access
  static List<String> get categoryNames => categoryItems.keys.toList();

  static const double defaultSpacing = 16.0;
  static const double sectionSpacing = 24.0;

  static const TextInputType numberInputType = TextInputType.numberWithOptions(
    decimal: true,
  );
}
