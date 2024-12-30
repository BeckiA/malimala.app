class AppConfiguration {
  static const String appName = "Waloma";
  // static const String apiURL = "backend-api.malimala.org";
  static const String apiURL = "172.16.8.224:3030"; //Zemen
  // static const String apiURL = "10.2.0.2:3030"; //VPN
  // static const String apiURL = "192.168.0.101:3030"; //Safari
  // static const String apiURL = "192.168.193.6:3030"; //Mobile
  // static const String apiURL = "index.malimala.org";
  static const loginAPI = "/api/auth/login";
  static const registerAPI = "/api/auth/register";
  static const sendOtpAPI = "/api/auth/send-otp";
  static const verifyOtpAPI = "/api/auth/verify-otp";
  static const resetPassword = "api/auth/reset-password";
  static const userDetailsAPI = "/api/users/";
  static const listingsAPI = "/api/listings";
  static const createListings = "/api/listings";
  static const chatUsersAPI = "/api/messages";
}
