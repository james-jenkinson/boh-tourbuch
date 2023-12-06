import '../dao/product_order_dao.dart';
import '../models/product_order.dart';

class ProductOrderRepository {
  final _productOrderDao = ProductOrderDao();

  Future<int> createProductOrder(ProductOrder productOrder) =>
      _productOrderDao.createProductOrder(productOrder);

  Future<int> updateProductOrder(ProductOrder productOrder) =>
      _productOrderDao.updateProductOrder(productOrder);

  Future<List<ProductOrder>> getProductOrdersByPersonId(int id) =>
      _productOrderDao.getProductOrdersByPersonId(id);

  Future<int> deleteProductOrdersByPersonId(int personId) =>
      _productOrderDao.deleteProductOrdersByPersonId(personId);

  Future<int> deleteProductOrdersByProductTypeId(int productTypeId) =>
      _productOrderDao.deleteProductOrdersByProductTypeId(productTypeId);

  Future<List<ProductOrder>> getAllByStatusAndType(
          OrderStatus status, List<int> productTypeIds) =>
      _productOrderDao.getAllByStatusAndType(status, productTypeIds);

  Future<void> delete(ProductOrder productOrder) =>
      _productOrderDao.delete(productOrder);
}
