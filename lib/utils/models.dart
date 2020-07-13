// post

class Meta {
  final String status;
  final String message;
  final String messageType;

  Meta({this.status, this.message, this.messageType});

  factory Meta.fromJson(Map<String, dynamic> json) {
    return Meta(
      status: json['status'],
      message: json['message'],
      messageType: json['message_type'],
    );
  }
}

class Pagination {
  final String count;
  final String offset;
  final String totalCount;

  Pagination({this.count, this.offset, this.totalCount});

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      count: json['count'],
      offset: json['offset'],
      totalCount: json['total_count'],
    );
  }
}

// post

class Post {
  final String id;
  final Meta meta;

  Post({this.id, this.meta});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      meta: Meta.fromJson(json['meta']),
    );
  }
}

// realtime

class RealTime {
  final Product product;
  final Customer customer;

  RealTime({this.product, this.customer});

  factory RealTime.fromJson(Map<String, dynamic> json) {
    return RealTime(
      product:
          json['product'] != null ? Product.fromJson(json['product']) : null,
      customer:
          json['customer'] != null ? Customer.fromJson(json['customer']) : null,
    );
  }
}

// category

class Categories {
  final List<Category> categories;
  final Meta meta;
  final Pagination pagination;

  Categories({this.categories, this.meta, this.pagination});

