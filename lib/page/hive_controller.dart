import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:study_hive/models/person.dart';

class HiveController extends GetxController {
  late TextEditingController nameEditController, ageEditController;

  final personBox = Hive.box<Person>('personBox');

  @override
  void onInit() {
    super.onInit();
    nameEditController = TextEditingController();
    ageEditController = TextEditingController();
  }

  void save() {
    var person = Person(
        name: nameEditController.text, age: int.parse(ageEditController.text));
    personBox.add(person);
    nameEditController.clear();
    ageEditController.clear();
  }

  void modify(int index, Person person) {
    personBox.putAt(index, person);
  }

  void delete(int index) {
    personBox.deleteAt(index);
  }

  void deleteAll() {
    personBox.clear();
  }

  @override
  void onClose() {
    nameEditController.dispose();
    ageEditController.dispose();
    super.onClose();
  }
}
