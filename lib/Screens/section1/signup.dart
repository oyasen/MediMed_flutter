import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medimed/Screens/section1/signin.dart';
import 'package:medimed/Screens/section1/validation.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/patientprovider.dart';
import 'package:provider/provider.dart';
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
  TextEditingController dob = TextEditingController();
  TextEditingController contact = TextEditingController();

  File? idCard;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);
    var patientProvider = Provider.of<PatientProvider>(context, listen: false);

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
                  padding: const EdgeInsets.only(left: 18.0, top: 20, right: 18),
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
                                  return 'Please enter full name';
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
                                  return 'Please enter Email';
                                }
                                if (!isValidEmail(text)) {
                                  return 'Invalid email format';
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
                                  return 'Please enter a password';
                                }
                                if (!isValidPass(text)) {
                                  return 'Password format is incorrect';
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
                                  return 'Please confirm your password';
                                }
                                if (password.text != text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            CustomFormField(
                              label: "Date Of Birth",
                              keyboardType: TextInputType.datetime,
                              controller: dob,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'Please enter Date of Birth';
                                }
                                return null;
                              },
                            ),
                            CustomFormField(
                              label: "Phone Number",
                              keyboardType: TextInputType.number,
                              controller: contact,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'Please enter Phone Number';
                                }
                                if (!isValidContact(text)) {
                                  return 'Invalid phone number';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID Card", style: TextStyle(fontSize: 16)),
                                  Row(
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          File? selectedImage = await imageprovider.showOptions(context);
                                          if (selectedImage != null) {
                                            setState(() {
                                              idCard = selectedImage;
                                            });
                                          }
                                        },
                                        child: Text("Pick Image"),
                                      ),
                                      Visibility(
                                        visible: idCard != null,
                                        child: Row(
                                          children: [
                                            TextButton(
                                              onPressed: () {
                                                setState(() {
                                                  idCard = null;
                                                });
                                              },
                                              child: const Icon(Icons.delete, color: Colors.red),
                                            ),
                                            if (idCard != null)
                                              Center(
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(10), // Rounded corners
                                                  child: Image.file(
                                                    idCard!,
                                                    width: 50, // Adjust size as needed
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'By signing up, you agree to our',
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
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (idCard == null) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Please select an ID Card image"))
                                    );
                                    return;
                                  }

                                  final imageUrl = await imageprovider.uploadImageToCloudinary(idCard);

                                  if (imageUrl != null) {
                                    // Call provider to add patient

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => Signin()),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("Image upload failed. Try again.")),
                                    );
                                  }
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
                              ),
                            ),
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
                                MaterialPageRoute(builder: (context) => const Signin()),
                              );
                            },
                            child: const Text(
                              'Sign In',
                              style: TextStyle(
                                color: Color(0xff74b2cd),
                              ),
                            ),
                          )
                        ],
                      ),
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
