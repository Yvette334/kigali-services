import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './services/auth_services.dart';
import './screens/signup.dart';
import './screens/login.dart';
import './screens/verify_email_screen.dart';
import './screens/kigali_directory.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
      ],
      child: MaterialApp(
        title: 'Kigali City Services',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: AuthWrapper(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}


class AuthWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data;
        if (user != null) {
          if(!user.emailVerified){
            return VerifyEmailScreen();
          }
          return KigaliDirectory();
        } else {
          // User is not logged in, show AuthScreen
          return AuthScreen();
        }
      },
    );
  }
}


class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}


class _AuthScreenState extends State<AuthScreen> {
  bool showLoginScreen = true;


  void toggleScreen() {
    setState(() {
      showLoginScreen = !showLoginScreen;
    });
  }


  @override
  Widget build(BuildContext context) {
    return showLoginScreen
        ? LoginScreen(showRegisterScreen: toggleScreen)
        : RegisterScreen(showLoginScreen: toggleScreen);
  }
}
