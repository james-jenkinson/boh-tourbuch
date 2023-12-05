import 'package:boh_tourbuch/models/product_order.dart';
import 'package:boh_tourbuch/repository/person_repository.dart';
import 'package:flutter_test/flutter_test.dart';

final d0 = DateTime.now();
final d1 = d0.add(const Duration(days: 1));
final p0 = ProductOrder(
  personId: 1,
  productTypeId: 2,
  status: OrderStatus.notOrdered,
  lastIssueDate: d0,
);
final p1 = ProductOrder(
  personId: 1,
  productTypeId: 2,
  status: OrderStatus.notOrdered,
  lastIssueDate: d1,
);
const pNull = ProductOrder(
  personId: 1,
  productTypeId: 2,
  status: OrderStatus.notOrdered,
  lastIssueDate: null,
);

void main() {
  // fixme: add tests for merging, but for this we have to implement dependency injection
  group('person repository', () {
    test('minBy', () {
      expect(
          minBy(p1, p0)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p0);

      expect(
          minBy(p0, p1)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p0);

      expect(
          minBy(pNull, p1)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p1);
      expect(
          minBy(p1, pNull)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p1);
    });

    test('maxBy', () {
      expect(
          maxBy(p1, p0)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p1);

      expect(
          maxBy(p0, p1)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p1);

      expect(
          maxBy(pNull, p1)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p1);
      expect(
          maxBy(p1, pNull)(
            (a) => a.lastIssueDate,
            (b) => b.lastIssueDate,
          ),
          p1);
    });
  });
}
