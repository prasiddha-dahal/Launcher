import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class HomeController extends GetxController{

  var isLoading = false.obs;
  var apps = <AppInfo>[].obs;

  Future loadApp() async{
    isLoading.value = true;
    List<AppInfo> installedApps = await InstalledApps.getInstalledApps(excludeNonLaunchableApps: true, excludeSystemApps: false);
    installedApps.sort((a,b)=> a.name.compareTo(b.name));
    apps.value = installedApps;
    isLoading.value = false;
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadApp();
  }

}