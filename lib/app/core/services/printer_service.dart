import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';

class PrinterService {
  // Thermal paper dimensions (80mm width is standard for most thermal printers)
  static const double thermalWidthMM = 80.0;
  static const double thermalWidthPoints = thermalWidthMM * PdfPageFormat.mm;

  // Create custom page format for thermal paper
  static  PdfPageFormat thermalFormat = PdfPageFormat(
    thermalWidthPoints,
    double.infinity, // Variable height
    marginAll: 2.0 * PdfPageFormat.mm, // Small margins for thermal paper
  );

  /// Generate PDF receipt optimized for thermal printing
  static Future<Uint8List> generateThermalReceipt({
    required String customerName,
    required String customerContact,
    required List<ReceiptItem> items,
    required double totalAmount,
    required double paidAmount,
    required DateTime saleDate,
    required bool isCustomerCopy,
  }) async {
    final pdf = pw.Document();
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm a');

    // Calculate dynamic height based on content
    final contentHeight = _calculateContentHeight(items.length);
    final customFormat = PdfPageFormat(
      thermalWidthPoints,
      contentHeight,
      marginAll: 2.0 * PdfPageFormat.mm,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: customFormat,
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header Section
              _buildHeader(isCustomerCopy),

              pw.SizedBox(height: 8),

              // Business Info
              _buildBusinessInfo(),

              pw.SizedBox(height: 8),

              // Sale Details
              _buildSaleDetails(
                dateFormat.format(saleDate),
                customerName,
                customerContact,
              ),

              pw.SizedBox(height: 8),

              // Items Table
              _buildItemsTable(items, isCustomerCopy),

              pw.SizedBox(height: 8),

              // Totals Section
              _buildTotalsSection(totalAmount, paidAmount),

              pw.SizedBox(height: 8),

              // Footer
              _buildFooter(),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  /// Print directly to thermal printer
  static Future<bool> printToThermal(Uint8List pdfBytes) async {
    try {
      // Get available printers
      final printers = await Printing.listPrinters();

      // Look for thermal printer (Epson TM-T20III or similar)
      Printer? thermalPrinter;

      for (final printer in printers) {
        // Check for common thermal printer names
        if (printer.name.toLowerCase().contains('tm-t20') ||
            printer.name.toLowerCase().contains('epson') ||
            printer.name.toLowerCase().contains('thermal') ||
            printer.name.toLowerCase().contains('receipt')) {
          thermalPrinter = printer;
          break;
        }
      }

      // If no specific thermal printer found, use default printer
      thermalPrinter ??= printers.isNotEmpty ? printers.first : null;

      if (thermalPrinter == null) {
        throw Exception('No printer found');
      }

      // Print with thermal-optimized settings
      final success = await Printing.directPrintPdf(
        printer: thermalPrinter,
        onLayout: (format) => pdfBytes,
        name: 'Receipt_${DateTime.now().millisecondsSinceEpoch}',
        format: thermalFormat,
      );

      return success;
    } catch (e) {
      print('Printing error: $e');
      return false;
    }
  }

  // Helper method to calculate content height
  static double _calculateContentHeight(int itemCount) {
    // Base height for header, business info, sale details, totals, footer
    double baseHeight = 120.0 * PdfPageFormat.mm;

    // Add height for each item (approximately 8mm per item)
    double itemsHeight = itemCount * 8.0 * PdfPageFormat.mm;

    // Add some padding
    double padding = 20.0 * PdfPageFormat.mm;

    return baseHeight + itemsHeight + padding;
  }

  // Build header section
  static pw.Widget _buildHeader(bool isCustomerCopy) {
    return pw.Column(
      children: [
        pw.Text(
          'YESU DEA WOOD VENTURES',
          style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          'OFFICIAL RECEIPT',
          style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 2),
        pw.Text(
          isCustomerCopy ? 'CUSTOMER COPY' : 'INTERNAL COPY',
          style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
          textAlign: pw.TextAlign.center,
        ),
        pw.Container(
          height: 1,
          width: double.infinity,
          color: PdfColors.black,
          margin: const pw.EdgeInsets.symmetric(vertical: 4),
        ),
      ],
    );
  }

  // Build business info section
  static pw.Widget _buildBusinessInfo() {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Contact: +233 XXX XXX XXXX', style: pw.TextStyle(fontSize: 9)),
        pw.Text(
          'Location: Your Business Address',
          style: pw.TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  // Build sale details section
  static pw.Widget _buildSaleDetails(
    String date,
    String? customerName,
    String? customerContact,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text('Date: $date', style: pw.TextStyle(fontSize: 9)),
        if (customerName != null && customerName.isNotEmpty) ...[
          pw.Text('Customer: $customerName', style: pw.TextStyle(fontSize: 9)),
        ],
        if (customerContact != null && customerContact.isNotEmpty) ...[
          pw.Text(
            'Contact: $customerContact',
            style: pw.TextStyle(fontSize: 9),
          ),
        ],
        pw.Container(
          height: 0.5,
          width: double.infinity,
          color: PdfColors.black,
          margin: const pw.EdgeInsets.symmetric(vertical: 4),
        ),
      ],
    );
  }

  // Build items table
  static pw.Widget _buildItemsTable(
    List<ReceiptItem> items,
    bool isCustomerCopy,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Table header
        pw.Row(
          children: [
            pw.Expanded(
              flex: 3,
              child: pw.Text(
                'Item',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.Expanded(
              flex: 1,
              child: pw.Text(
                'Qty',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.center,
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                'Price',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.right,
              ),
            ),
            pw.Expanded(
              flex: 2,
              child: pw.Text(
                'Total',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                ),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),

        pw.Container(
          height: 0.5,
          width: double.infinity,
          color: PdfColors.black,
          margin: const pw.EdgeInsets.symmetric(vertical: 2),
        ),

        // Items
        ...items
            .map(
              (item) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 2),
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 3,
                      child: pw.Text(
                        item.name,
                        style: pw.TextStyle(fontSize: 8),
                      ),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text(
                        item.quantity.toString(),
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.center,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        item.price.toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text(
                        (item.quantity * item.price).toStringAsFixed(2),
                        style: pw.TextStyle(fontSize: 8),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),

        pw.Container(
          height: 0.5,
          width: double.infinity,
          color: PdfColors.black,
          margin: const pw.EdgeInsets.symmetric(vertical: 4),
        ),
      ],
    );
  }

  // Build totals section
  static pw.Widget _buildTotalsSection(double totalAmount, double paidAmount) {
    final balance = totalAmount - paidAmount;

    return pw.Column(
      children: [
        _buildTotalRow('TOTAL:', totalAmount, bold: true),
        _buildTotalRow('PAID:', paidAmount),
        _buildTotalRow('BALANCE:', balance, bold: true),
      ],
    );
  }

  // Helper method to build total rows
  static pw.Widget _buildTotalRow(
    String label,
    double amount, {
    bool bold = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontSize: bold ? 10 : 9,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
        pw.Text(
          'GHS ${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontSize: bold ? 10 : 9,
            fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  // Build footer
  static pw.Widget _buildFooter() {
    return pw.Column(
      children: [
        pw.Container(
          height: 0.5,
          width: double.infinity,
          color: PdfColors.black,
          margin: const pw.EdgeInsets.symmetric(vertical: 4),
        ),
        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          'Powered by Yesu Dea Ventures IMS',
          style: pw.TextStyle(fontSize: 8),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }
}

// Receipt Item Model
class ReceiptItem {
  final String name;
  final double quantity;
  final double price;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
