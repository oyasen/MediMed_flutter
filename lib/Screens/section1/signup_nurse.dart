import 'dart:io';
import 'package:flutter/material.dart';
import 'package:medimed/Screens/section1/login_nurse.dart';
import 'package:medimed/Screens/section1/signin.dart';
import 'package:medimed/Screens/section1/validation.dart';
import 'package:medimed/provider/imageprovider.dart';
import 'package:medimed/provider/nurseprovider.dart';
import 'package:provider/provider.dart';
import '../../Widgets/form_widget.dart';

class SignupNurse extends StatefulWidget {
  const SignupNurse({super.key});

  @override
  State<SignupNurse> createState() => _SignupState();
}

class _SignupState extends State<SignupNurse> {
  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPass = TextEditingController();
  TextEditingController dob = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController spec = TextEditingController();
  TextEditingController loc = TextEditingController();

  String? gender;
  File? idCard;
  File? prof;
  File? grad;
  File? crim;
  File? pfp;
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var imageprovider = Provider.of<UploadProvider>(context, listen: false);
    var nurseProvider = Provider.of<NurseProvider>(context, listen: false);

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
                            CustomFormField(
                              label: "Specialization",
                              keyboardType: TextInputType.name,
                              controller: spec,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'Please enter Specialization';
                                }
                                return null;
                              },
                            ),
                            CustomFormField(
                              label: "Location",
                              keyboardType: TextInputType.name,
                              controller: loc,
                              validator: (text) {
                                if (text == null || text.trim().isEmpty) {
                                  return 'Please enter Location';
                                }
                                return null;
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Gender", style: TextStyle(fontSize: 16)),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text("Male"),
                                          value: "Male",
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value;
                                            });
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: RadioListTile<String>(
                                          title: const Text("Female"),
                                          value: "Female",
                                          groupValue: gender,
                                          onChanged: (value) {
                                            setState(() {
                                              gender = value;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               const Text("ID Card", style: TextStyle(fontSize: 16)),
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
                                      child: const Text("Pick Image"),
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
                            const SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Personal Picture", style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        File? selectedImage = await imageprovider.showOptions(context);
                                        if (selectedImage != null) {
                                          setState(() {
                                            pfp = selectedImage;
                                          });
                                        }
                                      },
                                      child: const Text("Pick Image"),
                                    ),
                                    Visibility(
                                      visible: pfp != null,
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                pfp = null;
                                              });
                                            },
                                            child: const Icon(Icons.delete, color: Colors.red),
                                          ),
                                          if (pfp != null)
                                            Center(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10), // Rounded corners
                                                child: Image.file(
                                                  pfp!,
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
                            const SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               const Text("Professional Practice License", style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        File? selectedImage = await imageprovider.showOptions(context);
                                        if (selectedImage != null) {
                                          setState(() {
                                            prof = selectedImage;
                                          });
                                        }
                                      },
                                      child:const Text("Pick Image"),
                                    ),
                                    Visibility(
                                      visible: prof != null,
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                prof = null;
                                              });
                                            },
                                            child: const Icon(Icons.delete, color: Colors.red),
                                          ),
                                          if (prof != null)
                                            Center(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10), // Rounded corners
                                                child: Image.file(
                                                  prof!,
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
                            const SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Graduation Certificate", style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        File? selectedImage = await imageprovider.showOptions(context);
                                        if (selectedImage != null) {
                                          setState(() {
                                            grad = selectedImage;
                                          });
                                        }
                                      },
                                      child:const Text("Pick Image"),
                                    ),
                                    Visibility(
                                      visible: grad != null,
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                grad = null;
                                              });
                                            },
                                            child: const Icon(Icons.delete, color: Colors.red),
                                          ),
                                          if (grad != null)
                                            Center(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10), // Rounded corners
                                                child: Image.file(
                                                  grad!,
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
                            const SizedBox(height: 5),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Criminal Record And Identification", style: TextStyle(fontSize: 16)),
                                Row(
                                  children: [
                                    ElevatedButton(
                                      onPressed: () async {
                                        File? selectedImage = await imageprovider.showOptions(context);
                                        if (selectedImage != null) {
                                          setState(() {
                                            crim = selectedImage;
                                          });
                                        }
                                      },
                                      child:const Text("Pick Image"),
                                    ),
                                    Visibility(
                                      visible: crim != null,
                                      child: Row(
                                        children: [
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                crim = null;
                                              });
                                            },
                                            child: const Icon(Icons.delete, color: Colors.red),
                                          ),
                                          if (crim != null)
                                            Center(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(10), // Rounded corners
                                                child: Image.file(
                                                  crim!,
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
                            const SizedBox(height: 5),
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
                            const SizedBox(height: 5),
                            ElevatedButton(
                              onPressed: () async {
                                if (formKey.currentState!.validate()) {
                                  if (gender == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        SnackBar(content: Text(
                                            "Please select gender"))
                                    );
                                    return;
                                  }

                                  if (idCard == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text(
                                              "Please select an ID Card image"))
                                      );
                                      return;
                                  }
                                  if (prof == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text(
                                              "Please select an Professional Practice License image")));
                                      return;
                                  }
                                  if (grad == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text(
                                              "Please select an Graduation Certificate image"))
                                      );
                                      return;
                                  }
                                  if (crim == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          SnackBar(content: Text(
                                              "Please select an Criminal Record And Identification image"))
                                      );
                                      return;
                                  }

                                    final idCardUrl = await imageprovider.uploadImageToCloudinary(idCard);
                                    final profUrl = await imageprovider.uploadImageToCloudinary(prof);
                                    final gradUrl = await imageprovider.uploadImageToCloudinary(grad);
                                    final crimUrl = await imageprovider.uploadImageToCloudinary(crim);
                                    final pfpUrl = await imageprovider.uploadImageToCloudinary(pfp);
                                    if (idCardUrl == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(
                                            "Image upload failed. Try again.")),
                                      );
                                      return;
                                    }
                                    if (profUrl == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(
                                            "Image upload failed. Try again.")),
                                      );
                                      return;
                                    }
                                    if (gradUrl == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(
                                            "Image upload failed. Try again.")),
                                      );
                                      return;
                                    }
                                    if (crimUrl == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(content: Text(
                                            "Image upload failed. Try again.")),
                                      );
                                      return;
                                    }
                                  if (pfpUrl == null) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                      SnackBar(content: Text(
                                          "Image upload failed. Try again.")),
                                    );
                                    return;
                                  }
                                    await nurseProvider.addNurse(
                                        fullName: fullName.text,
                                        email: email.text,
                                        password: password.text,
                                        contact: contact.text,
                                        grad: gradUrl,
                                        crim: crimUrl,
                                        idCard: idCardUrl,
                                        prof: profUrl,
                                        spec: spec.text,
                                        location: loc.text,
                                        gender: gender!,
                                        dob: dob.text,
                                        pfp: pfpUrl

                                    );
                                    if(nurseProvider.nurseAddModel?.id != 0) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Signin()),
                                      );
                                    }
                                  }
                                }
                              ,
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
                                MaterialPageRoute(builder: (context) => const SigninNurse()),
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
