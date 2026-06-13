import '../remote/datasources/family_remote_datasource.dart';

class FamilyRepository {
  final FamilyRemoteDataSource _dataSource = FamilyRemoteDataSource();

  Future<Map<String, dynamic>> createProfile(Map<String, dynamic> data) =>
      _dataSource.createProfile(data);

  Future<Map<String, dynamic>> getProfiles() => _dataSource.getProfiles();

  Future<Map<String, dynamic>> getProfile(String id) =>
      _dataSource.getProfile(id);

  Future<Map<String, dynamic>> updateProfile(
    String id,
    Map<String, dynamic> data,
  ) => _dataSource.updateProfile(id, data);

  Future<Map<String, dynamic>> deleteProfile(String id) =>
      _dataSource.deleteProfile(id);

  Future<Map<String, dynamic>> switchProfile(String id) =>
      _dataSource.switchProfile(id);
}
