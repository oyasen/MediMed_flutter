import 'package:flutter/material.dart';
import 'package:medimed/Screens/section1/signup.dart';
import 'Validation.dart';
import '../../Widgets/form_widget.dart';

class Forgetpass extends StatefulWidget {
  const Forgetpass({super.key});

  @override
  State<Forgetpass> createState() => _ForgetpassState();
}

class _ForgetpassState extends State<Forgetpass> {
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
                        'Forget Password',
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
                              label: "New Password",
                              controller: password,
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
                            ElevatedButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {}
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff8761ea),
                                ),
                                child: const Text(
                                  'Sign In',
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
                          const Text('Did not Joined Yey?'),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Signup(),
                                  ));
                            },
                            child: const Text(
                              'Sign Up',
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
