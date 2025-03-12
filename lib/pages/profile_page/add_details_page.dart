import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/profile_page/_components/profile_image_picker.dart';
import '../../pages/profile_page/_components/profile_text_field.dart';
import '../../utils/extensions/color.dart';
import '../../models/user.dart';
import '../../utils/assets.dart';
import '../../utils/constants.dart';

class AddDetailsPage extends StatefulWidget {
  const AddDetailsPage({super.key});

  @override
  State<AddDetailsPage> createState() => _AddDetailsPageState();
}

class _AddDetailsPageState extends State<AddDetailsPage> {
  final TextEditingController nameEditingController = TextEditingController();
  final TextEditingController dateEditingController = TextEditingController();
  final TextEditingController genderEditingController = TextEditingController();
  final TextEditingController bioEditingController = TextEditingController();

  File? image;
  User? user;

  @override
  void initState(){
    super.initState();
    _loadUserData();
  }

  void _updateImage(File? newImage) {
    setState(() {
      image = newImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : HexColor.fromHex(AppConstants.primaryColor),
        title: Text("User Profile", style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),),
        // foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              color: Theme.of(context).brightness == Brightness.dark ? Colors.black : HexColor.fromHex(AppConstants.primaryColor),
              padding: EdgeInsets.only(left: 25.0, bottom: 45.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      ProfileImagePicker(image: image, defaultImagePath: user?.imagePath ?? Assets.profilePA, onImagePicked: _updateImage,),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.grey.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(100)
                          ),
                          child: Icon(FontAwesomeIcons.penToSquare, size: 15,),
                        ),
                      )
                    ],
                  ),
                  SizedBox(width: 15,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 35,),
                      Text(user?.name ?? "Username", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                      ),),
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 210,
                        child: Text(user?.bio ?? "Bio", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withValues(alpha: 0.6) : Colors.black.withValues(alpha: 0.6)
                        ),
                          textAlign: TextAlign.start,
                        overflow: TextOverflow.ellipsis,),
                      )
                    ],
                  )
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 55.0, top: 25.0, right: 55.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Personal Details", style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18
                  ),),
                  SizedBox(height: 20,),
                  ProfileTextField(hint: "John Doe", label: "Name", prefixIcon: Icons.account_circle_outlined, textEditingController: nameEditingController,),
                  SizedBox(height: 20,),
                  ProfileTextField(hint: "31/1/2025", label: "Date Of Birth", prefixIcon: Icons.calendar_month,isCalendar: true, textEditingController: dateEditingController,),
                  SizedBox(height: 20,),
                  ProfileTextField(label: "Gender", prefixIcon: Icons.perm_identity_rounded,textEditingController: genderEditingController, isDropdown: true, options: ["Male", "Female", "Other"],),
                  SizedBox(height: 20,),
                  ProfileTextField(label: "Bio", prefixIcon: Icons.contact_page_outlined,textEditingController: bioEditingController, isMultiLine: true,),
                  SizedBox(height: 30,),
                  InkWell(
                    onTap: () {
                      String name = nameEditingController.text == "" ? "Username" : nameEditingController.text;
                      DateTime dateOfBirth = _parseDate(dateEditingController.text);
                      String gender = genderEditingController.text;
                      String bio = bioEditingController.text == "" ? "Your Designation" : bioEditingController.text;
                      String? imagePath = image?.path ?? user?.imagePath ?? Assets.profilePA;

                      User updatedUser = User(
                        name: name,
                        bio: bio,
                        gender: gender,
                        birthdate: dateOfBirth,
                        imagePath: imagePath,
                      );

                      String userJson = jsonEncode(updatedUser.toJson());
                      saveUserToLocal(userJson);

                      Navigator.pop(context, true);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: HexColor.fromHex(AppConstants.primaryColor)
                      ),
                      child: Center(
                        child: Text("Submit", style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black
                        ),)
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Text("or", style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                    )),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap:(){
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,
                                    width: 2
                                )
                            ),
                            child: Center(
                              child: Text("Cancel", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black
                              ))
                            ),
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3.5,
                            height: 45,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: HexColor.fromHex(AppConstants.primaryColor)
                            ),
                            child: Center(
                              child: Text("Login", style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black
                              ))
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  DateTime _parseDate(String dateOfBirth) {
    DateFormat dateFormat = DateFormat('dd/MM/yyyy');
    try {
      return dateFormat.parse(dateOfBirth);
    } catch (e) {
      return DateTime.now();
    }
  }

  Future<void> saveUserToLocal(String userJson) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user', userJson);
  }

  Future<void> getUserFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userJson = prefs.getString('user');
    if (userJson != null) {
      Map<String, dynamic> userMap = jsonDecode(userJson);

      setState(() {
        user = User.fromJson(userMap);
        nameEditingController.text = user!.name!;
        genderEditingController.text = user!.gender!;
        bioEditingController.text = user!.bio!;
        dateEditingController.text = DateFormat('dd/MM/yyyy').format(user!.birthdate ?? DateTime.now());
      });
    }
  }

  Future<void> _loadUserData() async {
    await getUserFromLocal();
  }

}
