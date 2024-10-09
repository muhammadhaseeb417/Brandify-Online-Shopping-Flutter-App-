import 'package:brand_shoes/servics/auth_service.dart';
import 'package:brand_shoes/servics/database_services.dart';
import 'package:brand_shoes/servics/medai_service.dart';
import 'package:brand_shoes/servics/storage_servics.dart';
import 'package:get_it/get_it.dart';

Future<void> RegisterServics() async {
  final GetIt getit = GetIt.instance;

  getit.registerSingleton<AuthService>(
    AuthService(),
  );
  getit.registerSingleton<MediaService>(
    MediaService(),
  );
  getit.registerSingleton<StorageServics>(
    StorageServics(),
  );
  getit.registerSingleton<DatabaseServices>(
    DatabaseServices(),
  );
}
