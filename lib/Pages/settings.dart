import 'package:flutter/material.dart';
import 'base_layout.dart';


const Color NavbgColoor = Color(0xFF17203A);
const Color background = Color(0xFFFFFFFF);

class SettingsPage extends StatefulWidget{

  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int selectedIndex = 0;


    final List<String> labels = [
    "Notifications",
    "Privacy",
    "Chat",
    "Sync",
    "Advance"
  ];
    
  @override
  Widget build(BuildContext context) {

    Widget page;
    switch (selectedIndex) {
      case 0:
        page = Placeholder();
        break;
      case 1:
        page = Placeholder();
      break;
      default:
        page = Placeholder();
    }

    return BaseLayout(body: 
    Column(
          children: [SizedBox(height: 10,),
            SafeArea(
            child: Container(
              height: 56,
              margin: EdgeInsets.symmetric(horizontal: 100),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(labels.length, (index) {
                    bool isSelected = index == selectedIndex;
                      return GestureDetector(
                          onTap: () {
                            setState(() {
                          selectedIndex = index;
                        });
                      },
                    child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white.withValues(alpha: 0.2) : Colors.transparent,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        NewText(labels: labels, isSelected: isSelected,tindex: index,),
                      ],
                    ),
                  ),
                );
              }),
            ),
                    
                  ],
                ),
            ),
          ),
          Expanded(
            child: Container(
                child: page,
          )
          )
          ]
        ),
    );
  }

}

class NewText extends StatelessWidget {
  const NewText({
    super.key,
    required this.labels,
    required this.isSelected,
    required this.tindex,
  });

  final List<String> labels;
  final bool isSelected;  
  final int tindex;



  @override
  Widget build(BuildContext context) {
    return Text(labels[tindex], style: TextStyle(color: isSelected ? Colors.white : Colors.grey,));
  }
}
