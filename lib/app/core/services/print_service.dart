import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:yesudua_ventures/app/modules/sales/widgets/receipt_view.dart';

Future<Uint8List> generateReceipt(
  PdfPageFormat pageFormat,
  String customerName,
  String customerContact,
  List<ReceiptItem> items,
  double totalAmount,
  double paidAmount,
  DateTime saleDate,
  bool isCustomerCopy,
) async {
  final receipt = ThermalReceipt(
    customerName: customerName,
    customerContact: customerContact,
    items: items,
    totalAmount: totalAmount,
    paidAmount: paidAmount,
    saleDate: saleDate,
    isCustomerCopy: isCustomerCopy,
  );
  return await receipt.buildPdf(pageFormat);
}

class ThermalReceipt {
  final String customerName;
  final String customerContact;
  final List<ReceiptItem> items;
  final double totalAmount;
  final double paidAmount;
  final DateTime saleDate;
  final bool isCustomerCopy;

  ThermalReceipt({
    required this.customerName,
    required this.customerContact,
    required this.items,
    required this.totalAmount,
    required this.paidAmount,
    required this.saleDate,
    required this.isCustomerCopy,
  });

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    
    // Use 80mm width for thermal receipt (standard for TM-T20III)
    final thermalFormat = PdfPageFormat(
      80 * PdfPageFormat.mm,
      double.infinity, // Auto height
      marginAll: 5 * PdfPageFormat.mm,
    );

    doc.addPage(
      pw.Page(
        pageFormat: thermalFormat,
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.robotoRegular(),
          bold: await PdfGoogleFonts.robotoBold(),
        ),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context),
            _buildDivider(),
            pw.SizedBox(height: 5),
            
            // Copy Type
            pw.Center(
              child: pw.Text(
                isCustomerCopy ? '*** CUSTOMER COPY ***' : '*** SHOP COPY ***',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 8),
            
            // Customer Info
            _buildCustomerInfo(),
            pw.SizedBox(height: 8),
            _buildDivider(),
            pw.SizedBox(height: 5),
            
            // Items
            ...items.map((item) => _buildItem(item)),
            pw.SizedBox(height: 5),
            _buildDivider(),
            pw.SizedBox(height: 8),
            
            // Totals
            _buildTotals(),
            pw.SizedBox(height: 8),
            _buildDivider(),
            pw.SizedBox(height: 8),
            
            // Footer
            _buildFooter(),
            pw.SizedBox(height: 10),
          ],
        ),
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'YESU DUA WOOD VENTURES',
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: 3),
        pw.Text(
          'Mayera Fase Junction',
          style: const pw.TextStyle(fontSize: 9),
        ),
        pw.Text(
          '0243596546 / 0556792084',
          style: const pw.TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  pw.Widget _buildCustomerInfo() {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');
    
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Customer:', style: const pw.TextStyle(fontSize: 9)),
            pw.Expanded(
              child: pw.Text(
                customerName.isNotEmpty ? customerName : 'Walk-in',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.right,
              ),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Contact:', style: const pw.TextStyle(fontSize: 9)),
            pw.Text(
              customerContact.isNotEmpty ? customerContact : 'N/A',
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
        pw.SizedBox(height: 2),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Date:', style: const pw.TextStyle(fontSize: 9)),
            pw.Text(
              dateFormat.format(saleDate),
              style: const pw.TextStyle(fontSize: 9),
            ),
          ],
        ),
      ],
    );
  }

  pw.Widget _buildItem(ReceiptItem item) {
    final total = item.quantity * item.price;
    
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          // Item name
          pw.Text(
            item.name,
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
          ),
          pw.SizedBox(height: 2),
          // Quantity, price, and total
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${item.quantity.toInt()} x GHS ${item.price.toStringAsFixed(2)}',
                style: const pw.TextStyle(fontSize: 9),
              ),
              pw.Text(
                'GHS ${total.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTotals() {
    final balance = totalAmount - paidAmount;
    
    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'TOTAL:',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
            pw.Text(
              'GHS ${totalAmount.toStringAsFixed(2)}',
              style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.SizedBox(height: 3),
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text('Paid:', style: const pw.TextStyle(fontSize: 10)),
            pw.Text(
              'GHS ${paidAmount.toStringAsFixed(2)}',
              style: const pw.TextStyle(fontSize: 10),
            ),
          ],
        ),
        if (balance > 0) ...[
          pw.SizedBox(height: 3),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'BALANCE:',
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                'GHS ${balance.toStringAsFixed(2)}',
                style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ],
    );
  }

  pw.Widget _buildFooter() {
    return pw.Center(
      child: pw.Column(
        children: [
          pw.Text(
            'Goods sold are not returnable',
            style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Thank you for your business!',
            style: const pw.TextStyle(fontSize: 9),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }

  pw.Widget _buildDivider() {
    return pw.Container(
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(width: 0.5),
        ),
      ),
    );
  }
}