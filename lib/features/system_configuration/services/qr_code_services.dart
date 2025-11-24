import 'dart:math' as math;

class QRCodeService {
  static String generateQRCodeData({
    required String tableId,
    required String restaurantId,
    required String tableNumber,
  }) {
    return 'restaurant://table/${Uri.encodeComponent(tableId)}?restaurant=${Uri.encodeComponent(restaurantId)}&table=${Uri.encodeComponent(tableNumber)}';
  }

  static String generateUniqueQRCodeValue() {
    return 'table_${DateTime.now().millisecondsSinceEpoch}_${generateRandomString(8)}';
  }

  static String generateRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = math.Random();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(random.nextInt(chars.length)),
      ),
    );
  }
}
