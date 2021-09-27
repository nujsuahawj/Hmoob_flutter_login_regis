import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:flutter_login_regis/model/profile.dart';

import 'home.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  Profile profile = Profile(email: '', password: '');
  final Future<FirebaseApp> firebase = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: firebase,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Scaffold(
                appBar: AppBar(
                  title: Text("Error"),
                  ),
                body: Center(child: Text("${snapshot.error}"),
                ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return Scaffold(
              appBar: AppBar(
                title: Text("ສ້າງບັນຂີ"),
              ),
              body: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ອີເເມວ", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: MultiValidator([
                              RequiredValidator(errorText: "ກະລຸນາປ້ອນມີແມວ"),
                              EmailValidator(errorText: "ອີແມວບໍ່ຖຶກຕ້ອງ")
                            ]),
                            keyboardType: TextInputType.emailAddress,
                            onSaved: (email) {
                              profile.email = email!;
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text("ລະຫັດ", style: TextStyle(fontSize: 20)),
                          TextFormField(
                            validator: RequiredValidator(errorText: "ກະລຸນາປ້ອນລະຫັດຜານ"),
                              obscureText: true,
                              onSaved: (password) {
                              profile.password = password!;
                            },
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              child: Text("ລົງທະບຽນ",style: TextStyle(fontSize: 20)),
                              onPressed: () async{
                                if (formKey.currentState!.validate()) {
                                  formKey.currentState!.save();
                                  try{
                                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                                      email: profile.email, 
                                      password: profile.password
                                    ).then((value){
                                      formKey.currentState!.reset();
                                      Fluttertoast.showToast(
                                        msg: "ການລົງທະບຽນຂອງທານສຳເເລັດແລ້ວ",
                                        gravity: ToastGravity.TOP
                                      );
                                      Navigator.pushReplacement(context,
                                      MaterialPageRoute(builder: (context){
                                          return HomeScreen();
                                      }));
                                    });
                                  }on FirebaseAuthException catch(e){
                                      print(e.code);
                                      String message;
                                      if(e.code == 'email-already-in-use'){
                                          message = "ອີແມວບໍ່ຖຶກຕ້ອງ";
                                      }else if(e.code == 'weak-password'){
                                          message = "ລະຫັດຄວນມີ 6 ຕົວຂຶ້ນໄປ";
                                      }else{
                                          message = e.message!;
                                      }
                                      Fluttertoast.showToast(
                                        msg: message,
                                        gravity: ToastGravity.CENTER
                                      );
                                  }
                                }
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}
