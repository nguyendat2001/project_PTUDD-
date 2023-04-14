import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'auth_screen.dart';
import 'package:provider/provider.dart';

import 'auth_manager.dart';
import '../../ui/products/products_overview_screen.dart';
import '../../models/http_exception.dart';
import '../shared/dialog_utils.dart';


  enum AuthMode { signup, login }

class NewRegister extends StatefulWidget{
  static const routeName = '/register';

  const NewRegister({super.key});

  @override
  State<NewRegister> createState() => _NewRegister();
  
}

class _NewRegister extends State<NewRegister>{

final GlobalKey<FormState> _formKey = GlobalKey();
late String txtname, txtemail, txtpassword, txtrole='user';
 AuthMode _authMode = AuthMode.signup;


  final _isSubmitting = ValueNotifier<bool>(false);
  Future<void> _saveItem() async {

    if (!_formKey.currentState!.validate()) {
      return ;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.signup) {
        // Log user in
        await context.read<AuthManager>().signup(
              txtname!,
              txtemail!,
              txtpassword!,
              txtrole!,
            );
      } 
    } catch (error) {
      showErrorDialog(
          context,
          (error is HttpException)
              ? error.toString()
              : 'Authentication failed');
    }

    _isSubmitting.value = false;
  }

  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.people,
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Name'
                          ),
                          onSaved: (value){
                            txtname = value!;
                          },
                          validator: validateName,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.email,
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Email'
                          ),
                          onSaved: (value){
                            txtemail = value!;
                          },
                          validator: validateEmail,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Icon(
                                Icons.lock,
                                color: Colors.black,
                              ),
                            ),
                            labelText: 'Password'
                          ),
                          onSaved: (value){
                            txtpassword = value!;
                          },
                          validator: validatePassword,
                          obscureText: true,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: (){
                                  if(_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                  }
                                    _saveItem();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) => const ProductsOverviewScreen()),
                                      );
                                },
                                child: Text('Sign Up'),
                                
                              ),
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen()));
                          },
                          child: Text('Login'),
                        ),
                      ],
                    ),
                  ),
                  ),
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.blue,
  //       title: Text('Create a new account'),
  //     ),
  //     body: SingleChildScrollView(
  //       child: Container(
  //       padding: EdgeInsets.all(10.0),
  //       child: Form(
  //         key: _formKey,
  //         child: Column(
  //         children: [
  //           TextFormField(
  //             decoration: InputDecoration(
  //               labelText: 'Name'
  //             ),
  //             onSaved: (value){
  //               txtname = value!;
  //             },
  //             validator: validateName,
  //           ),
  //           TextFormField(
  
  //             decoration: InputDecoration(
  //               labelText: 'Email'
  //             ),
  //             onSaved: (value){
  //               txtemail = value!;
  //             },
  //             validator: validateEmail,
  //           ),
  //           TextFormField(

  //             decoration: InputDecoration(
  //               labelText: 'Password'
  //             ),
  //             onSaved: (value){
  //               txtpassword = value!;
  //             },
  //             validator: validatePassword,
  //           ),
  //           Row(
  //             children: [
  //               Expanded(
  //                 child: ElevatedButton(
  //                   onPressed: (){

  //                   },
  //                   child: Text('Reset'),
                                
  //                 ),
  //               ),
  //               Expanded(
  //                 child: ElevatedButton(
  //                   onPressed: (){
  //                     if(_formKey.currentState!.validate()) {
  //                       _formKey.currentState!.save();
  //                       _saveItem();
                        
  //                     }
  //                   },
  //                   child: Text('Sign up'),
                                
  //                 ),
  //               )
  //             ],
  //           ),
  //         ],
  //       ),
  //       ),
  //     ),
  //     ),
  //   );
  // }

  String? validateName(String? name) {
    if(name!.isEmpty) {
      return 'Enter your name';
    }
    else {
      return null;
    }
  }

  String? validateEmail(String? email) {
    if(email!.isEmpty) {
      return 'Enter your email';
    }
    else {
      return null;
    }   
  }

  String? validatePassword(String? password) {
    if(password!.isEmpty) {
      return 'Enter your password';
    }
    else {
      return null;
    }  
  }
}