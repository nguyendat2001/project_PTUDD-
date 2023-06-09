import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:provider/provider.dart';
import '../../ui/admin/admin_screen.dart';
import '../../ui/auth/auth_register.dart';
import 'auth_register.dart';
import 'auth_manager.dart';
import '../../ui/products/products_overview_screen.dart';
import '../../models/http_exception.dart';
import '../shared/dialog_utils.dart';

  enum AuthMode { signup, login }

class AuthScreen extends StatefulWidget {

  static const routeName = '/auth';

  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  late String txtemail, txtpassword;
  
  AuthMode _authMode = AuthMode.login;

  final _isSubmitting = ValueNotifier<bool>(false);
  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    _isSubmitting.value = true;

    try {
      if (_authMode == AuthMode.login) {
        await context.read<AuthManager>().login(
              txtemail!,
              txtpassword!,
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
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage("https://images.pexels.com/photos/1031988/pexels-photo-1031988.jpeg?auto=compress&cs=tinysrgb&w=600"), 
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SingleChildScrollView(
                  child: Container(
                  padding: EdgeInsets.all(10.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.4,
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
                                  _login();
                                },
                                child: Text('Login'),
                                
                              ),
                            )
                          ],
                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) => NewRegister()));
                          },
                          child: Text('Create a new account'),
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





  String? validateEmail(String? email) {
    if(email!.isEmpty) {
      return 'Enter email address';
    } else {
      return null;
    }
  }

  String? validatePassword(String? password) {
    if(password!.isEmpty) {
      return 'Enter password';
    } else {
      return null;
    }
  }
}