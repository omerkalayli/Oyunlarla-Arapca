import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:kitaplar_ve_yazarlari/app_theme.dart';
import 'package:kitaplar_ve_yazarlari/topic/topics_page.dart';
import 'package:kitaplar_ve_yazarlari/words/words_controller.dart';
import 'package:kitaplar_ve_yazarlari/words/words_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.put(WordsController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: appTheme,
      home: const TopicsPage(),
      initialRoute: "/",
      routes: {
        "/units": (context) => TopicsPage(),
        "/words": (context) => WordsPage(),
      },
    );
  }
}
