import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  Future<void> checkVerification(BuildContext context) async{
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
    user = FirebaseAuth.instance.currentUser;

    if(user !=null && user.emailVerified){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email verified successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to verify email, check your emails')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Verify Email')),
      body: Center(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Link is sent yo your email, Check inbox or spam'),
            ElevatedButton(
              onPressed: () => checkVerification(context),
              child: Text('Verified Email'),
              ),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: Text('Sign Out')
              )
          ],
        ) 
        ),
    );
  }
}