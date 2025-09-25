import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  final receipt = Receipt(
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

class Receipt {
  final String customerName;
  final String customerContact;
  final List<ReceiptItem> items;
  final double totalAmount;
  final double paidAmount;
  final DateTime saleDate;
  final bool isCustomerCopy;

  Receipt({
    required this.customerName,
    required this.customerContact,
    required this.items,
    required this.totalAmount,
    required this.paidAmount,
    required this.saleDate,
    required this.isCustomerCopy,
  });

  late String _logo;

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    _logo = await rootBundle.loadString('assets/images/logo.svg');
    doc.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: pageFormat,
          theme: pw.ThemeData.withFont(
            base: await PdfGoogleFonts.robotoRegular(),
            bold: await PdfGoogleFonts.robotoBold(),
            italic: await PdfGoogleFonts.robotoItalic(),
          ),
        ),
        header: _buildHeader,
        build:
            (context) => [
              pw.SizedBox(height: 10),
              pw.Text(
                isCustomerCopy ? 'Customer Copy' : 'Shop Copy',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.Text('Customer Name: $customerName'),
              pw.Text('Contact: $customerContact'),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                headers: ['Item', 'Qty', 'Price', 'Total'],
                data:
                    items.map((item) {
                      final total = item.quantity * item.price;
                      return [
                        item.name,
                        item.quantity.toString(),
                        item.price.toStringAsFixed(2),
                        total.toStringAsFixed(2),
                      ];
                    }).toList(),
                border: null,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                cellAlignment: pw.Alignment.centerLeft,
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
                cellHeight: 25,
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(1),
                  2: const pw.FlexColumnWidth(2),
                  3: const pw.FlexColumnWidth(2),
                },
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Row(
                        children: [
                          pw.Text(
                            'Total Amount: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(totalAmount.toStringAsFixed(2)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Paid Amount: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(paidAmount.toStringAsFixed(2)),
                        ],
                      ),
                      pw.Row(
                        children: [
                          pw.Text(
                            'Balance: ',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          ),
                          pw.Text(
                            (totalAmount - paidAmount).toStringAsFixed(2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
        footer: _buildFooter,
      ),
    );

    return doc.save();
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.SvgImage(svg: _logo, width: 50, height: 50),
            pw.Text(
              'Yesu Dua Wood Ventures',
              style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Text('Mayera, Pokuasi, Ghana'),
        pw.Text('Phone: 0243596546'),
        pw.Text(
          DateFormat('yyyy-MM-dd HH:mm').format(saleDate),
          style: pw.TextStyle(fontSize: 10),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Column(
      children: [
        pw.Divider(),
        pw.Text(
          'Thank you for your business!',
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'Powered by Eric Atsu',
          style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          '0500882796/0542818937',
          style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic),
        ),
      ],
    );
  }
}

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