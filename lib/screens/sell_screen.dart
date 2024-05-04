import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import '../constants.dart';
import '../widgets/widgets.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({Key? key}) : super(key: key);

  @override
  _SellScreenState createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  TextEditingController nameController = TextEditingController(),
      descriptionController = TextEditingController(),
      priceController = TextEditingController();
  int itemCount = 0;
  bool showProgress = false;

  File file = File('-1');

  List<String> selectedCategories = [];

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore fireStore = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.blueGrey,
        ),
        child: const CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(
            Colors.white,
          ),
        ),
      ),
      inAsyncCall: showProgress,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sell Screen'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 10,
                ),
                const Text('Name'),
                TextField(
                  controller: nameController,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Description'),
                TextField(
                  controller: descriptionController,
                  minLines: 1,
                  maxLines: 5,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text('Price'),
                TextField(
                  controller: priceController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text('Available number'),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        decrease();
                      },
                      child: const Icon(Icons.remove),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      itemCount.toString(),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        increase();
                      },
                      child: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Image',
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                  child: file.path == '-1'
                      ? Material(
                          shape: const CircleBorder(),
                          color: Colors.blue,
                          child: InkWell(
                            onTap: () {
                              onSelectImagePressed();
                            },
                            borderRadius: BorderRadius.circular(50),
                            child: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              radius: 50,
                              child: Icon(
                                Icons.add_a_photo,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.transparent,
                              backgroundImage: FileImage(file),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: () {
                                  onSelectImagePressed();
                                },
                                child: const CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                  child: const Text(' Categories'),
                  onPressed: () {
                    showMultiSelect(context);
                  },
                ),
                SingleChildScrollView(
                  child: Row(
                    children: [
                      for (int i = 0; i < selectedCategories.length; i++) ...[
                        Text(selectedCategories[i]),
                        if (i != selectedCategories.length - 1) ...[
                          const Text(', '),
                        ],
                      ]
                    ],
                  ),
                ),
                const SizedBox(
                  height: 40,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      onSubmitPressed();
                    },
                    child: const Text('Submit'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void showMultiSelect(BuildContext context) async {
    await showModalBottomSheet(
      isScrollControlled: true, // required for min/max child size
      context: context,
      builder: (ctx) {
        return MultiSelectBottomSheet(
          items: kCategories,
          onConfirm: (values) {
            setState(() {
              selectedCategories.clear();
              for (int i = 0; i < values.length; i++) {
                String each = values[i].toString();
                selectedCategories.add(each);
              }
            });
          },
          maxChildSize: 0.8,
          initialValue: [],
        );
      },
    );
  }

  increase() {
    setState(() {
      itemCount++;
    });
  }

  decrease() {
    if (itemCount <= 0) {
      return;
    }
    setState(() {
      itemCount--;
    });
  }

  bool validation(
      String uid, String name, String description, String priceString) {
    if (uid == '-1') {
      print('handle user authentication');
      return false;
    } //
    if (name.length < 3) {
      print('Name is too short');
      return false;
    } //
    if (description.length < 5) {
      print('description is too short');
      return false;
    } //
    if (priceString.length == 0) {
      print('enter price');
      return false;
    }
    if (selectedCategories.length == 0) {
      print('Select at least one category');
      return false;
    }
    if (itemCount == 0) {
      print('enter items count');
      return false;
    }
    return true;
  }

  void onSubmitPressed() async {
    String uid = auth.currentUser!.uid;
    String name = nameController.text;
    String description = descriptionController.text;
    String priceString = priceController.text;
    bool status = validation(uid, name, description, priceString);
    if (status == false) {
      print('not validate');
      return;
    }
    setState(() {
      showProgress = true;
    });
    int price = int.parse(priceString);
    String imagePath = '-1';
    if (file.path != '-1') {
      imagePath = await uploadItemImage();
    }
    Map<String, dynamic> itemMap = Map();
    itemMap['name'] = name;
    itemMap['uploader'] = uid;
    itemMap['description'] = description;
    itemMap['price'] = price;
    itemMap['count'] = itemCount;
    if (imagePath != '-1') {
      itemMap['image'] = imagePath;
    } else {
      itemMap['image'] = null;
    }
    itemMap['categories'] = selectedCategories;
    try {
      DocumentReference doc = await fireStore.collection('Items').add(itemMap);
      print('success uploading');
      print('added document id: ' + doc.id);
      showProgress = false;
      reSeter();
    } //
    catch (e) {
      setState(() {
        showProgress = false;
      });
      print('sth went wrong');
    }
  }

  Future<String> uploadItemImage() async {
    try{
      String filename = file.path.split('/').last;
      TaskSnapshot snapshot = await storage.ref().child('items/images/$filename').putFile(file);
      String url = await snapshot.ref.getDownloadURL();
      return url;
    }
    catch(e){
      print('error in image upload');
      print(e);
      return '-1';
    }

  }

  void onSelectImagePressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CustomAlertDialog(
          selectImageFromGallery: selectImageFromGallery,
          selectImageFromCamera: selectImageFromCamera,
        );
      },
    );
  }

  void selectImageFromGallery() async {
    print('gallery');
    bool status = await selectImageFunction(ImageSource.gallery);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  void selectImageFromCamera() async {
    print('camera');
    bool status = await selectImageFunction(ImageSource.camera);
    if (status == true) {
      Navigator.pop(context);
    }
  }

  Future<bool> selectImageFunction(ImageSource source) async {
    try {
      ImagePicker imagePicker = ImagePicker();
      final XFile pickedImage =
          await imagePicker.pickImage(source: source) ?? XFile('-1');
      print('---------------------------------------');
      print(pickedImage);
      print(pickedImage.path);
      print(pickedImage.name);
      if (pickedImage.path == '-1') {
        return false;
      }
      setState(() {
        file = File(pickedImage.path);
      });
      return true;
    } //
    catch (e) {
      print(e);
      return false;
    }
  }

  reSeter(){
    setState(() {
      nameController.clear();
      priceController.clear();
      descriptionController.clear();
      itemCount = 0;
      file = File('-1');
      selectedCategories.clear();
    });
  }

}
