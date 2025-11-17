import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/data/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:iconsax/iconsax.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:html' as html;
import 'dart:math' as math;

// --- Data Models ---
class RestaurantTable {
  final String tableId;
  final String restaurantId;
  final String tableNumber;
  final int capacity;
  final TableStatus tableStatus;
  final String qrCode;
  final DateTime createdAt;

  RestaurantTable({
    required this.tableId,
    required this.restaurantId,
    required this.tableNumber,
    required this.capacity,
    required this.tableStatus,
    required this.qrCode,
    required this.createdAt,
  });

  // Convert to map for database operations
  Map<String, dynamic> toMap() {
    return {
      'id': tableId,
      'restaurant_id': restaurantId,
      'table_number': tableNumber,
      'capacity': capacity,
      'table_status': tableStatus.toString().split('.').last,
      'qr_code': qrCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}

enum TableStatus { available, occupied, reserved, cleaning, maintenance }

// --- QR Code Generation Service ---
class QRCodeService {
  static String generateQRCodeData({
    required String tableId,
    required String restaurantId,
    required String tableNumber,
  }) {
    // Generate a unique QR code data that can be used to identify the table
    final data = {
      'id': tableId,
      'restaurant_id': restaurantId,
      'table_number': tableNumber,
      'type': 'restaurant_table',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    };

    // Convert to JSON string for QR code
    return 'restaurant://table/${Uri.encodeComponent(tableId)}?restaurant=${Uri.encodeComponent(restaurantId)}&table=${Uri.encodeComponent(tableNumber)}';
  }

  static String generateUniqueQRCodeValue() {
    // Generate a unique string for the qr_code field in database
    return 'table ${DateTime.now().millisecondsSinceEpoch}_${_generateRandomString(8)}';
  }

  static String _generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = SystemRandom();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}

// --- Main QR Code Generation Screen ---
class GenerateQRCode extends StatefulWidget {
  final String restaurantId;

  const GenerateQRCode({super.key, required this.restaurantId});

  @override
  State<GenerateQRCode> createState() => _GenerateQRCodeState();
}

class _GenerateQRCodeState extends State<GenerateQRCode> {
  final _formKey = GlobalKey<FormState>();

  // Form Controllers
  final _tableNumberController = TextEditingController();
  final _capacityController = TextEditingController();

  // Form Values
  TableStatus _tableStatus = TableStatus.available;

  // Generated Data
  RestaurantTable? _generatedTable;
  bool _isGenerating = false;

  @override
  void dispose() {
    _tableNumberController.dispose();
    _capacityController.dispose();
    super.dispose();
  }

  Future<void> _generateTableAndQRCode() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isGenerating = true;
    });

    // Simulate API processing time
    await Future.delayed(const Duration(seconds: 1));

