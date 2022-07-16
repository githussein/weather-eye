import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../providers/Auth.dart';
import 'bottom_nav_bar.dart';
import 'forgot_pass_screen.dart';
import 'register_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreen();
}

class _SignInScreen extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  final _emailController = TextEditingController(text: '');
  final _passwordController = TextEditingController(text: '');
  bool _isLoading = false;
  late GoogleSignInAccount _userObject;
  bool _isGoogleSigningIn = false;
  bool _isFacebookSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تسجيل الدخول',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, size: 30),
            onPressed: () => Navigator.of(context).pop(),
          ),
          elevation: 0,
          centerTitle: false,
          backgroundColor: const Color(0xff426981),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textDirection: TextDirection.ltr,
                    decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintStyle: TextStyle(fontSize: 18),
                        hintText: 'البريد الالكتروني',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(1)),
                        )),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty ||
                            !value.contains('@') ||
                            !value.contains('.')) {
                          return 'برجاء إدخال البريد الالكتروني';
                        }
                        return null;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    controller: _passwordController,
                    textDirection: TextDirection.ltr,
                    obscureText: true,
                    decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.symmetric(horizontal: 16),
                        hintStyle: TextStyle(fontSize: 18),
                        hintText: 'كلمة المرور',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(1)),
                        )),
                    validator: (value) {
                      if (value != null) {
                        if (value.isEmpty) {
                          return 'كلمة المرور غير صحيحة';
                        }
                        return null;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPassScreen())),
                  child: const Text(
                    'نسيت كلمة المرور؟',
                    textAlign: TextAlign.right,
                    style: TextStyle(color: Color(0xff814269)),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 26)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff814269)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                            // side: BorderSide(color: Colors.red),
                          ))),
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          _email = _emailController.text;
                          _password = _passwordController.text;

                          setState(() => _isLoading = true);
                          try {
                            var statusCode =
                                await Provider.of<Auth>(context, listen: false)
                                    .signIn(_email, _password);

                            if (statusCode == 200) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.green.shade500,
                                  content: const Text('تم تسجيل الدخول بنجاح'),
                                ),
                              );

                              // Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) =>
                              //             const BottomAppBar()));
                              Navigator.popUntil(
                                  context, (route) => route.isFirst);
                              // Navigator.of(context)
                              //     .pushNamed(BottomNavBar.routeName);
                            } else if (statusCode == 404) {
                              if (!mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Colors.deepPurple,
                                  content: Text(
                                      'البريد الإلكرتوني أو رمز الدخول غير صحيح.'),
                                ),
                              );
                            }
                          } catch (error) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: Colors.deepPurple,
                                content: const Text(
                                    'فشل تسجيل الدخول. تحقق من الاتصال بالانترنت.'),
                              ),
                            );
                          }
                          setState(() => _isLoading = false);
                        }
                      },
                      child: _isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : const Text('تسجيل الدخول',
                              style: TextStyle(fontSize: 20))),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    const Text('أو', style: TextStyle(color: Colors.black)),
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: TextButton.icon(
                      icon: const ImageIcon(
                        AssetImage('assets/icon/facebook.png'),
                        size: 26,
                        color: Colors.white,
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 26)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xff1976D2)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            // side: BorderSide(color: Colors.red),
                          ))),
                      onPressed: () async {
                        setState(() => _isFacebookSigningIn = true);
                        try {
                          await Provider.of<Auth>(context, listen: false)
                              .signInWithFacebook();

                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.green.shade500,
                              content: const Text('تم تسجيل الدخول بنجاح'),
                            ),
                          );

                          Navigator.popUntil(context, (route) => route.isFirst);
                          // Navigator.of(context)
                          //     .pushNamed(BottomNavBar.routeName);
                        } catch (error) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.deepPurple,
                              content: Text(
                                  'فشل تسجيل الدخول. تحقق من الاتصال بالانترنت.'),
                            ),
                          );
                        }
                        setState(() => _isFacebookSigningIn = false);
                      },
                      label: const Text('تسجيل بواسطة الفيسبوك',
                          style: TextStyle(fontSize: 16))),
                ),
                SizedBox(
                  width: 300,
                  child: TextButton.icon(
                      icon: const Image(
                        image: AssetImage('assets/icon/google.png'),
                        height: 26,
                      ),
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(horizontal: 26)),
                          foregroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.white),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Color(0xff167EE6)),
                          ))),
                      onPressed: () async {
                        setState(() => _isGoogleSigningIn = true);
                        try {
                          await Provider.of<Auth>(context, listen: false)
                              .signInWithGoogle();
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.green.shade500,
                              content: const Text('تم تسجيل الدخول بنجاح')));

                          Navigator.popUntil(context, (route) => route.isFirst);
                          // Navigator.of(context)
                          //     .pushNamed(BottomNavBar.routeName);
                        } catch (error) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              backgroundColor: Colors.deepPurple,
                              content: Text(
                                  'فشل تسجيل الدخول. تحقق من الاتصال بالانترنت.'),
                            ),
                          );
                        }
                        setState(() => _isGoogleSigningIn = false);
                      },
                      label: _isGoogleSigningIn
                          ? const Center(child: CircularProgressIndicator())
                          : const Text('تسجيل بواسطة قوقل',
                              style: TextStyle(
                                  fontSize: 16, color: Color(0xff167EE6)))),
                ),
                const SizedBox(height: 16),
                InkWell(
                  onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterScreen())),
                  child: const Text(
                    'ليس لديك حساب؟ قم بإنشاء حساب.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xff814269)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
