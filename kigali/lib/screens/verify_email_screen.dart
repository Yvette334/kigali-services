import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});
  final Color navyblue = const Color(0xFF0A172F);
  final Color yellow = const Color(0xFFF7C351);

  Future<void> checkVerification(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;
    await user!.reload();
    user = FirebaseAuth.instance.currentUser;

    if (user != null && user.emailVerified) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully')),
        );
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to verify email, check your emails'),
          ),
        );
      }
    }
  }

  Future<void> sendVerificationEmail(BuildContext context) async {
    try {
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send verification email: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: navyblue,
      appBar: AppBar(title: Text('Verify Email'),
      backgroundColor: navyblue,
      foregroundColor: yellow,
      elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.email_outlined, size: 80, color: yellow),
              const SizedBox(height: 24),
              const Text('Link is sent to your email, Check inbox or spam',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 32),
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
                  onPressed: () => checkVerification(context),
                  child:const Text('Verified Email', style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => sendVerificationEmail(context),
                child: Text('Resend Verification Email', style: TextStyle(color: yellow),),
              ),
              TextButton(
                onPressed: () => FirebaseAuth.instance.signOut(),
                child: const Text('Sign Out', style: TextStyle(color: Colors.white70)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
