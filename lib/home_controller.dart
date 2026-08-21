import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class HomeController extends GetxController {
  final _box = GetStorage();
  static const _hiddenAppsKey = 'hiddenApps';
  static const _swipeLeftAppkey = 'swipeLeftApp';
  static const _swipeRightAppkey = 'swipeRightApp';

  var apps = <AppInfo>[].obs;
  var filteredApps = <AppInfo>[].obs;
  var hiddenApps = <String>[].obs; // package names
  var isLoading = true.obs;
  var showAppList = false.obs;
  var searchQuery = ''.obs;
  var swipeLeftApp = ''.obs;
  var swipeRightApp = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _loadHiddenApps();
    _loadSwipeApp();
    loadApps();
  }

  void _loadHiddenApps() {
    final stored = _box.read<List>(_hiddenAppsKey);
    if (stored != null) {
      hiddenApps.value = stored.cast<String>();
    }
  }

  Future<void> loadApps() async {
    isLoading.value = true;
    List<AppInfo> installedApps = await InstalledApps.getInstalledApps(
      excludeSystemApps: false,
      excludeNonLaunchableApps: true,
    );
    installedApps.sort((a, b) => a.name.compareTo(b.name));
    apps.value = installedApps;
    _applyVisibility();
    isLoading.value = false;
  }

  void _loadSwipeApp(){
    swipeLeftApp.value = _box.read(_swipeLeftAppkey) ?? '';
    swipeRightApp.value = _box.read(_swipeRightAppkey) ?? '';
  }

  void setSwipeLeftApp(String packageName) {
    swipeLeftApp.value = packageName;
    _box.write(_swipeLeftAppkey, packageName);
  }

  void setSwipeRightApp(String packageName) {
    swipeRightApp.value = packageName;
    _box.write(_swipeRightAppkey, packageName);
  }

  void _applyVisibility() {
    filteredApps.value = apps
        .where((app) => !hiddenApps.contains(app.packageName))
        .toList();
  }

  void hideApp(String packageName) {
    if (!hiddenApps.contains(packageName)) {
      hiddenApps.add(packageName);
      _box.write(_hiddenAppsKey, hiddenApps);
      _applyVisibility();
    }
  }

  void unhideApp(String packageName) {
    hiddenApps.remove(packageName);
    _box.write(_hiddenAppsKey, hiddenApps);
    _applyVisibility();
  }

  void launchApp(String packageName) {
    InstalledApps.startApp(packageName);
  }

  void openAppList() => showAppList.value = true;

  void closeAppList() {
    showAppList.value = false;
    searchQuery.value = '';
    _applyVisibility();
  }

  void filterApps(String query) {
    searchQuery.value = query;
    final visibleApps = apps.where(
      (app) => !hiddenApps.contains(app.packageName),
    );
    if (query.isEmpty) {
      filteredApps.value = visibleApps.toList();
    } else {
      filteredApps.value = visibleApps
          .where((app) => app.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }
}
