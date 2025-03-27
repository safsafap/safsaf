import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_vendor/controllers/account_controller.dart';
import 'package:multi_vendor/main_constant.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  bool _isObscure3 = true;
  //bool visible = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoading = false;
  late AccountController accountController;

  @override
  void initState() {
    super.initState();
  }

  _loginUsers() async {
    if (_formkey.currentState!.validate()) {
      accountController = Get.find<AccountController>(tag: "account");

      await accountController.login(
          number: emailController.text.substring(1),
          password: passwordController.text);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.transparent,
      ),
      body: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Text(
                "Welcome back !".tr,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 36,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "Enter ur email and password to continue".tr,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.grey[500],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  validator: (value) =>
                      value!.length == 10 ? null : 'max length 10'.tr,
                  controller: emailController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.call),
                    prefixIconColor: Colors.black54,
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Number'.tr,
                    enabled: true,
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 12.0, top: 12.0),
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure3,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    prefixIconColor: Colors.black54,
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure3
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure3 = !_isObscure3;
                          });
                        }),
                    filled: true,
                    hintText: 'Password'.tr,
                    enabled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    contentPadding: const EdgeInsets.only(
                        left: 14.0, bottom: 12.0, top: 12.0),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'password must not be empty ';
                    } else {
                      return null;
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              //forget mot de passe
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/reset_screen');
                      },
                      child: Text(
                        'Forgot password ?'.tr,
                        style:
                            TextStyle(color: Color.fromRGBO(36, 36, 36, 0.5)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  setState(() {
                    _isLoading = true;
                  });
                  _formkey.currentState?.save();
                  _loginUsers();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 40,
                  height: 46,
                  decoration: BoxDecoration(
                    color: MAIN_COLOR,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            height: 15,
                            width: 15,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            "Login".tr,
                            style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.grey[400],
                ),
              ),

              const SizedBox(height: 10),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: MAIN_COLOR),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fixedSize:
                          Size(MediaQuery.sizeOf(context).width * .9, 50)),
                  onPressed: () {
                    Get.toNamed("/signup_screen");
                  },
                  child: Text(
                    'create account'.tr,
                    style: TextStyle(
                        fontSize: 18,
                        color: MAIN_COLOR,
                        fontWeight: FontWeight.bold),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
