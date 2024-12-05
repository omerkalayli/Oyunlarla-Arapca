import 'package:animated_check/animated_check.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:oyunlarla_arapca/string_extensions.dart';
import 'package:oyunlarla_arapca/topic/unit.dart';
import 'package:oyunlarla_arapca/words/word_card.dart';
import 'package:oyunlarla_arapca/words/word_component.dart';
import 'package:oyunlarla_arapca/words/words_controller.dart';
import 'package:vibration/vibration.dart';

class WordsPage extends StatefulWidget {
  const WordsPage({super.key});

  @override
  State<WordsPage> createState() => _WordsPageState();
}

class _WordsPageState extends State<WordsPage> with TickerProviderStateMixin {
  final WordsController wordsController = Get.find<WordsController>();
  double height = 120;
  bool isExpanded = false;
  bool isMeaningShown = false;
  bool isInitialMeaningShow = false;
  bool phase1 = true; // true
  bool phase2 = true; // true
  bool phase3 = false; // false
  bool phase4Initial = false;
  bool phase4wordAnimate = false;
  bool phase5 = false; // false
  bool showEdgeButtons = false;
  bool skip = false;
  bool showSuccess = false;
  bool showWrong = false;
  bool showSuccessScale = false;
  int cardsOpenCount = 0;
  int matchedCardCount = 0;
  bool startLastAnim = false;
  late List<WordComponent> words;
  late WordComponent? shownWord;
  // int unit = Get.arguments["topic"];
  late AnimationController _animationController;
  late Animation<double> _animation;
  int wordIndex = 0;
  bool textFalse = false;
  late List<WordCard> wordCards;
  int firstOpenCard = 0;
  int secondOpenCard = 0;
  bool finalPhase = false;
  int topicID = Get.arguments["topicID"];

  int wordNumber = 1;
  late int maxWordNumber;
  @override
  void initState() {
    wordsController.resetWrongWordIDs();
    wordsController.shuffleWords(topicID);
    maxWordNumber = wordsController.words[topicID].length;
    shownWord = wordsController.getWord(topicID);
    words = wordsController.getWords(topicID, 4);
    Future.delayed(Durations.medium1, () {
      setState(() {
        isInitialMeaningShow = true;
        showEdgeButtons = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1150), () {
      setState(() {
        isExpanded = true;
      });
    });
    Future.delayed(Duration(milliseconds: 1000), () {
      setState(() {
        isMeaningShown = true;
      });
    });
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
        parent: _animationController, curve: Curves.easeInOutCirc));

    super.initState();
  }

  double skipWidth = 400;
  double learnWidth = 400;
  TextStyle word1Style = TextStyle(fontSize: 20, color: Colors.white);
  TextStyle word2Style = TextStyle(fontSize: 20, color: Colors.white);
  TextStyle word3Style = TextStyle(fontSize: 20, color: Colors.white);
  TextStyle word4Style = TextStyle(fontSize: 20, color: Colors.white);

