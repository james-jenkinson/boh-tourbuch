import 'package:boh_tourbuch/dao/orders_dao.dart';

import '../models/order.dart';

class OrderRepository {
  final _orderDao = OrdersDao();

  Future<int> createOrder(Order order) => _orderDao.createOrder(order);

  Future<List<Order>> getOrdersByPersonId(int personId) =>
      _orderDao.getOrdersByPersonId(personId);

  Future<Iterable<Order>> getAllOrdersWithComment(bool commentDone) =>
      _orderDao.getAllOrdersWithComment(commentDone);
}
