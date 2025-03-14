import 'package:get/get_navigation/get_navigation.dart';
import 'package:mini_pro_app/res/routes/routes_name.dart';
import 'package:mini_pro_app/view/detail_collection_screen.dart';
import 'package:mini_pro_app/view/home_screen.dart';
import 'package:mini_pro_app/view/loading_screen.dart';
import 'package:mini_pro_app/view/ride_on_progress_scree.dart';
import 'package:mini_pro_app/view/splash_screen.dart';

class AppRoutes {
  static appRoutes() => [
        GetPage(
          name: RoutesName.splashScreen,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: RoutesName.homeScreen,
          page: () => const HomeScreen(),
        ),
        GetPage(
          name: RoutesName.detailCollectionScreen,
          page: () => const DetailCollectionScreen(),
        ),
        GetPage(
          name: RoutesName.loadingScreen,
          page: () => const LoadingScreen(),
        ),
        GetPage(
          name: RoutesName.rideOnProgressScreen,
          page: () => const RideOnProgressScreen(),
        ),
      ];
}
