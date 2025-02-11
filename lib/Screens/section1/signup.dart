import 'package:flutter/material.dart';
import 'package:medimed/Screens/section1/signin.dart';
import 'Validation.dart';
import '../../Widgets/form_widget.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confirmPass = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/landingAndLogo.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 350, right: 20, left: 20),
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0xffe4f2f3),
                    borderRadius: BorderRadius.all(
                      Radius.circular(40),
                    )),
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 18.0, top: 20, right: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
                        ),
                      ),
                      Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            CustomFormField(
                              label: "Full Name",
                              controller: fullName,
                              keyboardType: TextInputType.name,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'plz, enter full name';
                                }
                                return null;
                              },
                            ),
                            CustomFormField(
                              label: "E-mail",
                              keyboardType: TextInputType.emailAddress,
                              controller: email,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'plz, enter Email';
                                }
                                if (!isValidEmail(text)) {
                                  return 'Bad format';
                                }
                                return null;
                              },
                            ),
                            CustomFormField(
                              label: "Password",
                              controller: password,
                              icon: const Icon(Icons.password),
                              keyboardType: TextInputType.visiblePassword,
                              obsecure: true,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'plz, enter pass';
                                }
                                if (!isValidPass(text)) {
                                  return 'Bad format';
                                }
                                return null;
                              },
                            ),
                            CustomFormField(
                              label: "Confirm Password",
                              controller: confirmPass,
                              obsecure: true,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'plz, enter confirm pass';
                                }
                                if (password.text != text) {
                                  return 'confirm password does not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'By Signing up, You’re agree to our',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      ' Terms & Conditions',
                                      style: TextStyle(
                                          color: Color(0xff74b2cd),
                                          fontSize: 10),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'and',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                    Text(
                                      ' Privacy Policy',
                                      style: TextStyle(
                                          color: Color(0xff74b2cd),
                                          fontSize: 10),
                                    ),
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(height: 10),
                            ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Signin(),));
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8761ea),
                                ),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Joined Us Before?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signin(),
                                  ));
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xff74b2cd),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
