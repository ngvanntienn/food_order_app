class PaymentQr {
  // Example bankId values: MB, VCB, TCB, ACB, BIDV...
  static const String bankId = '';
  static const String accountNo = '';
  static const String accountName = '';
  static const String template = 'compact2';

  static bool get isConfigured =>
      bankId.trim().isNotEmpty && accountNo.trim().isNotEmpty;

  static String buildQrImageUrl({
    required int amount,
    required String orderCode,
  }) {
    if (!isConfigured) {
      return '';
    }

    final String addInfo = Uri.encodeComponent('THANH TOAN DON $orderCode');
    final String encodedAccountName = Uri.encodeComponent(accountName);

    return '';
  }
}
