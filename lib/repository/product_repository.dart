import 'package:boh_tourbuch/dao/product_dao.dart';

import '../models/product.dart';

class ProductRepository {
  final _productDao = ProductDao();

  Future<int> createProduct(Product product) =>
      _productDao.createProduct(product);

  Future<List<Product>> getProductsByOrderId(int id) =>
      _productDao.getProductsByOrderId(id);
}
