import '../dao/product_type_dao.dart';
import '../models/product_type.dart';

class ProductTypeRepository {
  final ProductTypeDao productTypeDao = ProductTypeDao();

  Future<int> createProductType(ProductType productType) =>
      productTypeDao.createProductType(productType);

  Future<List<ProductType>> getProductTypes() =>
      productTypeDao.getProductTypes();

  Future<ProductType?> getProductTypeById(int id) =>
      productTypeDao.getProductTypeById(id);
}
