import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_store/datas/product_data.dart';

class CartProduct {
  String cartId;
  String category;
  String pid;
  String size;
  int qty;
  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot doc) {
    cartId = doc.documentID;
    category = doc.data['category'];
    pid = doc.data['pid'];
    qty = doc.data['qty'];
    size = doc.data['size'];
  }

  Map<String, dynamic> toMap() {
    return {
      'category': category,
      'pid': pid,
      'qty': qty,
      'size': size,
      'product': productData.toResumedMap(),
    };
  }
}
