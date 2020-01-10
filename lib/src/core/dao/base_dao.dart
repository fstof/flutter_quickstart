import 'package:json_store/json_store.dart';
import 'package:meta/meta.dart';

abstract class BaseDao {
  final JsonStore _storage;

  BaseDao({@required JsonStore storage}) : this._storage = storage;

  Future<void> saveData(String key, Map<String, dynamic> data) async {
    await _storage.setItem(key, data, encrypt: true);
    await _storage.setItem(
      '$key-lastUpdated',
      {'value': DateTime.now().millisecondsSinceEpoch},
      encrypt: true,
    );
  }

  Future<DataItem> getData<T>(String key) async {
    Map<String, dynamic> data = await _storage.getItem(key);
    Map<String, dynamic> lastUpdated =
        await _storage.getItem('$key-lastUpdated');

    return DataItem(
      key: key,
      lastUpdated: DateTime.fromMillisecondsSinceEpoch(lastUpdated['value']),
      data: data,
    );
  }

  Future<void> deleteData<T>(String key) async {
    await _storage.deleteItem(key);
    await _storage.deleteItem('$key-lastUpdated');
  }
}

class DataItem {
  final String key;
  final DateTime lastUpdated;
  final Map<String, dynamic> data;

  DataItem({this.key, this.lastUpdated, this.data});
}
