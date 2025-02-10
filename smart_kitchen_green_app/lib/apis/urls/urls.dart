class Urls {
  static String serverUrl = 'http://192.168.30.216:8000';

// AUTH APIS

  static String authUrl = '$serverUrl/api/accounts';

  static String registerUserUrl = '$authUrl/register/';

  static String signinUserUrl = '$authUrl/login/';

  static String verifyEmailUrl = '$authUrl/verify-email/';

// KICTHEN PRODUCTS

  static String kitchenProductUrl = '$serverUrl/api/kitchen/product/';

  // PLANT URLs

  static String recommended_plants = '$serverUrl/api/garden/location/';
}
