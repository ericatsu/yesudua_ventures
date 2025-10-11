import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
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

  Future<Uint8List> buildPdf(PdfPageFormat pageFormat) async {
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: pageFormat,
        theme: pw.ThemeData.withFont(
          base: await PdfGoogleFonts.robotoRegular(),
          bold: await PdfGoogleFonts.robotoBold(),
          italic: await PdfGoogleFonts.robotoItalic(),
        ),
        margin: pw.EdgeInsets.only(left: 20, top: 20, right: 20, bottom: 20),
        build:
            (context) => pw.Container(
              width: 320,
              child: pw.Column(
                children: [
                  _buildHeader(context),
                  pw.SizedBox(height: 15),
                  pw.Text(
                    isCustomerCopy ? 'Customer Copy' : 'Shop Copy',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children:
                        items.map((item) {
                          final total = item.quantity * item.price;
                          return pw.Padding(
                            padding: pw.EdgeInsets.symmetric(vertical: 3),
                            child: pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Expanded(
                                  child: pw.Text(
                                    '${item.quantity.toInt().toString()} - ${item.name}\'s',
                                    style: pw.TextStyle(fontSize: 12),
                                  ),
                                ),
                                pw.Text(
                                  '@${item.price.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 11),
                                ),
                                pw.SizedBox(width: 8),
                                pw.Text(
                                  'GHS ${total.toStringAsFixed(2)}',
                                  style: pw.TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                  pw.SizedBox(height: 15),
                  pw.Divider(thickness: 1),
                  pw.SizedBox(height: 10),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Container(
                        width: 200,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            _buildSummaryRow('Total Amount:', totalAmount),
                            pw.SizedBox(height: 5),
                            _buildSummaryRow('Paid Amount:', paidAmount),
                            pw.SizedBox(height: 5),
                            _buildSummaryRow(
                              'Balance:',
                              totalAmount - paidAmount,
                              isBalance: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  _buildFooter(context),
                ],
              ),
            ),
      ),
    );

    return doc.save();
  }

  pw.Widget _buildSummaryRow(
    String label,
    double amount, {
    bool isBalance = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          label,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: isBalance ? 13 : 12,
          ),
        ),
        pw.Text(
          'GHS ${amount.toStringAsFixed(2)}',
          style: pw.TextStyle(
            fontSize: isBalance ? 13 : 12,
            fontWeight: isBalance ? pw.FontWeight.bold : pw.FontWeight.normal,
          ),
        ),
      ],
    );
  }

  pw.Widget _buildHeader(pw.Context context) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Text(
          'Yesu Dua Wood Ventures',
          style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 8),
        pw.Text('Mayera Fase Junction', style: pw.TextStyle(fontSize: 12)),
        pw.Text('0243596546/0556792084', style: pw.TextStyle(fontSize: 12)),
        pw.SizedBox(height: 10),
        pw.Container(
          padding: pw.EdgeInsets.symmetric(vertical: 8, horizontal: 15),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 1, color: PdfColors.grey400),
            borderRadius: pw.BorderRadius.circular(5),
          ),
          child: pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Customer:', style: pw.TextStyle(fontSize: 11)),
                  pw.Text(
                    customerName,
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Contact:', style: pw.TextStyle(fontSize: 11)),
                  pw.Text(customerContact, style: pw.TextStyle(fontSize: 11)),
                ],
              ),
              pw.SizedBox(height: 3),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Date:', style: pw.TextStyle(fontSize: 11)),
                  pw.Text(
                    DateFormat('dd/MM/yyyy HH:mm').format(saleDate),
                    style: pw.TextStyle(fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context) {
    return pw.Container(
      child: pw.Column(
        children: [
          pw.Divider(thickness: 0.5, color: PdfColors.grey400),
          pw.SizedBox(height: 10),
          pw.Text(
            'Goods sold are not returnable, thank you.',
            style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ],
      ),
    );
  }
}
