import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:http/http.dart' as http;

import './models.dart';
import './config.dart';

// analytics

Future<Analytics> getAnalytics(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.ANALYTICS, query),
            headers: headers)
        .timeout(Duration(seconds: timeout));

    return Analytics.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// category

Future<Categories> getCategories(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  query["status"] = "1";
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.CATEGORY, query),
            headers: headers)
        .timeout(Duration(seconds: timeout));

    return Categories.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// customer

Future<Customers> getCustomers(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  query["status"] = "1";
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.CUSTOMER, query),
            headers: headers)
        .timeout(Duration(seconds: timeout));

    return Customers.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// customer amount

Future<CustomerAmounts> getCustomerAmounts(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  query["status"] = "1";
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.CUSTOMERAMOUNT, query),
            headers: headers)
        .timeout(Duration(seconds: timeout));

    return CustomerAmounts.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// product

Future<Products> getProducts(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  query["status"] = "1";
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.PRODUCT, query), headers: headers)
        .timeout(Duration(seconds: timeout));

    return Products.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// product stock

Future<ProductStocks> getProductStocks(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  query["status"] = "1";
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.PRODUCTSTOCK, query),
            headers: headers)
        .timeout(Duration(seconds: timeout));

    return ProductStocks.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// sale

Future<Sales> getSales(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.SALE, query), headers: headers)
        .timeout(Duration(seconds: timeout));

    return Sales.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// sale products

Future<SaleProducts> getSaleProducts(Map<String, String> query) async {
  query["store_u_id"] = storeUID;
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.SALEPRODUCT, query),
            headers: headers)
        .timeout(Duration(seconds: timeout));

    return SaleProducts.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// store

Future<Stores> getStores(Map<String, String> query) async {
  query["status"] = "1";
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.STORE, query), headers: headers)
        .timeout(Duration(seconds: timeout));

    return Stores.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// user

Future<Users> getUsers(Map<String, String> query) async {
  query["status"] = "1";
  try {
    final response = await http
        .get(Uri.https(API.URL, API.PROD + API.USER, query), headers: headers)
        .timeout(Duration(seconds: timeout));

    return Users.fromJson(json.decode(response.body));
  } catch (e) {
    return null;
  }
}

// add and update
Future<bool> add(String endpoint, Map<String, String> body) async {
  if (body["status"] != null) {
    body["status"] = "1";
  }
  var request = new http.MultipartRequest(
    "POST",
    Uri.https(
      API.URL,
      API.PROD + endpoint,
    ),
  )..fields.addAll(body);
  request.headers.addAll(headers);
  print(body);
  try {
    var response = await request.send();
    String responseData = await response.stream.transform(utf8.decoder).join();
    print(responseData);
    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    }
    return false;
  } catch (e) {
    return null;
  }
}

Future<bool> update(String endpoint, Map<String, String> body,
    Map<String, String> query) async {
  var request = new http.MultipartRequest(
    "PUT",
    Uri.https(API.URL, API.PROD + endpoint, query),
  )..fields.addAll(body);
  request.headers.addAll(headers);

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  } catch (e) {
    return null;
  }
}

Future<bool> delete(String endpoint, Map<String, String> query) async {
  var request = new http.MultipartRequest(
    "DELETE",
    Uri.https(API.URL, API.PROD + endpoint, query),
  );

  request.headers.addAll(headers);

  try {
    var response = await request.send();
    if (response.statusCode == 200) {
      return true;
    }
    return false;
  } catch (e) {
    return null;
  }
}

Future<String> upload(File file) async {
  var request = new http.MultipartRequest(
    "POST",
    Uri.https(
      API.URL,
      API.PROD + "upload",
    ),
  );
  request.headers.addAll(headers);

  var stream = new http.ByteStream(Stream.castFrom(file.openRead()));
  // get file length
  var length = await file.length();
  // multipart that takes file
  var multipartFile = new http.MultipartFile('photo', stream, length,
      filename: basename(file.path));

  // add file to multipart
  request.files.add(multipartFile);

  try {
    var response = await request.send();

    if (response.statusCode == 200) {
      String responseData =
          await response.stream.transform(utf8.decoder).join();
      Map data = json.decode(responseData);
      if (data["data"] != null) {
        return data["data"][0]["image"];
      }
    }
    return "";
  } catch (e) {
    return null;
  }
}