  factory Categories.fromJson(Map<String, dynamic> json) {
    return Categories(
      categories: json['data'] != null
          ? List<Category>.from(json['data'].map((i) => Category.fromJson(i)))
          : new List<Category>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Category {
  final String id;
  final String categoryUID;
  String name;
  final String storeUID;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Category(
      {this.id,
      this.categoryUID,
      this.name,
      this.storeUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      categoryUID: json['category_u_id'],
      name: json['name'],
      storeUID: json['store_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// customer

class Customers {
  final List<Customer> customers;
  final Meta meta;
  final Pagination pagination;

  Customers({this.customers, this.meta, this.pagination});

  factory Customers.fromJson(Map<String, dynamic> json) {
    return Customers(
      customers: json['data'] != null
          ? List<Customer>.from(json['data'].map((i) => Customer.fromJson(i)))
          : new List<Customer>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Customer {
  final String id;
  final String customerUID;
  String name;
  String phone;
  String email;
  String amount;
  String address;
  final String storeUID;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Customer(
      {this.id,
      this.customerUID,
      this.name,
      this.phone,
      this.email,
      this.amount,
      this.address,
      this.storeUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      id: json['id'],
      customerUID: json['customer_u_id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      amount: json['amount'],
      address: json['address'],
      storeUID: json['store_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// customer amount

class CustomerAmounts implements ListItem {
  final List<CustomerAmount> customerAmounts;
  final Meta meta;
  final Pagination pagination;

  CustomerAmounts({this.customerAmounts, this.meta, this.pagination});

  factory CustomerAmounts.fromJson(Map<String, dynamic> json) {
    return CustomerAmounts(
      customerAmounts: json['data'] != null
          ? List<CustomerAmount>.from(
              json['data'].map((i) => CustomerAmount.fromJson(i)))
          : new List<CustomerAmount>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class CustomerAmount implements ListItem {
  final String id;
  final String customerUID;
  final String amount;
  final String type;
  final String storeUID;
  final String saleUID;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  CustomerAmount(
      {this.id,
      this.customerUID,
      this.amount,
      this.type,
      this.storeUID,
      this.saleUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory CustomerAmount.fromJson(Map<String, dynamic> json) {
    return CustomerAmount(
      id: json['id'],
      customerUID: json['customer_u_id'],
      amount: json['amount'],
      type: json['type'],
      storeUID: json['store_u_id'],
      saleUID: json['sale_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// product

class Products {
  final List<Product> products;
  final Meta meta;
  final Pagination pagination;

  Products({this.products, this.meta, this.pagination});

  factory Products.fromJson(Map<String, dynamic> json) {
    return Products(
      products: json['data'] != null
          ? List<Product>.from(json['data'].map((i) => Product.fromJson(i)))
          : new List<Product>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

// whenever you add or remove in product model, do it in product activity where product is being edited
class Product implements ListItem {
  final String id;
  final String productUID;
  String name;
  String categoryUID;
  String description;
  String stock;
  String minimumStock;
  String track;
  String cost;
  String price;
  String sale;
  String code;
  final String storeUID;
  String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Product(
      {this.id,
      this.productUID,
      this.name,
      this.categoryUID,
      this.description,
      this.stock,
      this.minimumStock,
      this.track,
      this.cost,
      this.price,
      this.sale,
      this.code,
      this.storeUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      productUID: json['product_u_id'],
      name: json['name'],
      categoryUID: json['category_u_id'],
      description: json['description'],
      stock: json['stock'],
      minimumStock: json['minimum_stock'],
      track: json['track'],
      cost: json['cost'],
      price: json['price'],
      sale: json['sale'],
      code: json['code'],
      storeUID: json['store_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// product stock

class ProductStocks {
  final List<ProductStock> productStocks;
  final Meta meta;
  final Pagination pagination;

  ProductStocks({this.productStocks, this.meta, this.pagination});

  factory ProductStocks.fromJson(Map<String, dynamic> json) {
    return ProductStocks(
      productStocks: json['data'] != null
          ? List<ProductStock>.from(
              json['data'].map((i) => ProductStock.fromJson(i)))
          : new List<ProductStock>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class ProductStock implements ListItem {
  final String id;
  final String productUID;
  final String quantity;
  final String type;
  final String total;
  final String storeUID;
  final String saleUID;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  ProductStock(
      {this.id,
      this.productUID,
      this.quantity,
      this.type,
      this.total,
      this.storeUID,
      this.saleUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory ProductStock.fromJson(Map<String, dynamic> json) {
    return ProductStock(
      id: json['id'],
      productUID: json['product_u_id'],
      quantity: json['quantity'],
      type: json['type'],
      total: json['total'],
      storeUID: json['store_u_id'],
      saleUID: json['sale_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// sale

class Sales {
  final List<Sale> sales;
  final Meta meta;
  final Pagination pagination;

  Sales({this.sales, this.meta, this.pagination});

  factory Sales.fromJson(Map<String, dynamic> json) {
    return Sales(
      sales: json['data'] != null
          ? List<Sale>.from(json['data'].map((i) => Sale.fromJson(i)))
          : new List<Sale>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

abstract class ListItem {}

class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);
}

class Sale implements ListItem {
  final String id;
  final String saleUID;
  final String customerUID;
  final String name;
  final String phone;
  final String subtotal;
  final String discount;
  final String percentage;
  final String total;
  final String cash;
  final String card;
  final String check;
  final String voucher;
  final String storeCredit;
  final String paytm;
  final String payLater;
  final String other;
  final String change;
  final String note;
  final String storeUID;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Sale(
      {this.id,
      this.saleUID,
      this.customerUID,
      this.name,
      this.phone,
      this.subtotal,
      this.discount,
      this.percentage,
      this.total,
      this.cash,
      this.card,
      this.check,
      this.voucher,
      this.storeCredit,
      this.paytm,
      this.payLater,
      this.other,
      this.change,
      this.note,
      this.storeUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Sale.fromJson(Map<String, dynamic> json) {
    return Sale(
      id: json['id'],
      saleUID: json['sale_u_id'],
      customerUID: json['customer_u_id'],
      name: json['name'],
      phone: json['phone'],
      subtotal: json['subtotal'],
      discount: json['discount'],
      percentage: json['percentage'],
      total: json['total'],
      cash: json['cash'],
      card: json['card'],
      check: json['check'],
      voucher: json['voucher'],
      storeCredit: json['store_credit'],
      paytm: json['paytm'],
      payLater: json['pay_later'],
      other: json['other'],
      change: json['change'],
      note: json['note'],
      storeUID: json['store_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// saleproduct

class SaleProducts {
  final List<SaleProduct> saleProducts;
  final Meta meta;
  final Pagination pagination;

  SaleProducts({this.saleProducts, this.meta, this.pagination});

  factory SaleProducts.fromJson(Map<String, dynamic> json) {
    return SaleProducts(
      saleProducts: json['data'] != null
          ? List<SaleProduct>.from(
              json['data'].map((i) => SaleProduct.fromJson(i)))
          : new List<SaleProduct>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class SaleProduct {
  final String id;
  final String saleUID;
  final String productUID;
  final String name;
  final String quantity;
  final String cost;
  final String price;
  final String sale;
  final String code;
  final String storeUID;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  SaleProduct(
      {this.id,
      this.saleUID,
      this.productUID,
      this.name,
      this.quantity,
      this.cost,
      this.price,
      this.sale,
      this.code,
      this.storeUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory SaleProduct.fromJson(Map<String, dynamic> json) {
    return SaleProduct(
      id: json['id'],
      saleUID: json["sale_u_id"],
      productUID: json['product_u_id'],
      name: json['name'],
      quantity: json['quantity'],
      cost: json['cost'],
      price: json['price'],
      sale: json['sale'],
      code: json['code'],
      storeUID: json['store_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// store

class Stores {
  final List<Store> stores;
  final Meta meta;
  final Pagination pagination;

  Stores({this.stores, this.meta, this.pagination});

  factory Stores.fromJson(Map<String, dynamic> json) {
    return Stores(
      stores: json['data'] != null
          ? List<Store>.from(json['data'].map((i) => Store.fromJson(i)))
          : new List<Store>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class Store {
  final String id;
  final String storeUID;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  Store(
      {this.id,
      this.storeUID,
      this.name,
      this.email,
      this.phone,
      this.address,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      storeUID: json['store_u_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// user

class Users {
  final List<User> users;
  final Meta meta;
  final Pagination pagination;

  Users({this.users, this.meta, this.pagination});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
      users: json['data'] != null
          ? List<User>.from(json['data'].map((i) => User.fromJson(i)))
          : new List<User>(),
      meta: Meta.fromJson(json['meta']),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }
}

class User {
  final String id;
  final String userUID;
  final String username;
  final String storeUID;
  final String status;
  final String createdBy;
  final String modifiedBy;
  final String createdDateTime;
  final String modifiedDateTime;

  User(
      {this.id,
      this.userUID,
      this.username,
      this.storeUID,
      this.status,
      this.createdBy,
      this.modifiedBy,
      this.createdDateTime,
      this.modifiedDateTime});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      userUID: json['user_u_id'],
      username: json['username'],
      storeUID: json['store_u_id'],
      status: json['status'],
      createdBy: json['created_by'],
      modifiedBy: json['modified_by'],
      createdDateTime: json['created_date_time'],
      modifiedDateTime: json['modified_date_time'],
    );
  }
}

// analytics
class Analytics {
  final List<Graph> graphs;
  final Meta meta;

  Analytics({this.graphs, this.meta});

  factory Analytics.fromJson(Map<String, dynamic> json) {
    return Analytics(
      graphs: json['graphs'] != null
          ? List<Graph>.from(json['graphs'].map((i) => Graph.fromJson(i)))
          : new List<Graph>(),
      meta: Meta.fromJson(json['meta']),
    );
  }
}

class Graph {
  final String title;
  final String color;
  final String dataTitle;
  final String type;
  final String horizontal;
  final String steps;
  final List<ChartType> data;

  Graph(
      {this.title,
      this.color,
      this.dataTitle,
      this.type,
      this.horizontal,
      this.steps,
      this.data});

  factory Graph.fromJson(Map<String, dynamic> json) {
    return Graph(
      title: json['title'],
      color: json['color'],
      dataTitle: json['data_title'],
      type: json['type'],
      horizontal: json['horizontal'],
      steps: json['steps'],
      data: json['data'] != null
          ? List<ChartType>.from(json['data'].map((i) => ChartType.fromJson(i)))
          : new List<ChartType>(),
    );
  }
}

class ChartType {
  final String title;
  final String color;
  final List<ChartData> data;

  ChartType({this.title, this.color, this.data});

  factory ChartType.fromJson(Map<String, dynamic> json) {
    return ChartType(
      title: json['title'],
      color: json['color'],
      data: json['data'] != null
          ? List<ChartData>.from(json['data'].map((i) => ChartData.fromJson(i)))
          : new List<ChartData>(),
    );
  }
}

class ChartData {
  String title;
  String value;
  String color;
  String shown;

  ChartData({
    this.title,
    this.value,
    this.color,
    this.shown,
  });

  factory ChartData.fromJson(Map<String, dynamic> json) => new ChartData(
        title: json["title"],
        value: json["value"],
        color: json["color"],
        shown: json["shown"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "value": value,
        "color": color,
        "shown": shown,
      };
}

/// Sample ordinal data type.
class OrdinalSales {
  final String year;
  final int sales;
  final String color;

  OrdinalSales(this.year, this.sales, this.color);
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;
  final String color;

  TimeSeriesSales(this.time, this.sales, this.color);
}
