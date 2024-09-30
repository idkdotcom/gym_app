import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gym_app/screens/homepage.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;

  void _toggleAuthMode() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    _formKey.currentState!.save();

    try {
      if (_isLogin) {
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        print(userCredential);
        // MaterialPageRoute(builder: (ctx) => Homepage());
      } else {
        final userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: _emailController.text,
                password: _passwordController.text);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': _usernameController.text,
          'email': _emailController.text,
          'memberStatus': "Not Activated",
          'memberStart': DateTime.utc(1970, 1, 1),
          'memberEnd': DateTime.utc(1970, 1, 1),
          'monthsLeft': 0,
        });
        print(userCredential);
        MaterialPageRoute(builder: (context) => const Homepage());
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? 'Authentication Failed'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLogin) {
      // LOGIN PAGE
      return Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EL GYM',
                  style: TextStyle(
                      fontSize: 50,
                      color: Theme.of(context).colorScheme.onBackground),
                ),
                const SizedBox(
                  height: 40,
                ),
                Card(
                  margin: const EdgeInsets.all(20),
                  color: Theme.of(context).colorScheme.primary,
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Text(
                            'Welcome back!',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 30,
                            ),
                          ),
                          Text(
                            'Login to get started.',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.6),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.6),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null ||
                                  value.trim().length <= 4 ||
                                  value.isEmpty) {
                                return 'Email must be valid';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            controller: _emailController,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.6),
                                ),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.6),
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Password cannot be empty';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.name,
                            controller: _passwordController,
                            obscureText: true,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 15),
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : Text(
                                    'Login',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSecondary,
                                      fontSize: 18,
                                    ),
                                  ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                  endIndent: 15,
                                ),
                              ),
                              Text(
                                'Or login with',
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimary
                                      .withOpacity(0.7),
                                ),
                              ),
                              const Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                  indent: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                            borderRadius: BorderRadius.circular(50),
                            onTap: () {},
                            child: Image.asset(
                              'assets/images/google_logo.png',
                              height: 50,
                              width: 50,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    TextButton(
                      onPressed: _toggleAuthMode,
                      child: Text(
                        "Sign Up here!",
                        style: TextStyle(
                          color: Colors.blue[400],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      // SIGN UP PAGE
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Text(
              //   'EL GYM',
              //   style: TextStyle(
              //       fontSize: 50,
              //       color: Theme.of(context).colorScheme.onBackground),
              // ),
              // const SizedBox(
              //   height: 10,
              // ),
              Card(
                margin: const EdgeInsets.all(20),
                color: Theme.of(context).colorScheme.primary,
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Text(
                          'Create your account,',
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Email',
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.6),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().length <= 4 ||
                                value.isEmpty) {
                              return 'Email must be valid';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Username',
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.6),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.trim().length <= 4 ||
                                value.isEmpty) {
                              return 'Username must be more than 4 characters';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.name,
                          controller: _usernameController,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.6),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          autocorrect: false,
                          controller: _passwordController,
                          obscureText: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Confirm Password',
                            labelStyle: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimary
                                  .withOpacity(0.6),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.6),
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value != _passwordController.text) {
                              return 'Must be the same as password';
                            }
                            return null;
                          },
                          keyboardType: TextInputType.visiblePassword,
                          autocorrect: false,
                          obscureText: true,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        ElevatedButton(
                          onPressed: _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.secondary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 50, vertical: 15),
                          ),
                          child: _isLoading
                              ? const CircularProgressIndicator()
                              : Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary,
                                    fontSize: 18,
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 2,
                                endIndent: 15,
                              ),
                            ),
                            Text(
                              'Or sign up with',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimary
                                    .withOpacity(0.7),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Colors.grey,
                                thickness: 2,
                                indent: 15,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(50),
                          onTap: () {},
                          child: Image.asset(
                            'assets/images/google_logo.png',
                            height: 50,
                            width: 50,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  TextButton(
                    onPressed: _toggleAuthMode,
                    child: Text(
                      "Login here!",
                      style: TextStyle(
                        color: Colors.blue[400],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
