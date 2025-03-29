import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Friends extends StatefulWidget
{
  //final String userid;
  final Widget uiWidget;

  const Friends({super.key,required this.uiWidget});

  @override
  State<Friends> createState() => _FriendsState();
}

class _FriendsState extends State<Friends> {

  var databaseRef = FirebaseFirestore.instance;

    Future<void> addFriendListMethod(String friendUserId) async
    { 
        final doclist = await databaseRef.collection('users').doc(widget.userid).get();
        List<String> temp = [];
        
        if(doclist.exists)
        {
          final data = doclist.data() as Map<String, dynamic>;

          if(doclist.data()!.containsKey('friends'))
          {
            temp = List.from(data['friends']);

            //temp.contains(friendUserId); check if the person is already friended so the add friend menu doesn't appear.
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

    Future<void> removeFriend(String friendUserId) async
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

    void viewProfile()
    {

    }

    void directMsg(){
      
    }


    



    @override
  Widget build(BuildContext context) {
    
    return Column(
      children: [
        Text('addfriend'),
        Text('removefriend'),
        Text('Direct Message'),
        Text('View Profile')
      ],
    );
  }
}




























