import 'package:boh_tourbuch/dao/product_dao.dart';

import '../models/product.dart';

class ProductRepository {
  final ProductDao productDao = ProductDao();

  Future<int> createProduct(Product product) =>
      productDao.createProduct(product);

  Future<List<Product>> getProductsByOrderId(int id) =>
      productDao.getProductsByOrderId(id);
}
