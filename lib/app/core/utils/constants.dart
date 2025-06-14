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

  static final Map<String, Map<String, String>> categoryItems = {
    'cement': {
      'dangote': AppAssets.dangote,
      'ghacem': AppAssets.ghacem,
      'supacem': AppAssets.defaultItem,
    },
    'timber': {
      'hard_4x4': AppAssets.hard_4x4,
      'soft_4x4': AppAssets.soft_4x4,
      'hard_2x4': AppAssets.defaultItem,
      'soft_2x4': AppAssets.defaultItem,
    },
    'steel': {
      'rebar': AppAssets.steel,
      'angle_iron': AppAssets.defaultItem,
      'flat_bar': AppAssets.defaultItem,
    },
    'paint': {
      'coral': AppAssets.coral,
      'deluxy': AppAssets.deluxy,
      'leyland': AppAssets.leyland,
      'neuce': AppAssets.neuce,
    },
    'tools': {
      'hammer': AppAssets.tools,
      'screwdriver': AppAssets.defaultItem,
      'wrench': AppAssets.defaultItem,
    },
    'electrical': {
      'cable': AppAssets.electrical,
      'switch': AppAssets.defaultItem,
      'socket': AppAssets.defaultItem,
    },
    'plumbing': {
      'pipe': AppAssets.plumbing,
      'elbow': AppAssets.defaultItem,
      'valve': AppAssets.defaultItem,
    },
    'bricks': {
      'red_brick': AppAssets.defaultItem,
      'concrete_block': AppAssets.defaultItem,
    },
    'hardware': {
      'nail': AppAssets.defaultItem,
      'screw': AppAssets.defaultItem,
      'bolt': AppAssets.defaultItem,
    },
    'roofing': {
      'aluminum_sheet': AppAssets.defaultItem,
      'tile': AppAssets.defaultItem,
    },
    'other': {'misc': AppAssets.defaultItem},
  };

  // Predefined categories list for easy access
  static List<String> get categoryNames => categoryItems.keys.toList();

  // Predefined categories
  // static const List<String> categoryItems = [
  //   'Cement',
  //   'Steel',
  //   'Timber',
  //   'Paint',
  //   'Bricks',
  //   'Tools',
  //   'Electrical',
  //   'Plumbing',
  //   'Roofing',
  //   'Hardware',
  //   'Other',
  // ];
}
