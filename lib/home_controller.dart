import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:app_usage/app_usage.dart';
import 'package:launcher/utils/usage_helper.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  var apps = <AppInfo>[].obs;
  var filteredApps = <AppInfo>[].obs;
  var showAppList = false.obs;
  var searchQuery = ''.obs;
  var topApps = <AppUsageInfo>[].obs;

  Future loadApp() async {
    isLoading.value = true;
    List<AppInfo> installedApps = await InstalledApps.getInstalledApps(
      excludeNonLaunchableApps: true,
      excludeSystemApps: false,
    );
    installedApps.sort((a, b) => a.name.compareTo(b.name));
    apps.value = installedApps;
    filteredApps.value = installedApps;
    isLoading.value = false;
  }

  void launchApp(String packageName) {
    InstalledApps.startApp(packageName);
  }

  void openAppList() {
    showAppList.value = true;
    loadTopApps();
  }

  void closeAppList() {
    showAppList.value = false;
    searchQuery.value = '';
    filteredApps.value = apps;
  }

  void filterApps(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredApps.value = apps;
    } else {
      filteredApps.value = apps
          .where((app) => app.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  Future<void> loadTopApps() async {
    try {
      final result = await getTopUsedAppsToday(limit: 3);
      topApps.value = result;
    } catch (e) {
      topApps.value = [];
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadApp();
    loadTopApps();
  }
}
