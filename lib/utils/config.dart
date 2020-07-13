import './models.dart';

class API {
  // change prod, url static in config, and uri.http in api.dart
  static const URL = "txo62iwuhe.execute-api.ap-south-1.amazonaws.com";
  static const ANALYTICS = "analytics";
  static const CATEGORY = "category";
  static const CUSTOMER = "customer";
  static const CUSTOMERAMOUNT = "customeramount";
  static const PRODUCT = "product";
  static const PRODUCTSTOCK = "productstock";
  static const SALE = "sale";
  static const SALEPRODUCT = "saleproduct";
  static const STORE = "store";
  static const USER = "user";
  static const SENDOTP = "sendotp";
  static const VERIFYOTP = "verifyotp";
  static const PROD = "prod/"; // prod/
}

class CONTACT {
  static const TERMS_URL = "https://sites.google.com/view/cloudpg-in/terms";
  static const PRIVACY_URL = "https://sites.google.com/view/cloudpg-in/privacy";
  static const ABOUT_URL = "http://cloudpg.in/about";
  static const SUPPORT_MAIL = "rahul.cloudpg@gmail.com";
}

String mediaURL = "https://pgworld.s3.ap-south-1.amazonaws.com/";

class APPVERSION {
  static const ANDROID = "1.0";
  static const IOS = "1.0";
}

class APIKEY {
  static const ANDROID_LIVE = "a2t3K5Y8e2W7Z5T2";
  static const ANDROID_TEST = "E8y6S5H5T4e9q7q7";
  static const IOS_LIVE = "b4E6U9K8j6b5E9W3";
  static const IOS_TEST = "R4n7N8G4m9B4S5n2";
}

class RAZORPAY {
  static const KEY = "rzp_live_dlraNHNbIJRuCy";
}

Map<String, String> headers = {
  "pkgname": "com.saikrishna.shopy",
  "Accept-Encoding": "gzip"
};

const timeout = 10;

const defaultLimit = "25";
const defaultOffset = "0";

// status
const STATUS_400 = "400";
const STATUS_403 = "403"; // forbidden
const STATUS_500 = "500";

List<Category> categories = new List();
Map<String, Category> categoriesMap = new Map();

Map<String, Product> products = new Map();
Map<String, Customer> customers = new Map();

Map<String, int> cart = new Map();

String username = "";
String userUID = "";
String storeUID = "";
String storeName = "";
String phone = "";

Map<String, List<String>> paymentTypes = {
  "1": ["Cash", "cash"],
  "2": ["Card", "card"],
  "3": ["Check", "check"],
  "4": ["Voucher", "voucher"],
  "5": ["Store Credit", "store_credit"],
  "6": ["Paytm", "paytm"],
  "7": ["Pay Later", "pay_later"],
  "8": ["Other", "other"],
};

bool canVibrate = true;
