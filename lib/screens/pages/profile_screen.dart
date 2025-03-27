import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/controllers/location_controller.dart';
import 'package:multi_vendor/main_constant.dart';
import 'package:multi_vendor/models/user_model.dart';
import 'package:multi_vendor/widgets/remove_account_sheet.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _PersonalScreenState();
}

class _PersonalScreenState extends State<ProfileScreen> {
  late TextEditingController _email;
  late TextEditingController _phone;
  late TextEditingController _fullname;
  bool edit = false, loading = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final LocationController _locationController = Get.find(tag: 'location');
  final AccountController _accountController = Get.find(tag: 'account');
  @override
  void initState() {
    super.initState();
    if (_accountController.user != null) {
      _locationController.lat =
          double.tryParse(_accountController.user?.lat ?? '0.0') ?? 0.0;
      _locationController.lng =
          double.tryParse(_accountController.user?.lng ?? '0.0') ?? 0.0;
      _locationController.isInitallised =
          _locationController.lat != 0 && _locationController.lng != 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AccountController>(
        tag: 'account',
        builder: (accountController) {
          _phone = TextEditingController(
              text: "0${accountController.user?.phoneNumber ?? ""}");
          _email = TextEditingController(text: "aaaaaaaaaa");
          _fullname = TextEditingController(text: accountController.user?.name);

          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(),
            backgroundColor: Colors.white,
            body: accountController.user == null
                ? SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.login,
                          size: 100,
                          color: MAIN_COLOR.withOpacity(.8),
                        ),
                        Text(
                          "Login required".tr,
                          style: const TextStyle(
                              fontSize: 24,
                              color: MAIN_COLOR,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox.fromSize(
                          size: const Size.fromHeight(10),
                        ),
                        Text("Please login to view your profile".tr),
                        SizedBox.fromSize(
                          size: const Size.fromHeight(20),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Get.toNamed("/login_screen");
                            },
                            style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: Size(
                                    MediaQuery.sizeOf(context).width * 0.8, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                backgroundColor: MAIN_COLOR.withOpacity(.9)),
                            child: Text("Login".tr))
                      ],
                    ),
                  )
                : Form(
                    key: _formkey,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              "Personal Information".tr,
                              style: const TextStyle(
                                  fontSize: 24,
                                  color: MAIN_COLOR,
                                  fontWeight: FontWeight.bold),
                            ),
                            Container(
                              height: 90,
                              width: 90,
                              margin:
                                  const EdgeInsets.only(bottom: 25, top: 30),
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage("assets/icon.jpeg"),
                                      fit: BoxFit.cover)),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Fullname cannot be empty".tr;
                                  } else if (value.length < 3) {
                                    return "Fullname must be more than 3 character"
                                        .tr;
                                  }
                                  return null;
                                },
                                controller: _fullname,
                                readOnly: !edit,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.person,
                                        color: Colors.black),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13))),
                              ),
                            ),
                            SizedBox.fromSize(
                              size: const Size.fromHeight(10),
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: TextFormField(
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value?.isEmpty ?? true) {
                                    return "number must be not empty".tr;
                                  } else if (value!.length < 10) {
                                    return "number must be 10 character".tr;
                                  }
                                  return null;
                                },
                                controller: _phone,
                                readOnly: !edit,
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.call,
                                        color: Colors.green),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(13))),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.9,
                              child: TextField(
                                onTap: () {
                                  if (edit) {
                                    Get.toNamed('location_screen');
                                  }
                                },
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: "Edit votre localisation".tr,
                                  prefixIcon: const Icon(
                                    Icons.location_on,
                                    color: MAIN_COLOR,
                                  ),
                                  suffixIcon: const Icon(
                                    Icons.edit,
                                    color: Colors.black54,
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(13),
                                    borderSide:
                                        const BorderSide(color: Colors.green),
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: false,
                              child: Container(
                                margin: const EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: TextFormField(
                                  onTap: () => Get.toNamed('/reset_screen'),
                                  controller: _email,
                                  obscureText: true,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                          onPressed: () async {},
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.black45,
                                          )),
                                      prefixIcon: const Icon(Icons.lock,
                                          color: Colors.blueAccent),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(13))),
                                ),
                              ),
                            ),
                            SizedBox.fromSize(
                              size: const Size.fromHeight(20),
                            ),
                            Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    maximumSize: Size(
                                        (MediaQuery.of(context).size.width *
                                            0.9),
                                        50),
                                    minimumSize: Size(
                                        (MediaQuery.of(context).size.width *
                                            0.9),
                                        (50)),
                                    backgroundColor: MAIN_COLOR.withOpacity(.9),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          12), // Change this value for a different radius
                                    ),
                                  ),
                                  onPressed: () async {
                                    if (edit == false) {
                                      setState(() {
                                        edit = true;
                                      });
                                    } else if (_formkey.currentState!
                                        .validate()) {
                                      if (_locationController.isInitallised) {
                                        setState(() {
                                          edit = false;
                                          loading = true;
                                        });

                                        accountController.user?.lat =
                                            _locationController.lat.toString();
                                        accountController.user?.lng =
                                            _locationController.lng.toString();

                                        accountController.user?.name =
                                            _fullname.text;
                                        accountController.user?.phoneNumber =
                                            int.parse(_phone.text.substring(
                                                1, _phone.text.length));
                                        await accountController.updateProfile();
                                        setState(() {
                                          loading = false;
                                        });
                                      } else {
                                        Get.showSnackbar(GetSnackBar(
                                          backgroundColor: Colors.redAccent,
                                          title: "Error".tr,
                                          message: "Pick location first".tr,
                                        ));
                                      }
                                    }
                                  },
                                  child: loading
                                      ? const SizedBox(
                                          height: 15,
                                          width: 15,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              edit ? "Save".tr : "Edit".tr,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 19),
                                            ),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Icon(
                                              edit
                                                  ? Icons.check
                                                  : Icons.create_outlined,
                                              color: Colors.white,
                                            )
                                          ],
                                        )),
                            ),
                            Visibility(
                              visible: edit && !loading,
                              child: Container(
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(top: 15),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      maximumSize: Size(
                                          (MediaQuery.of(context).size.width *
                                              0.9),
                                          50),
                                      minimumSize: Size(
                                          (MediaQuery.of(context).size.width *
                                              0.9),
                                          (50)),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                            width: 1,
                                            color: Colors.redAccent
                                                .withOpacity(.8)),
                                        borderRadius: BorderRadius.circular(
                                            12), // Change this value for a different radius
                                      ),
                                    ),
                                    onPressed: () {
                                      // _fullname.text = _accountController.information.value.fullname;
                                      // _email.text = _accountController.information.value.email;
                                      // _phone.text =  _accountController.information.value.number;

                                      setState(() {
                                        edit = false;
                                      });
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Cancell".tr,
                                          style: TextStyle(
                                              color: Colors.black
                                                  .withOpacity(.6)
                                                  .withOpacity(.81),
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Icon(
                                          Icons.close,
                                          color: Colors.black.withOpacity(.6),
                                          size: 20,
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      (MediaQuery.of(context).size.width *
                                          0.03)),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    maximumSize: Size(
                                        (MediaQuery.of(context).size.width *
                                            0.88),
                                        48),
                                    minimumSize: Size(
                                        (MediaQuery.of(context).size.width *
                                            0.7),
                                        (48)),
                                    side: BorderSide(
                                        width: 1, color: Colors.redAccent),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1, color: Colors.green),
                                      borderRadius: BorderRadius.circular(
                                          12), // Change this value for a different radius
                                    ),
                                  ),
                                  onPressed: () async {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                          const DeleteAccountDialog(),
                                    ).then((deleted) {
                                      if (deleted ?? false) {
                                        // Handle account deletion
                                      }
                                    });
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Remove my account'.tr,
                                        style: TextStyle(
                                            color: Colors.redAccent
                                                .withOpacity(.6)
                                                .withOpacity(.81),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.delete,
                                        color: Colors.redAccent.withOpacity(.6),
                                        size: 20,
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              padding: EdgeInsets.symmetric(
                                  horizontal:
                                      (MediaQuery.of(context).size.width *
                                          0.03)),
                              child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    maximumSize: Size(
                                        (MediaQuery.of(context).size.width *
                                            0.88),
                                        48),
                                    minimumSize: Size(
                                        (MediaQuery.of(context).size.width *
                                            0.7),
                                        (48)),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          width: 1,
                                          color:
                                              Colors.redAccent.withOpacity(.8)),
                                      borderRadius: BorderRadius.circular(
                                          12), // Change this value for a different radius
                                    ),
                                  ),
                                  onPressed: () async {
                                    await accountController.Logout();
                                    Get.offAllNamed("/accuel_screen");
                                  },
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Logout".tr,
                                        style: TextStyle(
                                            color: Colors.black
                                                .withOpacity(.6)
                                                .withOpacity(.81),
                                            fontWeight: FontWeight.w500,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.logout,
                                        color: Colors.black.withOpacity(.6),
                                        size: 20,
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          );
        });
  }
}
