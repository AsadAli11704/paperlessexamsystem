import 'package:flutter/material.dart';
import 'package:fyppaperless/layouthelper/textfieldwidget.dart';
import 'package:fyppaperless/paperattemptingcontroller.dart';
import 'package:get/get.dart';

class AttemptScreen extends StatelessWidget {
  static const id = "/AttemptingScreen";
  final AttemptController controller = Get.put(AttemptController());
  AttemptScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attempt Paper")),
      body: StreamBuilder(
        stream: controller.paperStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
                child: Text("No paper available at this time."));
          }

          final paperDoc = snapshot.data!.docs.first;
          final paperData = paperDoc.data() as Map<String, dynamic>;

          controller.paper.value = paperData;
          controller.updateControllersFromPaper(paperData);

          final List questions = paperData["questions"];

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Subject: ${paperData["title"]}",
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 20),

                /// Questions
                Expanded(
                  child: ListView.builder(
                    itemCount: questions.length,
                    itemBuilder: (_, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              "Q${index + 1}: ${questions[index]["question"]}"),
                          const SizedBox(height: 8),
                          MyTextField(
                            mycontroller: controller.answerControllers[index],
                            hinttext: "Write Your Answer Here ",
                            lines: 5,
                          ),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),

                ElevatedButton(
                  onPressed: () {
                    // Print answers
                    for (int i = 0;
                        i < controller.answerControllers.length;
                        i++) {
                      print(
                          "Answer ${i + 1}: ${controller.answerControllers[i].text}");
                    }
                    Get.snackbar(
                        "Success", "Answers collected (printing only)");
                  },
                  child: const Text("Submit Answers"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
