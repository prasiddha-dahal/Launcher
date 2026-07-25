import 'package:get/get.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';

class HomeController extends GetxController{

  var isLoading = false.obs;
  var apps = <AppInfo>[].obs;
  var filteredApps = <AppInfo>[].obs;
  var showAppList = false.obs;
  var searchQuery = ''.obs;

  Future loadApp() async{
    isLoading.value = true;
    List<AppInfo> installedApps = await InstalledApps.getInstalledApps(excludeNonLaunchableApps: true, excludeSystemApps: false);
    installedApps.sort((a,b)=> a.name.compareTo(b.name));
    apps.value = installedApps;
    isLoading.value = false;
  }

  void launchApp(String packageName) {
    InstalledApps.startApp(packageName);
  }

  void openAppList(){
    showAppList.value = true;
  }

  void closeAppList(){
    showAppList.value = false;
  }

  void filterApps(String query){
    searchQuery.value = query;
    if(query.isEmpty){
      filteredApps.value = apps;
    } else {
      filteredApps.value = apps.where((app)=>app.name.toLowerCase().contains(query.toLowerCase())).toList();
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    loadApp();
  }

}