    try {
      // Generate unique IDs and QR code
      final tableId = const Uuid().v4();
      final qrCodeValue = QRCodeService.generateUniqueQRCodeValue();

      // Create the table object
      final newTable = RestaurantTable(
        tableId: tableId,
        restaurantId: '55c67be9-90c1-404c-a28b-8fac87dfb85c',
        tableNumber: _tableNumberController.text,
        capacity: int.parse(_capacityController.text),
        tableStatus: _tableStatus,
        qrCode: qrCodeValue,
        createdAt: DateTime.now(),
      );

      // Save to database
      await SupabaseService.saveRestaurantTable(newTable.toMap());

      setState(() {
        _generatedTable = newTable;
        _isGenerating = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Table created and QR code generated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      setState(() {
        _isGenerating = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error generating table: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _tableNumberController.clear();
    _capacityController.clear();
    _tableStatus = TableStatus.available;
    setState(() {
      _generatedTable = null;
    });
  }

  void _copyQRCodeData() {
    if (_generatedTable != null) {
      final qrData = QRCodeService.generateQRCodeData(
        tableId: _generatedTable!.tableId,
        restaurantId: _generatedTable!.restaurantId,
        tableNumber: _generatedTable!.tableNumber,
      );

      Clipboard.setData(ClipboardData(text: qrData));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('QR Code data copied to clipboard!')),
      );
    }
  }

  Future<void> _saveQRCodeAsImage() async {
    try {
      if (_generatedTable == null) return;
      
      final qrData = QRCodeService.generateQRCodeData(
        tableId: _generatedTable!.tableId,
        restaurantId: _generatedTable!.restaurantId,
        tableNumber: _generatedTable!.tableNumber,
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
      final fileName = 'QR_${_generatedTable!.tableNumber.replaceAll(' ', '_')}_${DateTime.now().millisecondsSinceEpoch}.png';
      
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', fileName)
        ..click();
      
      html.Url.revokeObjectUrl(url);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('QR Code downloaded!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving QR code: $e'),
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
          title: const Text('Generate Table QR Code'),
          actions: [
            if (_generatedTable != null)
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: _resetForm,
                tooltip: 'Create New Table',
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (_generatedTable == null)
                _buildTableCreationForm()
              else
                _buildQRCodeDisplay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableCreationForm() {
    return Container(
      color: DineSwiftColors.whiteColor,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildSectionHeader('Create New Table'),
              const SizedBox(height: 8),
              Text(
                'Fill in the table details to generate a unique QR code',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),

              // Table Number
              TextFormField(
                controller: _tableNumberController,
                decoration: const InputDecoration(
                  labelText: 'Table Number *',
                  hintText: 'e.g., Table 5, Booth 2, Patio 1',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.table_restaurant),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a table number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Capacity
              TextFormField(
                controller: _capacityController,
                decoration: const InputDecoration(
                  labelText: 'Capacity *',
                  hintText: 'e.g., 4',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.people),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter table capacity';
                  }
                  final capacity = int.tryParse(value);
                  if (capacity == null || capacity <= 0) {
                    return 'Please enter a valid capacity';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Table Status
              _buildTableStatusDropdown(),
              const SizedBox(height: 16),

              const SizedBox(height: 32),

              // Generate Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _isGenerating ? null : _generateTableAndQRCode,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  icon: _isGenerating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.qr_code_2),
                  label: Text(
                    _isGenerating ? 'Generating...' : 'Generate QR Code',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableStatusDropdown() {
    return DropdownButtonFormField<TableStatus>(
      value: _tableStatus,
      decoration: const InputDecoration(
        labelText: 'Table Status',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Iconsax.status_up),
      ),
      items: TableStatus.values.map((status) {
        return DropdownMenuItem<TableStatus>(
          value: status,
          child: Text(
            _formatTableStatus(status),
            style: TextStyle(color: _getStatusColor(status)),
          ),
        );
      }).toList(),
      onChanged: (TableStatus? newValue) {
        if (newValue != null) {
          setState(() {
            _tableStatus = newValue;
          });
        }
      },
    );
  }

  Widget _buildQRCodeDisplay() {
    final qrData = QRCodeService.generateQRCodeData(
      tableId: _generatedTable!.tableId,
      restaurantId: _generatedTable!.restaurantId,
      tableNumber: _generatedTable!.tableNumber,
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
                            'Table Created Successfully!',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.green[700],
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          Text(
                            'QR code has been generated for ${_generatedTable!.tableNumber}',
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
                      'Scan to Access ${_generatedTable!.tableNumber}',
                      style: Theme.of(context).textTheme.titleLarge,
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
                      _generatedTable!.tableNumber,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Capacity: ${_generatedTable!.capacity} people',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getStatusColor(
                          _generatedTable!.tableStatus,
                        ).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        _formatTableStatus(_generatedTable!.tableStatus),
                        style: TextStyle(
                          color: _getStatusColor(_generatedTable!.tableStatus),
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
                    onPressed: _copyQRCodeData,
                    icon: const Icon(Icons.copy),
                    label: const Text('Copy Data'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveQRCodeAsImage,
                    icon: const Icon(Icons.download),
                    label: const Text('Save QR Code'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _resetForm,
                icon: const Icon(Icons.add),
                label: const Text('Create Another Table'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  String _formatTableStatus(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return 'Available';
      case TableStatus.occupied:
        return 'Occupied';
      case TableStatus.reserved:
        return 'Reserved';
      case TableStatus.cleaning:
        return 'Cleaning';
      case TableStatus.maintenance:
        return 'Maintenance';
    }
  }

  Color _getStatusColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green;
      case TableStatus.occupied:
        return Colors.red;
      case TableStatus.reserved:
        return Colors.orange;
      case TableStatus.cleaning:
        return Colors.blue;
      case TableStatus.maintenance:
        return Colors.grey;
    }
  }
}

// --- SystemRandom for random string generation ---
class SystemRandom {
  final _random = Random();

  int nextInt(int max) => _random.nextInt(max);
}

class Random {
  final _random = math.Random();

  int nextInt(int max) => _random.nextInt(max);
}
