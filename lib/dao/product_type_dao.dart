import 'package:boh_tourbuch/databases/database.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite_sqlcipher/sqflite.dart';

import '../models/product_type.dart';

class ProductTypeDao {
  final _database = DatabaseInstance.databaseInstance;

  Future<int> createProductType(ProductType productType) async {
    final Database db = await _database.database;
    return db.insert(productTypeTable, toDatabaseJson(productType));
  }

  Future<List<ProductType>> getProductTypes() async {
    final db = await _database.database;
    List<Map<String, dynamic>> result = await db.query(productTypeTable);
    return result.map((e) => fromDatabaseJson(e)).toList();
  }

  Future<ProductType?> getProductTypeById(int id) async {
    final db = await _database.database;
    List<Map<String, dynamic>> result =
        await db.query(productTypeTable, where: 'id = ?', whereArgs: [id]);
    if (result.length == 1) {
      return fromDatabaseJson(result.first);
    } else {
      if (kDebugMode) {
        print("0 or more than 1 productTypes found for id $id");
      }
      return null;
    }
  }

  ProductType fromDatabaseJson(Map<String, dynamic> data) {
    return ProductType(
        id: data['id'],
        name: data['name'],
        materialIconIdentifier: data['material_icon_identifier']);
  }

  Map<String, dynamic> toDatabaseJson(ProductType productType) => {
        "id": productType.id == -1 ? null : productType.id,
        "name": productType.name,
        "material_icon_identifier": productType.materialIconIdentifier,
      };
}