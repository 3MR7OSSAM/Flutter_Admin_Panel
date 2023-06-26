import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grocery_admin_panel/responsive.dart';
import 'package:grocery_admin_panel/widgets/custom_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:uuid/uuid.dart';
import '../methods/showBtmAlert.dart';
import '../methods/show_alert.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/drop_down_menu.dart';
import '../widgets/onsale_widget.dart';
import '../widgets/radio_btns.dart';
import '../widgets/side_menu.dart';
class ProductUpload extends StatefulWidget {
  const ProductUpload({Key? key}) : super(key: key);
  @override
  State<ProductUpload> createState() => _ProductUploadState();
}

class _ProductUploadState extends State<ProductUpload> {
  GlobalKey<FormState> formKey = GlobalKey();
  String? name;
  double? price;
  XFile? image;
  Uint8List webImage = Uint8List(8);
  File? _pickedImage;
  String dropdownValue = 'vegetable';
  int? _selectedValue = 1;
  String unit = "KG";
  bool _isLoading = false;
  double? salePrice;
  bool showTextForm = false;
  bool isOnSale = false;
  final List<String> categories = ["vegetable","Fruits","Spices","Herbs","Nuts","Grains",];
  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;
    double FontSize = Size.width < 600 ? 14 : 20;
    return SafeArea(
      child: Scaffold(
          drawer: const SideMenu(),
          body: Builder(
            builder: (context) => SafeArea(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // We want this side menu only for large screen
                  if (Responsive.isDesktop(context))
                    const Expanded(
                      child: SideMenu(),
                    ),
                  Expanded(
                    flex: 5,
                    child: ModalProgressHUD(
                      inAsyncCall: _isLoading,
                      child: Padding(
                        padding: const EdgeInsets.all(25),
                        child: Center(
                          child: Container(
                            width: Size.width * 0.75,
                            height: Size.height * 0.63,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.grey.withOpacity(0.3)),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Upload Product ',
                                      style: TextStyle(
                                          fontSize: FontSize,
                                          fontWeight: FontWeight.bold,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? Size.width * 0.3
                                              : Size.width * 0.4,
                                          child: CustomTextField(
                                            hasIcon: false,
                                            hintText: 'Name',
                                            isNumber: false,
                                            onChanged: (data) {
                                              name = data.trim();
                                            },
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'Name is required';
                                              }
                                              return null;
                                            },
                                          )),
                                      SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? Size.width * 0.2
                                              : Size.width * 0.3,
                                          child: CustomTextField(
                                            hasIcon: false,
                                            hintText: '\$',

                                            inputType: TextInputType.number,
                                            isNumber: true,
                                            validator: (value) {
                                              if (value == null || value.isEmpty) {
                                                return 'price is required';
                                              }
                                              return null;
                                            },
                                            onChanged: (data) {
                                              if (data.trim().isNotEmpty) {
                                                price = double.parse(data.trim());
                                              } else {
                                                price = null;
                                              }

                                            },
                                          )),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Flexible(
                                          child: Column(
                                            children: [
                                              Text(
                                                'Product Category ',
                                                style: TextStyle(
                                                  fontSize: FontSize,
                                                ),
                                              ),
                                              MyDropdown(

                                                onChanged: (String? newValue) {
                                                  setState(() {
                                                    dropdownValue = newValue!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(height: 35),
                                              Text(
                                                'Measurement Unit',
                                                style: TextStyle(
                                                  fontSize: FontSize,
                                                ),
                                              ),
                                              RadioBtn(
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedValue = value;
                                                    if (_selectedValue == 1) {
                                                      unit = 'Kg';
                                                    } else {
                                                      unit = 'piece';
                                                    }
                                                  });
                                                },
                                              ),
                                              onSaleWidget(
                                                onChanged: (value) {
                                                  salePrice = double.parse(value);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: Size.width * 0.2,
                                        ),
                                        Flexible(
                                          child: Container(
                                            width: 200,
                                            height: 200,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.withOpacity(0.35),
                                                borderRadius: BorderRadius.circular(16)),
                                            child: _pickedImage != null
                                                ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                ClipRRect(
                                                  borderRadius: BorderRadius.circular(12),
                                                  child: kIsWeb
                                                      ? Image.memory(webImage,
                                                      width: 80, fit: BoxFit.fill)
                                                      : Image.file(_pickedImage!,
                                                      width: 80, fit: BoxFit.fill),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _pickedImage = null;
                                                      webImage = Uint8List(8);
                                                    });
                                                  },
                                                  child: const Text(
                                                    'Remove image',
                                                    style: TextStyle(color: Colors.red),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: _pickImage,
                                                  child: const Text(
                                                    'Upload another',
                                                    style: TextStyle(color: Colors.blue),
                                                  ),
                                                )
                                              ],
                                            )
                                                : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                  onPressed: _pickImage,
                                                  icon: const Icon(Icons.image_outlined),
                                                ),
                                                Center(
                                                    child: Column(
                                                      children: [
                                                        Column(
                                                          children: [
                                                            Text('Chose an image',
                                                                style: TextStyle(
                                                                  fontSize: FontSize,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CustomButon(
                                        text: 'Clear',
                                        icon: Icons.clear,
                                        color: Colors.red,
                                        onTap: () {
                                          final form = formKey.currentState;
                                          if (form != null && form.validate()) {
                                            form.reset();
                                          }
                                          setState(() {
                                            _pickedImage = null;
                                            webImage = Uint8List(8);

                                          });
                                        },
                                      ),
                                      CustomButon(
                                        text: 'Upload',
                                        icon: Icons.upload,
                                        onTap: () async {
                                          setState(() {
                                            _isLoading = true;
                                          });
                                          String? imageUrl;
                                          final form = formKey.currentState;
                                          if (form != null && form.validate()) {
                                            if (_pickedImage == null) {
                                              showBtmAlert(
                                                  context, 'please select a new image');
                                            } else {
                                              form.save();
                                              final _uuid = const Uuid().v4();
                                              try {
                                                final ref = FirebaseStorage.instance
                                                    .ref()
                                                    .child('userImages')
                                                    .child('$_uuid.jpg');
                                                if (kIsWeb) {
                                                  await ref.putData(webImage);
                                                } else {
                                                  await ref.putFile(_pickedImage!);
                                                }
                                                imageUrl = await ref.getDownloadURL();
                                                await FirebaseFirestore.instance
                                                    .collection('products')
                                                    .doc(_uuid)
                                                    .set({
                                                  'id': _uuid,
                                                  'name': name,
                                                  'price': price,
                                                  'unit': unit,
                                                  'imageUrl': imageUrl,
                                                  'salePrice': salePrice ?? 0.0 ,
                                                  'category': dropdownValue,
                                                  'createdAt': Timestamp.now(),
                                                });
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                                showAlertBar(context,'Product uploaded successfully !');
                                              } on FirebaseException catch (e) {
                                                showBtmAlert(context, e.message.toString());
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              } finally {
                                                setState(() {
                                                  _isLoading = false;
                                                });
                                              }
                                            }
                                          }
                                        },
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> _pickImage() async {
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var selected = File(image.path);
        setState(() {
          _pickedImage = selected;
        });
      } else {
        showBtmAlert(context, 'please select an image');
      }
    } else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          webImage = f;
          _pickedImage = File('a');
        });
      } else {
        showBtmAlert(context, 'please select an image');
      }
    } else {
      showBtmAlert(context, 'Something went wrong');
    }
  }
}
