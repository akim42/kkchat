import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kkenglish/forTeachers/main_screen.dart';
import 'package:kkenglish/kamila/main_screen.dart';
import 'package:new_version/new_version.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void  main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // Replace with actual values

    // options: const FirebaseOptions(
    //   apiKey: "AIzaSyBL0lNoafHLxJjJczHtNLjPE7Jo-ES3pyc",
    //   appId: "1:771310758031:web:9217bdc1a73e4ab4fce8fa",
    //   messagingSenderId: "771310758031",
    //   projectId: "kkenglish-2c344",
    // ),
  );
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp,DeviceOrientation.portraitDown])
      .then((_) =>
      runApp(ProviderScope(child: MyApp())));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void initState() {
    super.initState();

    // Instantiate NewVersion manager object (Using GCP Console app as example)
    final newVersion = NewVersion(
      iOSId: 'fly.kkenglish.kg.kkenglish',
      androidId: 'fly.kkenglish.kg.kkenglish',
    );

    // You can let the plugin handle fetching the status and showing a dialog,
    // or you can fetch the status and display your own dialog, or no dialog.
    const simpleBehavior = true;

    if (simpleBehavior) {
      basicStatusCheck(newVersion);
    } else {
      advancedStatusCheck(newVersion);
    }
  }

  basicStatusCheck(NewVersion newVersion) {
    newVersion.showAlertIfNecessary(context: context);
  }

  advancedStatusCheck(NewVersion newVersion) async {
    final status = await newVersion.getVersionStatus();
    if (status != null) {
      debugPrint(status.releaseNotes);
      debugPrint(status.appStoreLink);
      debugPrint(status.localVersion);
      debugPrint(status.storeVersion);
      debugPrint(status.canUpdate.toString());
      newVersion.showUpdateDialog(
        context: context,
        versionStatus: status,
        dialogTitle: 'Custom Title',
        dialogText: 'Custom Text',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KKenglish',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      // NotForKamila(),
      KamilaMainScreen()
      // MyHomePage(),

    );
  }
}