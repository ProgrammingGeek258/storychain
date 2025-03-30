import 'package:http/http.dart' as http;
import 'all_imports.dart';

GetStorage getStorage = GetStorage();

List<Map> tabs = [
  {
    "title": AppStrings.home,
    "icon": Icons.home_outlined,
    "page": Routes.HOME,
  },
  {
    "title": AppStrings.profile,
    "icon": Icons.person_outline,
    "page": Routes.USER_PROFILE,
  },
];

Map apiKeys = {
  "gemini": {
    "apis": [
      "AIzaSyB6frvuqS6igR3CkWF1arz0kTTQODGSxLU",
    ],
    "index": 0,
  },
  "unsplash": {
    "apis": [
      "i7Jw5ebxgDS8oq44B4Is2QtDa4iAkWAW2WhAjmhTdgA",
    ],
    "index": 0,
  },
};

String getApi(String api) {
  return apiKeys[api]["apis"][apiKeys[api]["index"]];
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

String generateFromMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

bool validateEmail(String email) {
  return RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(email);
}

bool validatePassword(String password) {
  return RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$')
      .hasMatch(password);
}

bool validatePhone(String phone) {
  String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = new RegExp(patttern);
  if (isEmptyString(phone)) {
    return false;
  } else if (!regExp.hasMatch(phone)) {
    return false;
  }
  return true;
}

dynamic getKey(Map data, List location, dynamic replacement) {
  dynamic value = data;
  for (var key in location) {
    if (value is Map) {
      print(value.toString() + " is Map");
      value = value[key];
    } else {
      return replacement;
    }
  }
  return value ?? replacement;
}

bool isEmptyString(String? string) {
  if (string == null || string.isEmpty) {
    return true;
  }
  return false;
}

void configureEasyLoading() {
  EasyLoading.instance
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..indicatorColor = ColorStyle.primary500
    ..loadingStyle = EasyLoadingStyle.dark
    ..userInteractions = false
    ..dismissOnTap = false;
}

String greet() {
  DateTime now = DateTime.now();
  int hours = now.hour;
  String greeting = "";

  if (hours >= 1 && hours <= 12) {
    greeting = "Good Morning";
  } else if (hours >= 12 && hours <= 16) {
    greeting = "Good Afternoon";
  } else if (hours >= 16 && hours <= 21) {
    greeting = "Good Evening";
  } else if (hours >= 21 && hours <= 24) {
    greeting = "Good Night";
  }
  return greeting;
}

void logout() {
  getStorage.erase();
  FirebaseAuth.instance.signOut();
  Get.offAllNamed(Routes.SIGNUP);
}

void writeUserDetails(Map<String, dynamic> data) {
  // print(data);
  getStorage.write("userDetails", data);
  // print(readUserDetails());
}

Map<String, dynamic>? readUserDetails() {
  return getStorage.read("userDetails");
}

showSnackbar({String? title, String? message}) {
  Get.snackbar(
    title ?? AppStrings.appName,
    message ?? '',
    backgroundColor: ColorStyle.primary500,
    colorText: ColorStyle.othersWhite,
  );
}

DateTime fromUtc(String dateTime) {
  return DateTime.parse(dateTime).toLocal();
}

String toUtc(DateTime dateTime) {
  return dateTime.toUtc().toString();
}

String formatDateTime(DateTime dateTime) {
  return DateFormat.yMMMMd().format(dateTime);
}

String formatDateTimeDifference(DateTime startDateTime, endDateTime) {
  Duration difference = startDateTime.difference(endDateTime);

  return humanizeDuration(
    difference,
    options: const HumanizeOptions(spacer: " ", units: [
      Units.day,
      Units.hour,
      Units.minute,
    ]),
  );
}

Future textToSpeech(String text) async {
  FlutterTts flutterTts = FlutterTts();
  await flutterTts.setIosAudioCategory(
      IosTextToSpeechAudioCategory.ambient,
      [
        IosTextToSpeechAudioCategoryOptions.allowBluetooth,
        IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
        IosTextToSpeechAudioCategoryOptions.mixWithOthers
      ],
      IosTextToSpeechAudioMode.voicePrompt);
  await flutterTts.awaitSpeakCompletion(true);
  await flutterTts.speak(text);
}

void editUserDetails(Map<String, dynamic> data) {
  Map userDetails = getStorage.read("userDetails");
  for (var key in data.keys) {
    if (userDetails[key] == null) {
      userDetails.addEntries({key: data[key]}.entries);
    } else {
      userDetails[key] = data[key];
    }
  }
  getStorage.write("userDetails", data);
}

String getMessageFromErrorCode(e) {
  // print(e.code);
  // print(e.message);
  switch (e.code) {
    case "ERROR_EMAIL_ALREADY_IN_USE":
    case "account-exists-with-different-credential":
    case "email-already-in-use":
      return "Email already used. Go to login page.";
      break;
    case "ERROR_WRONG_PASSWORD":
    case "wrong-password":
      return "Wrong email/password combination.";
      break;
    case "ERROR_USER_NOT_FOUND":
    case "user-not-found":
      return "No user found with this email.";
      break;
    case "channel-error":
      return "Unable to establish connection on channel. Please try again later";
      break;
    case "ERROR_USER_DISABLED":
    case "user-disabled":
      return "User disabled.";
      break;
    case "ERROR_TOO_MANY_REQUESTS":
    case "operation-not-allowed":
      return "Too many requests to log into this account.";
      break;
    case "ERROR_OPERATION_NOT_ALLOWED":
    case "operation-not-allowed":
      return "Server error, please try again later.";
      break;
    case "ERROR_INVALID_EMAIL":
    case "invalid-email":
      return "Email address is invalid.";
      break;
    default:
      return "Login failed. Please try again.";
      break;
  }
}

void showFirebaseError(error) {
  Get.snackbar(AppStrings.appName, error);
}

String idToString(String id) {
  return id.replaceAll("_", " ").capitalizeFirst ?? id;
}

run(VoidCallback task) async {
  try {
    task();
  } catch (e, stack) {
    showDialog(
      context: Get.context!,
      builder: (context) => AlertDialog(
        title: Text('Oops!'),
        backgroundColor: ColorStyle.othersWhite,
        content: Text(e.toString()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
              style: TextStyle(
                color: ColorStyle.primary500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<String> getImage(String query) async {
  var request = await http.get(Uri.parse(
      'https://api.unsplash.com/search/photos?query=$query&client_id=i7Jw5ebxgDS8oq44B4Is2QtDa4iAkWAW2WhAjmhTdgA'));

  String response = request.body;

  if (request.statusCode == 200) {
    return jsonDecode(response)["results"][0]["urls"]["raw"];
  } else {
    print(request.reasonPhrase);
  }
  return "";
}

// Future<Map<String, dynamic>> fetchDetailsAuto(
//     String text, List parameters) async {
//   String bodyEncoded = json.encode({
//     "system_instruction": {
//       "parts": [
//         {
//           "text": AppStrings.autoFillPrompt,
//         }
//       ]
//     },
//     "contents": [
//       {
//         "parts": [
//           {
//             "text": jsonEncode({
//               "text": text,
//               "parameters": parameters,
//             }),
//           }
//         ]
//       }
//     ],
//     "generationConfig": {"response_mime_type": "application/json"}
//   });
//   // print(bodyEncoded);
//   var headers = {'Content-Type': 'application/json'};
//   var request = await http.post(
//     Uri.parse(
//         'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-pro:generateContent?key=${apiKeys["gemini"]}'),
//     headers: headers,
//     body: bodyEncoded,
//   );
//
//   if (request.statusCode == 200) {
//     String response = request.body;
//     print(response);
//     return json.decode(response);
//   } else {
//     // print(request.statusCode);
//     return {};
//   }
// }
