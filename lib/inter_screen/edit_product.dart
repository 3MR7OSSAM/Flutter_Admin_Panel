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
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import '../methods/showBtmAlert.dart';
import '../methods/show_alert.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/drop_down_menu.dart';
import '../widgets/onsale_widget.dart';
import '../widgets/radio_btns.dart';
import '../widgets/side_menu.dart';
class ProductEdit extends StatefulWidget {
  const ProductEdit({Key? key, required this.name, required this.price, required this.salePrice, required this.unit, required this.productCat, required this.id, required this.imageUrl}) : super(key: key);
  final String name;
  final double price;
  final double salePrice;
  final String unit;
  final String productCat;
  final String id;
  final String? imageUrl;

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  GlobalKey<FormState> formKey = GlobalKey();
  String? newName;
  double? newPrice;
  double? newSalePrice;
  XFile? image;
  Uint8List webImage = Uint8List(8);
  File? _pickedImage;
  late String dropdownValue = widget.productCat;
  int? _selectedValue ;
  String unit = "KG";
  bool _isLoading = false;
  bool showTextForm = false;
  bool isOnSale = false;
  final List<String> categories = ["vegetable","Fruits","Spices","Herbs","Nuts","Grains",];
  @override
  Widget build(BuildContext context) {
    var Size = MediaQuery.of(context).size;
    double FontSize = Size.width < 600 ? 14 : 20;
    return Scaffold(
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
            child:  ModalProgressHUD(
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
                              'Edit Product ',
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
                                    controller: TextEditingController(text: widget.name),
                                    hasIcon: false,
                                    hintText: 'Name',
                                    isNumber: false,
                                    onChanged: (data) {
                                      newName = data.trim();
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
                                    controller: TextEditingController(text: widget.price.toString()),
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
                                        newPrice = double.parse(data.trim());
                                      } else {
                                        newPrice = null;
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
                                      DropdownButton<String>(
                                        dropdownColor:
                                        Theme.of(context).scaffoldBackgroundColor,
                                        focusColor:
                                        Theme.of(context).scaffoldBackgroundColor,
                                        value: dropdownValue,
                                        onChanged: (String? newValue) {
                                          dropdownValue = newValue!;
                                        },
                                        items: <String>[
                                          "vegetable",
                                          "Fruits",
                                          "Spices",
                                          "Herbs",
                                          "Nuts",
                                          "Grains",
                                        ].map<DropdownMenuItem<String>>((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(value),
                                          );
                                        }).toList(),
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
                                          if(widget.productCat == 'Kg'){
                                            _selectedValue =1;
                                          }else{
                                            _selectedValue =2;
                                          }
                                          _selectedValue = value;
                                          if (_selectedValue == 1) {
                                            unit = 'Kg';
                                          } else {
                                            unit = 'piece';
                                          }
                                        },
                                      ),
                                      SizedBox(
                                          width: Responsive.isDesktop(context)
                                              ? Size.width * 0.2
                                              : Size.width * 0.3,
                                          child: CustomTextField(
                                            controller: TextEditingController(text: widget.salePrice.toString()),
                                            hasIcon: false,
                                            hintText: 'sale price',
                                            inputType: TextInputType.number,
                                            isNumber: true,
                                            onChanged: (data) {
                                              if (data.trim().isNotEmpty) {
                                                newSalePrice = double.parse(data.trim());
                                              } else {
                                                newSalePrice = null;
                                              }

                                            },
                                          )),
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
                                          onPressed: _pickImage,
                                          child: const Text(
                                            'Choice another',
                                            style: TextStyle(color: Colors.blue),
                                          ),
                                        ),
                                      ],
                                    )
                                        : Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Expanded(child: Image.network(widget.imageUrl!)),
                                        Center(
                                            child: Column(
                                              children: [
                                                Column(
                                                  children: [
                                                    TextButton(
                                                      onPressed: _pickImage,
                                                      child: const Text(
                                                        'Choice another',
                                                        style: TextStyle(color: Colors.blue),
                                                      ),
                                                    )
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
                                text: 'Delete',
                                icon: Icons.delete,
                                color: Colors.red,
                                onTap: () async {
                                  await FirebaseFirestore.instance.collection('products').doc(widget.id).delete();
                                  Navigator.pop(context);
                                },
                              ),
                              CustomButon(
                                text: 'Demise',
                                icon: Icons.clear,
                                color: Colors.orange,
                                onTap: () {
                                  final form = formKey.currentState;
                                  if (form != null && form.validate()) {
                                    form.reset();
                                    Navigator.pop(context);
                                  }
                                  setState(() {
                                    newName = widget.name;
                                    newPrice = widget.price;
                                    newSalePrice = widget.salePrice;
                                    _pickedImage = null;
                                    webImage = Uint8List(8);
                                  });
                                },
                              ),
                              CustomButon(
                                text: 'Edit',
                                icon: Icons.save,
                                onTap: () async {
                                  setState(() {
                                    _isLoading = true;
                                  });
                                  String image='';
                                  if (_pickedImage != null) {
                                    final _uuid = const Uuid().v4();
                                    try {
                                      final ref = FirebaseStorage.instance.ref()
                                          .child('userImages')
                                          .child('$_uuid.jpg');
                                      if (kIsWeb) {
                                        await ref.putData(webImage);
                                      } else {
                                        await ref.putFile(_pickedImage!);
                                      }
                                      image = await ref.getDownloadURL();
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      showBtmAlert(context , e.toString());
                                    }
                                  }else {
                                    image = widget.imageUrl.toString();
                                  }
                                  await FirebaseFirestore.instance.collection('products').doc(widget.id).update({
                                    'name':newName??widget.name,
                                    'price':newPrice??widget.price,
                                    'category':dropdownValue,
                                    'imageUrl':image,
                                    'salePrice':newSalePrice??widget.salePrice,
                                    'unit':unit,
                                  });
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  showAlertBar(context,'Edited successfully');
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
      )));
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
