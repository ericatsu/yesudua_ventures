import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yesudua_ventures/app/core/utils/assets.dart';

class AppConstants {
  static const String appName = "Yesu Dea Ventures IMS";

  // Supabase
  static const String supabaseUrl = "https://zrojtggzeaczgqgbolna.supabase.co";
  static const String supabaseAnonKey =
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inpyb2p0Z2d6ZWFjemdxZ2JvbG5hIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ5MTExOTksImV4cCI6MjA2MDQ4NzE5OX0.a6XVZnaxLUzjWQw-AZhuA9cHkg2s4G8QCPa9lC355kw";

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

  static final Map<String, String> categoryDefaultImages = {
    'Nails': AppAssets.nails,
    'Keys': AppAssets.locks,
    'Essah': AppAssets.soft_4x4,
    'Paint': AppAssets.deluxy,
    'Tools': AppAssets.tools,
    'Dahoma': AppAssets.soft_4x4,
    'Boards': AppAssets.soft_4x4,
    'Plywood': AppAssets.hard_4x4,
    'Other': AppAssets.defaultItem,
  };

  // Predefined categories list for easy access
  static List<String> get categoryNames => categoryDefaultImages.keys.toList();

  static String getDefaultImageForCategory(String categoryName) {
    return categoryDefaultImages[categoryName.toLowerCase()] ??
        AppAssets.defaultItem;
  }

  static const double defaultSpacing = 16.0;
  static const double sectionSpacing = 24.0;

  static const TextInputType numberInputType = TextInputType.numberWithOptions(
    decimal: true,
  );
}
