import 'package:boh_tourbuch/dao/orders_dao.dart';

import '../models/order.dart';

class OrderRepository {
  final orderDao = OrdersDao();

  Future<int> createOrder(Order order) => orderDao.createOrder(order);

  Future<List<Order>> getOrdersByPersonId(int personId) =>
      orderDao.getOrdersByPersonId(personId);
}
