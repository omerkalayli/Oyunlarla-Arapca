import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:kitaplar_ve_yazarlari/topic/unit.dart';
import 'package:kitaplar_ve_yazarlari/topic/topic_tile.dart';
import 'package:kitaplar_ve_yazarlari/words/words_controller.dart';

class TopicsPage extends StatefulWidget {
  const TopicsPage({super.key});

  @override
  State<TopicsPage> createState() => _TopicsPageState();
}

class _TopicsPageState extends State<TopicsPage> {
  WordsController wordsController = Get.find();

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xff6F4F1F), // Navigation bar rengi
      systemNavigationBarIconBrightness: Brightness.light, // Iconların rengi
    ));
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color.fromARGB(72, 0, 0, 0),
        title: Text(
          "Konular",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffD6A77A), Color(0xff6F4F1F)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
          ),
          ListView.builder(
              itemCount: wordsController.topics.length,
              itemBuilder: (context, index) {
                return TopicTile(
                    count: wordsController.words[index].length,
                    text: wordsController.topics[index],
                    onClick: () {
                      WordsController wordsController = Get.find();
                      wordsController.selectedTopic = index;

                      Get.toNamed('/words', arguments: {"topicID": index});
                    });
              }),
        ],
      ),
    );
  }
}
