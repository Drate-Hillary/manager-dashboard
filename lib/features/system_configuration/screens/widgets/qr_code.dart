import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/data/supabase_service.dart';
import 'package:dineswift_management/features/system_configuration/services/qr_code_services.dart';
import 'package:dineswift_management/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:html' as html;
import 'package:dineswift_management/features/system_configuration/models/restaurant_table.dart';

// --- Main QR Code Generation Screen ---
class GenerateQRCode extends StatefulWidget {
  final String restaurantId;

  const GenerateQRCode({super.key, required this.restaurantId});

  @override
  State<GenerateQRCode> createState() => GenerateQRCodeState();
}

class GenerateQRCodeState extends State<GenerateQRCode> {
  final formKey = GlobalKey<FormState>();

  // Form Controllers
  final tableNumberController = TextEditingController();
  final capacityController = TextEditingController();

  // Form Values
  TableStatus tableStatus = TableStatus.available;

  // Generated Data
  RestaurantTable? generatedTable;
  bool isGenerating = false;

  @override
  void dispose() {
    tableNumberController.dispose();
    capacityController.dispose();
    super.dispose();
  }

  Future<void> generateTableAndQRCode() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isGenerating = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    try {
      final tableId = const Uuid().v4();
      final qrCodeValue = QRCodeService.generateUniqueQRCodeValue();

      final newTable = RestaurantTable(
        tableId: tableId,
        restaurantId: '55c67be9-90c1-404c-a28b-8fac87dfb85c',
        tableNumber: tableNumberController.text,
        capacity: int.parse(capacityController.text),
        tableStatus: tableStatus,
        qrCode: qrCodeValue,
        createdAt: DateTime.now(),
      );

      await SupabaseService.saveRestaurantTable(newTable.toMap());
      setState(() {
        generatedTable = newTable;
        isGenerating = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            DineSwiftTextStrings.tableCreatedSuccess,
            style: TextStyle(
              color: DineSwiftColors.successColor,
            ),
          ),
          backgroundColor: DineSwiftColors.lightSuccessColor,
        ),
      );
    } catch (e) {
      setState(() {
        isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${DineSwiftTextStrings.errorGeneratingTable}$e',
            style: const TextStyle(
              color: DineSwiftColors.whiteColor,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void resetForm() {
    formKey.currentState?.reset();
    tableNumberController.clear();
    capacityController.clear();
    tableStatus = TableStatus.available;
    setState(() {
      generatedTable = null;
    });
  }

  void copyQRCodeData() {
    if (generatedTable != null) {
      final qrData = QRCodeService.generateQRCodeData(
        tableId: generatedTable!.tableId,
        restaurantId: generatedTable!.restaurantId,
        tableNumber: generatedTable!.tableNumber,
      );

      Clipboard.setData(ClipboardData(text: qrData));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(
          DineSwiftTextStrings.qrCodeDataCopied,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        )),
      );
    }
  }

  Future<void> saveQRCodeAsImage() async {
    try {
      if (generatedTable == null) return;
      
      final qrData = QRCodeService.generateQRCodeData(
        tableId: generatedTable!.tableId,
        restaurantId: generatedTable!.restaurantId,
        tableNumber: generatedTable!.tableNumber,
      );
      
      // Create QR code painter
      final qrPainter = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: false,
        color: Colors.black,
        emptyColor: Colors.white,
      );
      
      // Convert to image
      final picData = await qrPainter.toImageData(512);
      final pngBytes = picData!.buffer.asUint8List();
      
      // Create download for web
      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final fileName = 'QR_${generatedTable!.tableNumber.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      
      final anchor = html.AnchorElement(href: url)
        ..setAttribute(DineSwiftTextStrings.downloadQRCode, fileName)
        ..click();
      
      html.Url.revokeObjectUrl(url);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(DineSwiftTextStrings.qrCodeDownloaded),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${DineSwiftTextStrings.errorSavingQRCode}$e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 600,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: DineSwiftColors.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            DineSwiftTextStrings.generateQRCodeTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          actions: [
            if (generatedTable != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: resetForm,
                tooltip: DineSwiftTextStrings.createNewTable,
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (generatedTable == null)
                buildTableCreationForm()
              else
                buildQRCodeDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTableCreationForm() {
    return Container(
      color: DineSwiftColors.whiteColor,
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              buildSectionHeader(
                DineSwiftTextStrings.createNewTable,
              ),
              const SizedBox(height: 8),
              Text(
                DineSwiftTextStrings.tableCreationDescription,
                style: TextStyle(
                  fontSize: 14,
                  color: DineSwiftColors.darkGrey,
                ),
              ),
              const SizedBox(height: 24),

              // Table Number
              TextFormField(
                controller: tableNumberController,
                decoration: const InputDecoration(
                  labelText: DineSwiftTextStrings.tableNumberLabel,
                  hintText: DineSwiftTextStrings.tableNumberHint,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.table_restaurant),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return DineSwiftTextStrings.pleaseEnterTableNumber;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Capacity
              TextFormField(
                controller: capacityController,
                decoration: const InputDecoration(
                  labelText: DineSwiftTextStrings.capacityLabel,
                  hintText: DineSwiftTextStrings.capacityHint,
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return DineSwiftTextStrings.pleaseEnterCapacity;
                  }
                  final capacity = int.tryParse(value);
                  if (capacity == null || capacity <= 0) {
                    return DineSwiftTextStrings.pleaseEnterValidCapacity;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Table Status
              buildTableStatusDropdown(),
              const SizedBox(height: 16),

              const SizedBox(height: 32),

              // Generate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: isGenerating ? null : generateTableAndQRCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.qr_code_2),
                  label: Text(
                    isGenerating ? DineSwiftTextStrings.generating : DineSwiftTextStrings.generateQRCodeButton,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTableStatusDropdown() {
    return DropdownButtonFormField<TableStatus>(
      value: tableStatus,
      decoration: const InputDecoration(
        labelText: DineSwiftTextStrings.tableStatusLabel,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Iconsax.status_up),
      ),
      items: TableStatus.values.map((status) {
        return DropdownMenuItem<TableStatus>(
          value: status,
          child: Text(
            DineSwiftTextStrings.formatTableStatus(status),
            style: TextStyle(color: getStatusColor(status)),
          ),
        );
      }).toList(),
      onChanged: (TableStatus? newValue) {
        if (newValue != null) {
          setState(() {
            tableStatus = newValue;
          });
        }
      },
    );
  }

  Widget buildQRCodeDisplay() {
    final qrData = QRCodeService.generateQRCodeData(
      tableId: generatedTable!.tableId,
      restaurantId: generatedTable!.restaurantId,
      tableNumber: generatedTable!.tableNumber,
    );

    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Success Message
            Card(
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DineSwiftTextStrings.tableCreatedSuccess,
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${DineSwiftTextStrings.qrGeneratedFor} ${generatedTable!.tableNumber}',
                            style: TextStyle(color: Colors.green[700]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // QR Code Display
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      '${DineSwiftTextStrings.scanToAccess} ${generatedTable!.tableNumber}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: QrImageView(
                        data: qrData,
                        version: QrVersions.auto,
                        size: 200,
                        backgroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      generatedTable!.tableNumber,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${DineSwiftTextStrings.capacity} ${generatedTable!.capacity} ${DineSwiftTextStrings.people}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: getStatusColor(
                          generatedTable!.tableStatus,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        DineSwiftTextStrings.formatTableStatus(generatedTable!.tableStatus),
                        style: TextStyle(
                          color: getStatusColor(generatedTable!.tableStatus),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: copyQRCodeData,
                    icon: const Icon(Iconsax.copy),
                    label: const Text(
                      DineSwiftTextStrings.copyData,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: saveQRCodeAsImage,
                    icon: const Icon(Iconsax.document_download),
                    label: const Text(
                      DineSwiftTextStrings.saveQRCode,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: resetForm,
                icon: const Icon(Icons.add),
                label: const Text(
                  DineSwiftTextStrings.createAnotherTable,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }
}
