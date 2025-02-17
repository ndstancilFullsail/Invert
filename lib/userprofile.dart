import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:invert/base_layout.dart';
import 'package:invert/firebasefunctions.dart';


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
    
    @override
    Widget build(BuildContext context) {
      return BaseLayout(
        body: Row(
          children: <Widget> [
            Expanded(
              flex: 1,
              
                child: Column(
                  children: <Widget> [
                    Card(child: SizedBox(height: 500, child:Column(
                      children: <Widget> [

                        Image.asset('assets/images/db5ae0242b73f9d87a79ae1f36559913.png'),

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
                            color: Colors.white,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          'Welcome, $email',
                          style: GoogleFonts.roboto(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 20),

                       FutureBuilder(future: FirebaseFunctions().getTeamFromCollection(), builder: (context,snapshot){
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