  TextEditingController textEditingController = TextEditingController();
  void navigateNextWord() {
    isExpanded = false;
    // setGradientColor(shownWord.id, topicController.getGrade(), unit);
    Future.delayed(Duration(milliseconds: 100), () {
      setState(() {
        isExpanded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    TextStyle textStyle = TextStyle(fontSize: 32, color: Colors.white);
    TextStyle endStyle = TextStyle(
        fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        actions: (phase2 || phase3)
            ? [
                Padding(
                  padding: EdgeInsets.only(top: 12, right: 8),
                  child: Text(
                    "$wordNumber / $maxWordNumber",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Gap(8)
              ]
            : [],
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Text(
            wordsController.topics[topicID],
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w500, fontSize: 30),
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedContainer(
            duration: Durations.short3,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xffD6A77A), Color(0xff6F4F1F)],
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft)),
          ),
          if (phase2) ...[
            phase2FindOf4(width, shownWord!)
          ]
          //  else if (phase1) ...[
          //   phase1WannaLearn(
          //       topicController, shownWord!, textStyle, screenHeight)
          // ]
          else if (phase3) ...[
            phase3TextInput(shownWord, context, textStyle)
          ] else ...[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Test bitti.",
                    style: endStyle.copyWith(fontSize: 36),
                  ),
                  Gap(100),
                  if (wordsController.wrongWordIDs.length == 0) ...[
                    Text(
                      "Tüm cevapların doğru!",
                      style: endStyle.copyWith(fontSize: 24),
                    )
                  ] else ...[
                    Column(
                      children: [
                        Text(
                          "Karıştırdığın Kelimeler",
                          style: endStyle.copyWith(fontSize: 24),
                        ),
                        Gap(16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              wordsController.wrongWordIDs.length, (index) {
                            var flattened = wordsController.getFlattenedList();
                            int wrongWordID =
                                wordsController.wrongWordIDs[index];
                            WordComponent wrongWord = flattened
                                .firstWhere((word) => word.id == wrongWordID);
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  wrongWord.author,
                                  textAlign: TextAlign.start,
                                  style: endStyle.copyWith(fontSize: 16),
                                ),
                                Gap(8),
                                Icon(
                                  Icons.forward_rounded,
                                  color: Colors.white,
                                ),
                                Gap(8),
                                Text(
                                  wrongWord.book,
                                  style: endStyle.copyWith(fontSize: 16),
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    )
                  ]
                ],
              ),
            )
          ],
          showSuccess
              ? Container(
                  color: Colors.black.withOpacity(0.2),
                  width: double.infinity,
                  height: double.infinity,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedScale(
                        duration: Durations.short2,
                        scale: showSuccessScale ? 1 : 0,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            color: Colors.green,
                          ),
                        ),
                      ),
                      Center(
                          child: AnimatedCheck(
                        progress: _animation,
                        size: 120,
                        color: Colors.white,
                      )),
                    ],
                  ))
              : const SizedBox(),
          showWrong
              ? Animate(
                  effects: [ShakeEffect(hz: 10)],
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(99),
                          color: Colors.red,
                        ),
                      ),
                      Center(
                          child: Icon(
                        Icons.cancel_outlined,
                        color: Colors.white,
                        size: 64,
                      )),
                    ],
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Column phase3TextInput(
      WordComponent? shownWord, BuildContext context, TextStyle textStyle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        AnimatedScale(
          duration: Durations.medium1,
          scale: isExpanded ? 1 : 0,
          child: Text(shownWord!.book,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 36, color: Colors.white)),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TapRegion(
            onTapOutside: (_) {
              FocusScope.of(context).unfocus();
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: Text(
                    "Kitabın yazarını giriniz.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                Gap(16),
                TextFormField(
                  controller: textEditingController,
                  onEditingComplete: () {
                    if (textEditingController.text.toLowerCase().trim() ==
                        shownWord!.author.toLowerCase()) {
                      setState(() {
                        showSuccess = true;
                        _animationController.forward();
                        Future.delayed(Durations.short1, () {
                          setState(() {
                            showSuccessScale = true;
                          });
                        });
                        Future.delayed(Durations.extralong4, () {
                          _animationController.reset();
                          setState(() {
                            showSuccessScale = false;
                            showSuccess = false;
                          });
                        });
                        setState(() {
                          // shownWord = wordsController.getNextWord(topicID);
                          wordStudied();
                          if (shownWord == null) {
                            phase2 = false;
                            phase1 = false;
                            phase3 = false;
                            isExpanded = false;
                            // setGradientColor(
                            //     shownWord.id, topicController.getGrade(), unit);
                            Future.delayed(Duration(milliseconds: 100), () {
                              setState(() {
                                isExpanded = true;
                              });
                            });
                            Future.delayed(Duration(milliseconds: 1000), () {
                              setState(() {
                                phase4Initial = true;
                              });
                            });
                            Future.delayed(Duration(milliseconds: 1200), () {
                              setState(() {
                                phase4wordAnimate = true;
                              });
                            });
                            Future.delayed(Duration(milliseconds: 1500), () {
                              setState(() {
                                phase4wordAnimate = false;
                              });
                            });
                          }
                          navigateNextWord();
                          textEditingController.text = "";
                        });
                      });
                    } else {
                      setState(() {
                        wordsController.addToWrongWordIDs();
                        showWrong = true;
                      });
                      Future.delayed(Durations.medium2, () {
                        setState(() {
                          showWrong = false;
                        });
                      });
                    }
                  },
                  style: TextStyle(color: Colors.white, fontSize: 20),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none),
                      border: InputBorder.none,
                      fillColor: Colors.black.withOpacity(0.2),
                      filled: true),
                ),
                Gap(16),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                              side: BorderSide(color: Colors.green.shade700),
                              borderRadius: BorderRadius.circular(8))),
                          backgroundColor:
                              WidgetStatePropertyAll(Colors.green)),
                      onPressed: () {
                        if (textEditingController.text.toLowerCase().trim() ==
                            shownWord!.author.toLowerCase()) {
                          setState(() {
                            showSuccess = true;
                            _animationController.forward();
                            Future.delayed(Durations.short1, () {
                              setState(() {
                                showSuccessScale = true;
                              });
                            });
                            Future.delayed(Durations.extralong4, () {
                              _animationController.reset();
                              setState(() {
                                showSuccessScale = false;
                                showSuccess = false;
                              });
                            });
                            setState(() {
                              // shownWord = wordsController.getNextWord(topicID);
                              wordStudied();
                              if (shownWord == null) {
                                setState(() {
                                  phase2 = false;
                                  phase1 = false;
                                  phase3 = false;
                                  isExpanded = false;
                                  // setGradientColor(
                                  //     shownWord.id, topicController.getGrade(), unit);
                                  Future.delayed(Duration(milliseconds: 100),
                                      () {
                                    setState(() {
                                      isExpanded = true;
                                    });
                                  });
                                  Future.delayed(Duration(milliseconds: 1000),
                                      () {
                                    setState(() {
                                      phase4Initial = true;
                                    });
                                  });
                                  Future.delayed(Duration(milliseconds: 1200),
                                      () {
                                    setState(() {
                                      phase4wordAnimate = true;
                                    });
                                  });
                                  Future.delayed(Duration(milliseconds: 1500),
                                      () {
                                    setState(() {
                                      phase4wordAnimate = false;
                                    });
                                  });
                                });
                              }
                              navigateNextWord();
                              textEditingController.text = "";
                            });
                          });
                        } else {
                          setState(() {
                            wordsController.addToWrongWordIDs();
                            showWrong = true;
                          });
                          Future.delayed(Durations.medium2, () {
                            setState(() {
                              showWrong = false;
                            });
                          });
                        }
                      },
                      child: Center(
                        child: Text(
                          "Kontol Et",
                          style: textStyle.copyWith(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                      )),
                ),
                Gap(8),
                Row(
                  children: [
                    Spacer(),
                    InkWell(
                      onTap: () {
                        wordPassed();
                        Future.delayed(Duration(seconds: 1), () {
                          Navigator.of(context).pop();
                        });
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Text(
                          "Pas geç",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Column phase2FindOf4(double width, WordComponent shownWord) {
    changeTextStyleFocus() {
      word1Style = word1Style.copyWith(fontSize: 24);
    }

    changeTextStyleUnfocus() {
      word1Style = word1Style.copyWith(fontSize: 20);
    }

    changeTextStyleFocus2() {
      word2Style = word2Style.copyWith(fontSize: 24);
    }

    changeTextStyleUnfocus2() {
      word2Style = word2Style.copyWith(fontSize: 20);
    }

    changeTextStyleFocus3() {
      word3Style = word3Style.copyWith(fontSize: 24);
    }

    changeTextStyleUnfocus3() {
      word3Style = word3Style.copyWith(fontSize: 20);
    }

    changeTextStyleFocus4() {
      word4Style = word4Style.copyWith(fontSize: 24);
    }

    changeTextStyleUnfocus4() {
      word4Style = word4Style.copyWith(fontSize: 20);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DragTarget<int>(onAcceptWithDetails: (id) {
              if (id.data == words[0].id) {
                wordStudied();
              } else {
                wordWrong();
              }
            }, onMove: (_) {
              setState(() {
                changeTextStyleFocus();
              });
            }, onLeave: (_) {
              setState(() {
                changeTextStyleUnfocus();
              });
            }, builder: (_, __, ___) {
              return SizedBox(
                width: width / 2,
                height: 300,
                child: Center(
                  child: Text(
                    textAlign: TextAlign.center,
                    words[0].book,
                    style: word1Style,
                  ),
                ),
              );
            }),
            DragTarget<int>(onAcceptWithDetails: (id) {
              if (id.data == words[1].id) {
                wordStudied();
              } else {
                wordWrong();
              }
            }, onMove: (_) {
              setState(() {
                changeTextStyleFocus2();
              });
            }, onLeave: (_) {
              setState(() {
                changeTextStyleUnfocus2();
              });
            }, builder: (_, __, ___) {
              return SizedBox(
                  width: width / 2,
                  height: 300,
                  child: Center(
                      child: Text(
                          textAlign: TextAlign.center,
                          words[1].book,
                          style: word2Style)));
            })
          ],
        ),
        AnimatedScale(
          curve: Curves.easeOutCirc,
          duration: Durations.medium1,
          scale: isExpanded ? 1 : 0,
          child: Column(
            children: [
              Draggable<int>(
                data: shownWord.id,
                child: Container(
                  child: Text(
                    shownWord.author,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                feedback: Center(
                  child: Material(
                      color: Colors.transparent,
                      child: Text(shownWord.author,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 16))),
                ),
                childWhenDragging: const SizedBox(
                  height: 34,
                ),
                onDragStarted: () async {
                  setState(() {
                    height = 100;
                  });
                },
                onDragEnd: (_) {
                  setState(() {
                    height = 120;
                  });
                },
              ),
              const Gap(16),
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DragTarget<int>(onAcceptWithDetails: (id) {
              if (id.data == words[2].id) {
                wordStudied();
              } else {
                wordWrong();
              }
            }, onMove: (_) {
              setState(() {
                changeTextStyleFocus3();
              });
            }, onLeave: (_) {
              setState(() {
                changeTextStyleUnfocus3();
              });
            }, builder: (_, __, ___) {
              return SizedBox(
                  width: width / 2,
                  height: 300,
                  child: Center(
                      child: Text(
                          textAlign: TextAlign.center,
                          words[2].book,
                          style: word3Style)));
            }),
            DragTarget<int>(onAcceptWithDetails: (id) {
              if (id.data == words[3].id) {
                wordStudied();
              } else {
                wordWrong();
              }
            }, onMove: (_) {
              setState(() {
                changeTextStyleFocus4();
              });
            }, onLeave: (_) {
              setState(() {
                changeTextStyleUnfocus4();
              });
            }, builder: (_, __, ___) {
              return SizedBox(
                  width: width / 2,
                  height: 300,
                  child: Center(
                      child: Text(
                          textAlign: TextAlign.center,
                          words[3].book,
                          style: word4Style)));
            })
          ],
        ),
      ],
    );
  }

  void wordWrong() async {
    wordsController.addToWrongWordIDs();
    await AudioPlayer().play(
      AssetSource("sound/wrong.mp3"),
    );
    Vibration.vibrate();
    setState(() {
      showWrong = true;
      Future.delayed(Durations.medium4, () {
        setState(() {
          showWrong = false;
        });
      });
    });
  }

  void wordPassed() {
    String author = shownWord?.author ?? "";

    wordsController.addToWrongWordIDs();
    showDialog(
        context: context,
        builder: (_) {
          return Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                child: Text(
                  author,
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          );
        });
    setState(() {
      shownWord = wordsController.getNextWord(topicID);
      if (shownWord == null) {
        wordNumber = 1;
        setState(() {
          phase1 = false;
          phase2 = false;
          if (phase3) {
            phase3 = false;
          } else {
            phase3 = true;
          }
          shownWord = wordsController.getWord(topicID);

          isExpanded = false;
          Future.delayed(Duration(milliseconds: 100), () {
            setState(() {
              isExpanded = true;
            });
          });
        });
      } else {
        wordNumber++;
      }
    });
  }

  void wordStudied() async {
    await AudioPlayer().play(
      AssetSource("sound/correct.wav"),
    );
    setState(() {
      shownWord = wordsController.getNextWord(topicID);
      if (shownWord == null) {
        wordNumber = 1;
        setState(() {
          phase1 = false;
          phase2 = false;
          if (phase3) {
            phase3 = false;
          } else {
            phase3 = true;
          }
          shownWord = wordsController.getWord(topicID);

          isExpanded = false;
          Future.delayed(Duration(milliseconds: 100), () {
            setState(() {
              isExpanded = true;
            });
          });
        });
      } else {
        wordNumber++;
        if (!phase3) {
          words = wordsController.getWords(topicID, 4);
          word4Style = word4Style.copyWith(fontSize: 20);
          word3Style = word3Style.copyWith(fontSize: 20);
          word2Style = word2Style.copyWith(fontSize: 20);
          word1Style = word1Style.copyWith(fontSize: 20);
        }

        showSuccess = true;
        _animationController.forward();
        Future.delayed(Durations.medium1, () {
          showEdgeButtons = true;
          Future.delayed(Durations.short1, () {
            setState(() {
              showSuccessScale = true;
            });
          });
          Future.delayed(Durations.extralong4, () {
            setState(() {
              isInitialMeaningShow = true;
              showSuccessScale = false;
              showSuccess = false;
              _animationController.reset();
            });
          });
          Future.delayed(Duration(milliseconds: 2150), () {
            setState(() {
              isExpanded = true;
            });
          });
          Future.delayed(Duration(milliseconds: 2000), () {
            setState(() {
              isMeaningShown = true;
            });
          });
        });
      }
    });
  }
}

class DragWidget extends StatelessWidget {
  const DragWidget({
    required this.height,
    required this.word,
    super.key,
  });

  final double height;
  final String word;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.long2,
      height: height,
    );
  }
}
