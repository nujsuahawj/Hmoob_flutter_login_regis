import 'package:firebase_auth/firebase_auth.dart';
// ignore: unused_import
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'package:flutter_login_regis/screen/home.dart';

class WelcomeScreen extends StatelessWidget {

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text("ໂປໄຟຣ"),),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: Column(
            children: [
                Text("ຍິນດີຕ້ອນຮັບ",style: TextStyle(fontSize: 40),),
                Text(""),
                Text("ການເຂົ້າສູ່ລະບົບຂອງທ່ານແມ່ນສຳເເລັດແລ້ວ",style: TextStyle(fontSize: 20),),
                Text(""),
                ElevatedButton(
                  child: Text("ອອກຈາກລະບົບ"),
                  onPressed: (){
                     auth.signOut().then((value){
                        Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context){
                            return HomeScreen();
                        }));
                     });
                  }, 
                )
            ],),
        ),
      ),
    );
  }
}