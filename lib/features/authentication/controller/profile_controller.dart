import 'package:get/get.dart';
import 'package:dineswift_management/features/dashboard/screens/widgets/profile_setting.dart';

class ProfileController extends GetxController {
  void navigateToProfile() {
    Get.to(() => const ProfileScreen());
  }
}
