import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invert/Base Fuctions/voiceconnect.dart';



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
    return '$e';
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

    void viewProfile(BuildContext context, String friendUserId)
    {

      String tempUsername = '';
      String userTokenGen = tokenPLACEHOLDER;

        getUsername(friendUserId).then((value){
          tempUsername = value;
        });
        
        getToken(tempUsername).then((value){
          userTokenGen = value;
        });

      showDialog(
        context: context,
        barrierDismissible: true, 
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 5,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.transparent,
                              backgroundImage: NetworkImage(userTokenGen),
                            ),
                          ),
                          Text(tempUsername)
                        ],
                      ),
                    )
                  ],
                ),
                //Column()
              ],
            )
          );
        }
        );
    }
    void directMsg(){
      
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




























