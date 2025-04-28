import 'package:get/get.dart';
import 'connectivity_service.dart';

class SyncService extends GetxService {
  final ConnectivityService _connectivityService = Get.find();

  @override
  void onInit() {
    super.onInit();
    ever(_connectivityService.isOnline, (online) {
      if (online == true) {
        syncData();
      }
    });
  }

  Future<void> syncData() async {
    // TODO: Pull remote updates and push pending local updates
    print('Syncing data with cloud...');
  }
}