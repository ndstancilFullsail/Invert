import 'package:flutter/material.dart';



const Color NavbgColoor = Color(0xFF17203A);
const Color background = Color(0xFFFFFFFF);

class SettingsPage extends StatefulWidget{

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      color: background,
      child: Scaffold( 
        body: Column(
          children: [SizedBox(height: 10,),
            SafeArea(
            child: Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: NavbgColoor.withValues(alpha: 0.8),
                borderRadius: BorderRadius.all(Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                      color: NavbgColoor.withValues(alpha: 0.3),
                      offset: Offset(0, 20),
                      blurRadius: 20,
                  ),
                ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                   
                    
                  ],
                ),
            ),
          ),
          Expanded(child: Container())
          ]
        ),
      ),
    );
  }
}

class NewText extends StatelessWidget {
  
  final String texts;
  const NewText({
    super.key,required this.texts
  });



  @override
  Widget build(BuildContext context) {
    return Text(texts);
  }
}