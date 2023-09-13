import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:skype_application/pages/signup_page.dart';


class LoginPage extends StatefulWidget {
  final void Function()? onPressed;
  const LoginPage({super.key, required this.onPressed});


  @override
  State<LoginPage> createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {


  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  signInWithEmailAndPassword() async{
    try {
      setState(() {
        isLoading = true;
      });
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text,
          password: _password.text,
      );
      setState(() {
        isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      if (e.code == 'user-not-found') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("User not found"),
          ),
        );
      } else if (e.code == 'wrong-password') {
        return ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Wrong passord"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Login"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: OverflowBar(
              overflowSpacing: 20,
              children: [
              TextFormField(
                controller: _email,
                validator: (text){
                  if(text == null || text.isEmpty){
                    return 'Email is empty';
                  }
                  return null;
                },
                decoration: InputDecoration(labelText: "Email"),

                ),
                TextFormField(
                  controller: _password,
                  validator: (text){
                    if(text == null || text.isEmpty){
                      return 'Password is empty';
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Password"),


                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: (){
                      if(_formKey.currentState!.validate()){
                        signInWithEmailAndPassword();
                      }
                    },
                    child: isLoading ?
                          const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                          )
                        : Text("Login"),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: widget.onPressed,

                    child: Text("Signup"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



