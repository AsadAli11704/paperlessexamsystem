import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class AttemptController extends GetxController {
  final RxBool isLoading = true.obs;
  final Rxn<Map<String, dynamic>> paper = Rxn<Map<String, dynamic>>();
  final List<TextEditingController> answerControllers = [];
  late Stream<QuerySnapshot> paperStream;

  void setupPaperStream() {
    final box = GetStorage();
    final String department = box.read("student_department") ?? "";
    final String semester = box.read("student_semester") ?? "";
    final String section = box.read("student_section") ?? "";
    print(department);
    print(semester);
    print(section);
    paperStream = FirebaseFirestore.instance
        .collection("papers")
        .where("department", isEqualTo: department)
        .where("semester", isEqualTo: semester)
        .where("section", isEqualTo: section)
        .snapshots();
  }

  /// Use this to update controllers when the paper arrives
  void updateControllersFromPaper(Map<String, dynamic> paperData) {
    final List questions = paperData["questions"];
    answerControllers.clear();
    for (int i = 0; i < questions.length; i++) {
      answerControllers.add(TextEditingController());
    }
  }

  Future<DateTime> getServerTime() async {
    final docRef =
        FirebaseFirestore.instance.collection('serverTime').doc('now');

    await docRef.set(
        {'timestamp': FieldValue.serverTimestamp()}, SetOptions(merge: true));

    // Read the document back to get actual server time
    final snapshot = await docRef.get();
    final timestamp = snapshot.data()?['timestamp'] as Timestamp;

    return timestamp.toDate();
  }

  String currentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      debugPrint("⚠️ No user is currently logged in.");
      return '';
    }
    return user.uid;
  }
}
