import '../remote/datasources/medicine_remote_datasource.dart';

class MedicineRepository {
  final MedicineRemoteDataSource _dataSource = MedicineRemoteDataSource();

  Future<Map<String, dynamic>> createMedicine(Map<String, dynamic> data) =>
      _dataSource.createMedicine(data);

  Future<Map<String, dynamic>> getMedicines() => _dataSource.getMedicines();

  Future<Map<String, dynamic>> getTodaysMedicines() =>
      _dataSource.getTodaysMedicines();

  Future<Map<String, dynamic>> getAdherence() => _dataSource.getAdherence();

  Future<Map<String, dynamic>> updateMedicine(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.updateMedicine(id, data);

  Future<Map<String, dynamic>> deleteMedicine(String id) =>
      _dataSource.deleteMedicine(id);

  Future<Map<String, dynamic>> logMedicine(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.logMedicine(id, data);

  Future<Map<String, dynamic>> getMedicineLogs(String id) =>
      _dataSource.getMedicineLogs(id);
}
