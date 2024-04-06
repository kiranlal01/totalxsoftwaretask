import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:totalxsoftwaretask/home.dart';

// void main(){
//   runApp(MaterialApp(home: OtpVerification(),debugShowCheckedModeBanner: false,));
// }

class OtpVerification extends StatefulWidget{
  String verificationid;
  OtpVerification({super.key,required this.verificationid});

  @override
  State<OtpVerification> createState() => _OtpVerification();
}

class _OtpVerification extends State<OtpVerification> {

  TextEditingController otpcontroller=TextEditingController();

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
            Text("OTP Verification",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            Text("Enter the verification code we just sent to your number"),
            SizedBox(height: 10,),
            // TextField(
            //   controller: otpcontroller,
            //   keyboardType: TextInputType.phone,
            //   decoration:  InputDecoration(
            //       hintText: 'Enter OTP',
            //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: OtpTextField(
                numberOfFields: 6,
                fillColor: Colors.grey.withOpacity(0.1),
                filled: true,
                keyboardType: TextInputType.phone,
                // onSubmit: (code) {
                //   // Handle OTP submission
                //   _verifyOtp(code);
                // },
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.only(left: 150),
              child: Row(
                children: [
                  Text("Don't get OTP ?"),
                  TextButton(onPressed: () {}, child: Text("Resend"))
                ],
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
                onPressed: () async {
                  try{
                    PhoneAuthCredential credential=await PhoneAuthProvider.credential(
                        verificationId: widget.verificationid,
                        smsCode: otpcontroller.text.toString());
                    FirebaseAuth.instance.signInWithCredential(credential).then((value){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Home()));
                    });
                  }catch(error){
                    log(error.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black
                ),
                child: Text("Verify",style: TextStyle(color: Colors.white),))
          ],
        ),
      ),
    );
  }
}

