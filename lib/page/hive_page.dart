import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:study_hive/models/person.dart';
import 'hive_controller.dart';

class HivePage extends StatelessWidget {
  final controller = Get.put(HiveController());

  @override
  Widget build(BuildContext context) {
    var size4 = const SizedBox(
      height: 4,
      width: 4,
    );

    ///保存按钮
    var saveBtn = TextButton(
        onPressed: () {
          controller.save();
        },
        child: const Text(
          'Save',
          style: TextStyle(color: Colors.blue),
        ));

    ///通用输入框
    Widget baseEdit(String hintText, TextInputType type,
        TextEditingController textController) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.black87,
            width: 1.0,
          ),
        ),
        margin: const EdgeInsets.only(top: 6),
        padding: const EdgeInsets.all(0),
        height: 44,
        child: TextField(
          textInputAction: TextInputAction.none,
          keyboardType: type,
          cursorColor: Colors.black87,
          cursorWidth: 1,
          controller: textController,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10),
            filled: true,
            fillColor: Colors.white,
            hintText: hintText,
            hintStyle: const TextStyle(
              textBaseline: TextBaseline.alphabetic,
              color: Colors.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      );
    }

    ///保存组件
    var saveWidget = Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          baseEdit('Name', TextInputType.name, controller.nameEditController),
          size4,
          baseEdit('Age', TextInputType.number, controller.ageEditController),
          saveBtn
        ],
      ),
    );

    ///显示修改弹窗
    void showModifyDialog(int index, Person personData) => showDialog(
        context: context,
        builder: (BuildContext context) {
          TextEditingController nameController =
              TextEditingController(text: personData.name);
          TextEditingController ageController =
              TextEditingController(text: personData.age.toString());

          return AlertDialog(
            title: const Text('Modify Data'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: nameController),
                TextField(controller: ageController)
              ],
            ),
            actions: [
              ElevatedButton(
                  child: const Text('Modify'),
                  onPressed: () {
                    var person = Person(
                        name: nameController.text,
                        age: int.parse(ageController.text));
                    controller.modify(index, person);
                    Navigator.of(context).pop(); // 关闭对话框
                  })
            ],
          );
        });

    ///列表组件
    var listWidget = Expanded(
        child: Container(
            width: MediaQuery.of(context).size.width,
            // 允许高度自适应
            margin: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: ValueListenableBuilder(
                valueListenable: controller.personBox.listenable(),
                builder: (context, box, widget) {
                  if (box.isEmpty) {
                    return const Center(
                      child: Text('Empty'),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: box.length,
                        itemBuilder: (context, index) {
                          var personData = box.getAt(index)!;
                          return ListTile(
                            title: Text(personData.name),
                            subtitle: Text(personData.age.toString()),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    showModifyDialog(index, personData);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    controller.delete(index);
                                  },
                                ),
                              ],
                            ),
                          );
                        });
                  }
                })));

    var deleteAllBtn = ElevatedButton(
        onPressed: () {
          controller.deleteAll();
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 4),
            Text(
              'DeleteAll',
              style: TextStyle(color: Colors.red),
            )
          ],
        ));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Hive Demo"),
      ),
      body: Container(
        color: Colors.blue,
        child: Column(
          children: [saveWidget, listWidget, deleteAllBtn],
        ),
      ),
    );
  }
}
