import '../dao/product_type_dao.dart';
import '../models/product_type.dart';

class ProductTypeRepository {
  final _productTypeDao = ProductTypeDao();

  Future<int> createProductType(ProductType productType) =>
      _productTypeDao.createProductType(productType);

  Future<List<ProductType>> getProductTypes() =>
      _productTypeDao.getProductTypes();

  Future<ProductType?> getProductTypeById(int id) =>
      _productTypeDao.getProductTypeById(id);
}