import 'package:fluent/src/frontend/widgets/ChatScreen.dart';
import 'package:flutter/material.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';

class SearchAndUserIcon extends StatelessWidget {
  const SearchAndUserIcon({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Flexible(
          flex: 2,
          //child: Icon(
          //Icons.search,
          child: SearchBar(
            hintText: "Search user",
          ),
        ) ,
        //),
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                // Navigator should go here. It should navigate to the EditProfile page
                print("User image is being tapped");
              },
              child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('lib/src/frontend/assets/giraffe-min.jpg'),
                      )
                  )
              ),
            ),
          ),
        ),
      ],
    );
  }
}