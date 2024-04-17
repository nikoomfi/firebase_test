import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p_08_firebase/constants.dart';
import '../constant_functions.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController valCodeController = TextEditingController();

  bool isWaitingForCode = false;
  String myVerificationId = '-1';

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      Future.delayed(
        const Duration(milliseconds: 500),
        () {
          kNavigate(context, 'home');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 45,
                child: TextField(
                  controller: phoneController,
                  decoration: kMyInputDecoration.copyWith(
                    hintText: 'Phone No.',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Visibility(
                visible: isWaitingForCode,
                child: SizedBox(
                  height: 45,
                  child: TextField(
                    controller: valCodeController,
                    decoration: kMyInputDecoration.copyWith(
                      hintText: 'Code',
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: onButtonPressed,
                child: Text(!isWaitingForCode ? 'Send Code' : 'Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onButtonPressed() async {
    String phone = phoneController.text;
    String code = valCodeController.text;

    // send code to phone
    if (isWaitingForCode == false) {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: kMyPhoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          print(['-----------------------------------------------------']);
          print('verified');
          print(credential);
          await auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          print(['-----------------------------------------------------']);
          print('failed');
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          } //
          else {
            print(e);
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          print(['-----------------------------------------------------']);
          print('code sent');
          print(verificationId);
          setState(() {
            isWaitingForCode = true;
          });
          myVerificationId = verificationId;
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          print(['-----------------------------------------------------']);
          print('code auto retrieval timeout');
          print(verificationId);
        },
      );
    } // do login with the sent code
    else {
      if (myVerificationId != '-1') {
        print('****************************************************');
        PhoneAuthCredential credential = PhoneAuthProvider.credential(
            verificationId: myVerificationId, smsCode: code);

        // Sign the user in (or link) with the credential
        UserCredential userCredential =
            await auth.signInWithCredential(credential);
        print(userCredential.user);
        print(auth.currentUser);
        if (auth.currentUser != null) {
          kNavigate(context, 'home');
        }
      } //
      else {
        print('sth is wrong');
      }
    }
  }
}
