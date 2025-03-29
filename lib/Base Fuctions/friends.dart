import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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


    void _showContextMenu(BuildContext context, Offset mousePos)
    {
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
            child: Text('View Profile')
            ),
          PopupMenuItem(
            child: Text('Add Friend')
            ),
          PopupMenuItem(
            child: Text('Remove Friend')
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




























