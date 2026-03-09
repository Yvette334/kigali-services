import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_services.dart';



class LoginScreen extends StatefulWidget {
  final VoidCallback showRegisterScreen;
  
  const LoginScreen({Key? key, required this.showRegisterScreen}) : super(key: key);


  @override
  _LoginScreenState createState() => _LoginScreenState();
}


class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  final Color navyblue = const Color(0xFF0A172F);
  final Color yellow = const Color(0xFFF7C351);

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try { 
      String? result = await Provider.of<AuthService>(context, listen: false).signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (result == 'Success'){
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login successful!'),
              backgroundColor: Colors.white60,
            ),
          );
        }
      } else {
        if (mounted) {
          String errorMessage = result ?? 'Login failed';
          if (errorMessage.contains('wrong password')) {
            errorMessage = 'Incorrect password. Please try again.';
          } else if (errorMessage.contains('user not found')) {
            errorMessage = 'No account found with this email.';
          } else if (errorMessage.contains('invalid email')) {
            errorMessage = 'Invalid email address.';
          } else if (errorMessage.contains('too many requests')) {
            errorMessage = 'Too many failed attempts. Try again later.';
          }
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyblue,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Icon(Icons.location_city, size: 80, color: yellow),
                SizedBox(height: 16),
                Text(
                  'Kigali Services',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: yellow,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in to continue',
                  style: TextStyle(fontSize: 16, color: Colors.white70),
                ),
                SizedBox(height: 40),


                // Email Field
                TextField(
                  controller: _emailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email, color: yellow),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: yellow)
                    )
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16),


                // Password Field
                TextField(
                  controller: _passwordController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white70),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock, color: yellow),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white60),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: yellow)
                    )
                  ),
                  obscureText: true,
                  onSubmitted: (_) => _login(),
                ),
                SizedBox(height: 24),


                // Login Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: yellow,
                      foregroundColor: navyblue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8) )
                    ),
                    onPressed: _isLoading ? null : _login,
                    child: _isLoading 
                        ? CircularProgressIndicator(color: Colors.white)
                        : Text('SIGN IN', style: TextStyle(fontSize: 16)),
                  ),
                ),
                SizedBox(height: 16),


                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?", style: TextStyle(color: Colors.white70)),
                    TextButton(
                      onPressed: widget.showRegisterScreen,
                      child: Text('Sign up', style: TextStyle(color: yellow)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
