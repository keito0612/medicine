import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:medicine/base_helper.dart';
import 'package:medicine/edit_model.dart';
import 'package:provider/provider.dart';

class EditPage extends StatelessWidget {
  EditPage(this.hospitalText, this.examinationText, this.image, this.id);
  final String hospitalText;
  final String examinationText;
  final String image;
  final int id;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditModel>(
      create: (_) => EditModel(hospitalText, examinationText, image, id),
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 224, 234),
        appBar: AppBar(
          title: const Text('編集'),
          backgroundColor: Colors.pink[100],
        ),
        body: Consumer<EditModel>(builder: (context, model, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 8, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        //写真の枠線
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '写真',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 3,
                          width: 310,
                          color: const Color.fromARGB(255, 190, 184, 184),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    height: 240,
                    child: InkWell(
                      onTap: () async {
                        //　カメラを起動
                        await model.getImagecamera();
                      },
                      child: model.imageFile != null
                          ? Base64Helper().imageFromBase64String(
                              base64Encode(model.imageFile!.readAsBytesSync()))
                          : Base64Helper().imageFromBase64String(image),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //枠線
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 3,
                          width: 350,
                          color: const Color.fromARGB(255, 190, 184, 184),
                        ),
                      ],
                    ),
                  ),
                  //病院名/診察科目の枠線
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        const Text(
                          '病院名/診察科目',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Container(
                          height: 3,
                          width: 220,
                          color: const Color.fromARGB(255, 190, 184, 184),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 360,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 246, 209, 222)),
                      borderRadius: BorderRadius.circular(10),
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                    child: Column(children: <Widget>[
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          controller: model.textController,
                          decoration: const InputDecoration(
                            labelText: '病院名',
                            hintText: '〇〇病院',
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color.fromARGB(255, 246, 209, 222),
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          ),
                          onChanged: (text) {
                            model.setHospitalText(text);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 300,
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 15,
                          ),
                          controller: model.textController2,
                          decoration: const InputDecoration(
                              labelText: '診療科目',
                              hintText: '皮膚科',
                              border: InputBorder.none,
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(255, 246, 209, 222),
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)))),
                          onChanged: (text2) {
                            model.setExaminationText(text2);
                          },
                        ),
                      ),
                    ]),
                  ),
                  //枠線
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 3,
                          width: 350,
                          color: const Color.fromARGB(255, 190, 184, 184),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: ElevatedButton(
                        child: const Text('編集'),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.pink[100],
                        ),
                        onPressed: () async {
                          model.isUpdated()
                              ? await updeteDialog(model, context)
                              : null;
                        }),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }

  //更新ダイアログ
  Future updeteDialog(EditModel model, BuildContext context) async {
    try {
      await model.update();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('更新しました。'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                },
              ),
            ],
          );
        },
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('更新できませんでした'),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
