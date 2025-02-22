import 'package:flutter/material.dart';
import 'package:medimed/Screens/Admin/nurses_admin.dart';
import 'package:medimed/provider/adminprovider.dart';
import 'package:provider/provider.dart';
import 'package:medimed/Screens/section1/validation.dart';
import '../../Widgets/form_widget.dart';

class LoginAdmin extends StatefulWidget {
  const LoginAdmin({super.key});

  @override
  State<LoginAdmin> createState() => _LoginAdminState();
}

class _LoginAdminState extends State<LoginAdmin> {
  TextEditingController fullName = TextEditingController();

  TextEditingController email = TextEditingController();

  TextEditingController password = TextEditingController();

  TextEditingController confirmPass = TextEditingController();

  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var adminProvider = Provider.of<Adminprovider>(context,listen: false);

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
                        'Sign In',
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
                              label: "Password",
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
                            SizedBox(height: 20,),
                            ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState!.validate()) {
                                    await adminProvider.loginAdmin(email.text, password.text);
                                    if (adminProvider.adminAddModel?.id == 0) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                          const SnackBar(content: Text(
                                              "Please Check you E-mail and Password"))
                                      );
                                      return;
                                    }
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SchedulePage(),
                                        ));
                                  }
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
