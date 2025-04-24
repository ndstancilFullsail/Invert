import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invert/Base Fuctions/voiceconnect.dart';
import 'package:invert/Pages/dmchat.dart';
import 'package:google_fonts/google_fonts.dart';



Future<String> getUsername(String email) async {
  final databasedoc = await FirebaseFirestore.instance.collection('users').doc(email).get();
  String temp = 'ERROR USERNAME';

  if(databasedoc.exists)
  {
    final doc = databasedoc.data() as Map<String, dynamic>;
    temp = doc['Username'];
  }
  return temp;
}

Future<String> getToken(String username) async {

  try{
    String tokenURL = await FirebaseStorage.instance.ref(username).getDownloadURL();
    return tokenURL;
  }
  catch(e)
  {
    debugPrint('$e');
    return tokenPLACEHOLDER;
  }
}


class Friends extends StatefulWidget
{
  final String userid;
  final Widget uiWidget;


  const Friends({super.key,required this.uiWidget,required this.userid});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  var databaseRef = FirebaseFirestore.instance;
  Offset mousePos = Offset(0, 0);
  String senderusername = FirebaseAuth.instance.currentUser!.displayName.toString();

    Future<void> addFriendListMethod(String friendUserId) async
    { 
        final doclist = await databaseRef.collection('users').doc(widget.userid).get();
        List<String> temp = [];
        
        if(doclist.exists)
        {
          final data = doclist.data() as Map<String, dynamic>;

          //Finding if the field friends exist
          if(doclist.data()!.containsKey('friends'))
          {
            temp = List.from(data['friends']);
            
            temp.add(friendUserId);
            await databaseRef.collection('users').doc(widget.userid).update({
              'friends' : temp
            });  

          }
          else{

            temp.add(friendUserId);
            await databaseRef.collection('users').doc(widget.userid).set({
              'friends' : temp
            },SetOptions(merge: true));  

          }
        }
    }

Future<void> removeFriendListMethod(String friendUserId) async
    {
      final doclist = await databaseRef.collection('users').doc(widget.userid).get();
      List<String> temp = [];

      if(doclist.exists)
      {
        final data = doclist.data() as Map<String, dynamic>;

        if(doclist.data()!.containsKey('friends'))
        {
          temp = List.from(data['friends']);
          
          temp.removeWhere((item) => item == friendUserId);

          await databaseRef.collection('users').doc(widget.userid).update({
              'friends' : temp
          }); 
        }
      }

    }

    void viewProfile(BuildContext context, String friendUserId) async
    {

      String tempUsername = 'ERROR';
      String userTokenGen = tokenPLACEHOLDER;

        await getUsername(friendUserId).then((value){
          tempUsername = value;
        });
        
        await getToken(tempUsername).then((value){
          userTokenGen = value;
        });


    if(context.mounted)
      {showDialog(
        context: context,
        barrierDismissible: true, 
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: SizedBox(
              height: 300,
              width: 500,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[ 
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Card(
                          child: SizedBox(
                            height: 250,
                            width: 150,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                                    children: <Widget> [
                                      CircleAvatar(
                                        radius: 50,
                                        backgroundColor: Colors.transparent,
                                        backgroundImage: NetworkImage(userTokenGen),
                                      ),
                                      Text(
                                        tempUsername, 
                                        style: GoogleFonts.roboto(fontSize: 24, color: Colors.black),
                                        )
                                    ],
                                  ),
                          ),
                        ),
                      )
                    ],
                  ),
                  Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Card(
                            child: SizedBox(
                            height: 100,
                            width: 250,
                          child: Column(
                            children: [
                              Text('Badges')
                              
                              ])
                          ),
                                              ),
                        ),
                    Card(
                        child: Text('LeaderBoard'),
                      )
                      ],
                  ),
                ],
              ),
            )
          );
        }
        );
      }
    }
    void directMsg(String sender, String receiver) async
    {
     Navigator.push(context, MaterialPageRoute(builder: (context) => DMChatScreen(senderusername: sender, receiverusername: receiver)));

      
    }


    void _showContextMenu(BuildContext context, Offset mousePos)
    {
        String addFriendString = 'Add Friend';
        String removeFriendString = 'Remove Friend';

        //Need to add a check here for if user is already friends with another user and if the friends field exists as well

      showMenu(
        context: context, 
        position: RelativeRect.fromLTRB(
          mousePos.dx, 
          mousePos.dy, 
          MediaQuery.of(context).size.width - mousePos.dx, 
          MediaQuery.of(context).size.height - mousePos.dy), 
        items: [
          PopupMenuItem(
            child: Text('Direct Message')
            ,onTap: () {
              directMsg(senderusername, widget.userid); // Replace 'receiverUserId' with the actual receiver's user ID
            },
            ),
          PopupMenuItem(
            child: Text('View Profile'),
            onTap: () {
              viewProfile(context,widget.userid);
            },
            ),
          PopupMenuItem(
            child: Text(addFriendString),
            onTap: () {
            },
            ),
          PopupMenuItem(
            child: Text(removeFriendString)

            ),

        ]);

    }

    void _updateLocation(PointerEvent details)
    {
      setState(() {
        mousePos = details.position;
      });
    }

    @override
  Widget build(BuildContext context) {
    
    return GestureDetector(
      onSecondaryTapDown: (details) {
        _showContextMenu(context, mousePos);
      },
      child: MouseRegion(
        onHover: _updateLocation,
        child: widget.uiWidget,
      ),
    );
  }
}

class FriendButton extends PopupMenuItem {

  const FriendButton({
    super.key, required super.child,
  });

  bool _areFriends(String friendUserID) {
    
    String _currentUser = FirebaseAuth.instance.currentUser!.email!;





    return false;
  }

  @override
  Widget build(BuildContext context) {
    Widget temp = SizedBox();

    if(areFriend)
    {
      return temp;
    }else
    {
      return PopupMenuItem();
    }
  }
}




























