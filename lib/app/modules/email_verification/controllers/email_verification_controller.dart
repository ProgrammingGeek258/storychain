import 'package:get/get.dart';
import 'package:storychain/app/helper/all_imports.dart';

class EmailVerificationController extends CommonController {
  Timer? timer;

  @override
  void onInit() {
    user?.sendEmailVerification();
    timer =
        Timer.periodic(Duration(seconds: 3), (timer) => checkEmailVerified());
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    if (FirebaseAuth.instance.currentUser!.emailVerified) {
      ScaffoldMessenger.of(Get.context!)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));
      if (Get.arguments != null) {
        Get.offAllNamed(Get.arguments["route"]);
      } else {
        Get.offAllNamed(Routes.HOME);
      }

      timer?.cancel();
    }
  }
}
