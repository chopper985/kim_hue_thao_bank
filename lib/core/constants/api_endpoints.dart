class ApiEndpoints {
  static const String baseUrl =
      'http://gold-store-api-stage.runasp.net/api/v1/';

  // Auth
  static const String auth = 'auth';
  static const String login = 'auth/login';
  static const String refreshToken = 'refresh-token';

  // Gold
  static const String goldTypes = 'gold-types';
  static const String priceBoard = 'price-board';
  static const String goldPricesBatch = 'gold-prices/batch';
}
