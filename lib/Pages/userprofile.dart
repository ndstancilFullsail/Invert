import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'base_layout.dart';
import 'package:invert/Firebase/firebasefunctions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';


class UserProfile  extends StatefulWidget{
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> { 

    final FirebaseAuth auth = FirebaseAuth.instance;
    final String uid = FirebaseAuth.instance.currentUser!.uid;
    final String email = FirebaseAuth.instance.currentUser!.email.toString();
    final String username = FirebaseAuth.instance.currentUser!.displayName.toString();
    final String  invalidUser = 'No user is currently signed in';
    late Future<String>? userProfilepic;
    final placeholder = 'placeholder.png';
    final storageRef = FirebaseStorage.instance.ref();


    Future<String?> pickImage() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image, 
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path; 
      } else {
        return null; 
      }
    }

    // String getFileType(String? example) {
    //   List<String> array = [];
    //   if(example != null)
    //   {
    //     array = example.split('\\');
    //     array = array.last.split('.');
    //   }
    //   return array.last;
    // }

  Future<String> getUserPicture(String path) async {

    try {
      String downloadURL = await FirebaseStorage.instance
        .ref(path)
        .getDownloadURL();
        return downloadURL;
    } catch (e) {
      debugPrint('$e');
      return '';
    }
  }

   void uploadUserPicture() async {

      String? imagePath = await pickImage();

   
      if (imagePath != null) {

        String combo = "$username/$username.png"; 
        final userProPic = storageRef.child(combo);
        
        File imagefile = File(imagePath);

        try{
          userProPic.putFile(imagefile).snapshotEvents.listen((taskSnapshot){
            switch(taskSnapshot.state) {
              case TaskState.running:
              break;
              case TaskState.paused:
              break;
              case TaskState.success:
              setState(() {
                userProfilepic = getUserPicture(combo);
              });        
              break;
              case TaskState.canceled:
              break;
              case TaskState.error:
              break;
            }
          });

          
        } catch (e) {
          debugPrint('$e');
          
        }

      } 
      else {
        debugPrint('User has cancel windows dialog');
      }
    }



    @override
  void initState() {
    userProfilepic = getUserPicture(placeholder);
    super.initState();
  }
    
    @override
    Widget build(BuildContext context) {
      return BaseLayout(
        body: Row(
          children: <Widget> [
            Expanded(
              flex: 1,
              
                child: Column(
                  children: <Widget> [
                    Card(
                      child: SizedBox(
                        height: 500, 
                        child:Column(
                          children: <Widget> [

                        IconButton(onPressed: () {
                          uploadUserPicture();

                        }, 
                        icon: FutureBuilder<String>(
                                future: userProfilepic,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  }
                                  if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Icon(Icons.account_circle, size: 100);
                                  }
                                    return Container(
                                      width: 150,
                                      height: 150,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      child: Image.network(snapshot.data!,fit: BoxFit.fill,),
                                    );
                                },
                              ),
                        ),
                        const SizedBox(height: 20),

                        Text('Profile', 
                        style: GoogleFonts.roboto(fontSize: 36, color: Colors.black)),
                        
                         const SizedBox(height: 20),
                        FutureBuilder(future: FirebaseFunctions().getFullName(), builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }else if(snapshot.hasError){
                            return Text("Error: ${snapshot.error}");
                          }
                          else {
                            return Text(
                              "Full Name: ${snapshot.data}", 
                              style: GoogleFonts.roboto(
                                        fontSize: 24,
                                          color: Colors.black,),
                            );
                          }
                        }
                      ),
                      const SizedBox(height: 20),
                         
                         Text(
                          'Welcome, $username',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Welcome, $email',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                       FutureBuilder(future: FirebaseFunctions().getTeamFromCollection(email), builder: (context,snapshot){
                          if(snapshot.connectionState == ConnectionState.waiting){
                            return CircularProgressIndicator();
                          }else if(snapshot.hasError){
                            return Text("Error: ${snapshot.error}");
                          }
                          else {
                            return Text(
                              "Team: ${snapshot.data}", 
                              style: GoogleFonts.roboto(
                                        fontSize: 24,
                                          color: Colors.black,),
                            );
                          }
                        }
                      ),
                      ],
                    ),
                    ),
                    ),
                    Card(child: Column(children: <Widget>[
                      Text('Badges', 
                      style: GoogleFonts.roboto(
                        fontSize: 24, 
                        color: Colors.black,
                        fontStyle: FontStyle.normal,
                        fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),

                        Text('This is where badge data will go'),
                        
                      

                    ],
                    ),
                    ),
                    
                  ],
                
                ),
              ),
           

            Expanded(
              flex: 1, 
              child: Column(children: <Widget> [ Card( child: SizedBox(height: 300, child: Column( children: <Widget>[
                Text('LeaderBoard', style: GoogleFonts.roboto(),),

                const SizedBox(height: 100),

                Text('This is where the leaderboard stats will be')

              ],
              ),
              ),
              ),
              Card(child: SizedBox(height: 300, child: Column( children: <Widget>[
                Text('Challenges', style: GoogleFonts.roboto(),),

                const SizedBox(height: 100),

                Text('This is where the leaderboard stats will be')

              ],
              ),
              ),
              ),
              ],
              
              ),
            ),
            
            Expanded(flex:1, child: Column(children: <Widget> [ Card( child: SizedBox(height: 300, child: Column( children: <Widget>[
                Text('Friends', style: GoogleFonts.roboto(),),

                const SizedBox(height: 100),

                Text('This is where the Friends list and requests will be')

              ],
              
              ),
            ),
          ),
          Card(child: SizedBox(height: 300, child: Column( children: <Widget>[
                Text('Friends', style: GoogleFonts.roboto(),),

                const SizedBox(height: 100),

                Text('This is where the Friends list and requests will be')

              ],
              
              ),
            ),
          ),
            ]
            )
        )
          ]
        )
      );
  }
}


