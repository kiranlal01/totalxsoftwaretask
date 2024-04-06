import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:path/path.dart' as path;

// void main(){
//   runApp(MaterialApp(home: Home(),debugShowCheckedModeBanner: false,));
// }

enum SingingCharacter { all, ageElder,ageYounger }

class Home extends StatefulWidget{

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var name=["Martin Dokkidis","Marilyn Rosser","Cridtofer Lipshutz"];

  var age=["34","45","28"];

  var img=["assets/images/img.png","assets/images/img.png","assets/images/img.png"];

  get searchController => null;
  SingingCharacter? stage = SingingCharacter.all;
  late CollectionReference userCollection;

  @override
  void initState() {
    userCollection=FirebaseFirestore.instance.collection('user');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.black,
        leading: Icon(Icons.location_on,color: Colors.white,),
        title: Text("Nilambur",style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          SizedBox(height: 10,),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  decoration: InputDecoration(

                      prefixIcon: Icon(Icons.search),
                      hintText: 'search by name ',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(25))
                  ),
                ),
              ),
              ClipRRect(borderRadius: BorderRadius.circular(10),
                child: Container(
                  height: 50,width: 50,color: Colors.black,
                  child:InkWell(
                    onTap: () {
                      showDialog(context: context, builder: (context){
                        return AlertDialog(
                          content: Column(
                            children: <Widget>[
                              Align(alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: const EdgeInsets.only(left:8),
                                  child: Text('Sort',style: TextStyle(fontWeight: FontWeight.bold),),
                                ),
                              ),
                              ListTile(
                                title: const Text('All'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.all,
                                  groupValue: stage,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      stage = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Age:Elder'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.ageElder,
                                  groupValue: stage,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      stage = value;
                                    });
                                  },
                                ),
                              ),
                              ListTile(
                                title: const Text('Age:Younger'),
                                leading: Radio<SingingCharacter>(
                                  value: SingingCharacter.ageYounger,
                                  groupValue: stage,
                                  onChanged: (SingingCharacter? value) {
                                    setState(() {
                                      stage = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      });
                    },
                      child: Icon(
                        Icons.sort,color: Colors.white,)),
                ),
              ),
            ],
          ),
          Text("Users List"),
          // Card(
          //   child: ListTile(
          //     leading: CircleAvatar(backgroundImage: AssetImage("assets/images/img.png"),),
          //     title: Text("name"),
          //     subtitle: Text("age"),
          //   ),
          // )

          StreamBuilder<QuerySnapshot>(stream: getUser(), builder:(context,snapshot){
            if(snapshot.hasError){
              return Text('Error${snapshot.error}');
            }
            if(snapshot.connectionState==ConnectionState.waiting){
              return CircularProgressIndicator();
            }
            final users=snapshot.data!.docs;
            return Expanded(child: ListView.separated(itemCount: users.length,itemBuilder: (context,index){
              final user=users[index];
              // final userId=user.id;
              final userName=user['name'];
              final userAge=user['age'];
              return Card(color: Colors.white,
                child: ListTile(
                  leading: CircleAvatar
                    (radius:50,
                    backgroundImage: AssetImage('assets/image/person.png'),
                  ),
                  title: Text('$userName'),
                  subtitle: Text('$userAge'),
                ),
              );
            }, separatorBuilder: (BuildContext context, int index) {
              return Divider(
                thickness: 10,
                color: Colors.transparent,
              );
            },));
          } )
          // Expanded(
          //   child: ListView.builder(itemBuilder: (context,index){
          //     return Card(
          //       child: ListTile(
          //         leading: CircleAvatar(backgroundImage: AssetImage("${img[index]}"),),
          //         title: Text("${name[index]}"),
          //         subtitle: Text("${age[index]}"),
          //       ),
          //     );
          //   },itemCount: name.length,),
          // )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>AddUser()));
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Stream<QuerySnapshot> getUser(){
    return userCollection.snapshots();
  }
}


class AddUser extends StatefulWidget{
  @override
  State<AddUser> createState() => _AddUserState();
}

class _AddUserState extends State<AddUser> {

  File? imageFile;
  final picker = ImagePicker();
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  late CollectionReference userCollection;


  // Future<void> _pickImage() async {
  //   final pickedFile = await picker.pickImage(source: ImageSource.gallery);
  //   if (pickedFile != null) {
  //     final imagefile = File(pickedFile.path);
  //     setState(() {
  //       imageFile = imagefile;
  //     });
  //   }
  // }
  @override
  void initState() {
    userCollection=FirebaseFirestore.instance.collection('user');
    super.initState();
  }

  Future<void> saveUser() async {
    final name = nameController.text.trim();
    final age = int.tryParse(ageController.text.trim()) ?? 0;

    if (name.isNotEmpty && age > 0 && imageFile != null) {
      // Save user data (name, age, imageFile) to your database or storage
      // For now, print the details
      // print('Name: $name, Age: $age, Image: ${imageFile!.path}');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please provide valid details.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  // @override
  // void dispose() {
  //   nameController.dispose();
  //   ageController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add A New User'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // if (imageFile != null)
            //   Image.file(
            //     imageFile!,
            //     height: 200,
            //     fit: BoxFit.cover,
            //   ),
            Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar
                      (radius:50,
                      backgroundImage: AssetImage('assets/images/person.png'),
                    ),
                    Positioned(bottom: -5,
                        left: 30,
                        child: IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt,size: 20,color: Colors.blue,),)
                    )
                  ],
                ),
              ],
            ),
            Text("Name"),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                  hintText: 'Name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
              ),
            ),
            Text("Age"),
            TextField(
              controller: ageController,
              decoration: InputDecoration(
                  hintText: 'Age',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20))
              ),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.0),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: saveUser,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}