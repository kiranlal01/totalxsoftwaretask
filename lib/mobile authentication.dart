import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:totalxsoftwaretask/otp%20verification.dart';

void main(){
  runApp(MaterialApp(home: MobileAuth(),debugShowCheckedModeBanner: false,));
}

class MobileAuth extends StatefulWidget{
  @override
  State<MobileAuth> createState() => _MobileAuthState();
}

class _MobileAuthState extends State<MobileAuth> {

  TextEditingController phonecontroller=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 20,right: 20),
        child: ListView(
          children: [
            SizedBox(height: 50,),
            Image(image: AssetImage("assets/images/img.png"),height: 100,width: 100,),
            SizedBox(height: 50,),
            Text("Enter Phone Number",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            TextField(
              controller: phonecontroller,
              keyboardType: TextInputType.number,
              decoration:  InputDecoration(
                  hintText: 'Enter Phone Number',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
              ),
            ),
            SizedBox(height: 20,),
            Text("By Continuing,I agree to Totalx's Terms and conditions & privacy policy"),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.verifyPhoneNumber(
                    verificationCompleted: (PhoneAuthCredential credential) {  },
                    verificationFailed: (FirebaseAuthException error) {  },
                    codeSent: (String verificationId, int? resendtoken) {
                      Navigator.push(context,MaterialPageRoute(builder: (context)=>OtpVerification(verificationid: verificationId,)));
                    },
                    codeAutoRetrievalTimeout: (String verificationId) {  },
                    phoneNumber: phonecontroller.text.toString()
                  );
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                ),
                child: Text("Get OTP",style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}

