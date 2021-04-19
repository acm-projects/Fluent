import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:fluent/src/frontend/routes.dart';
import 'package:flutter/material.dart';

class SearchAndUserIcon extends StatefulWidget {
  final String pfp;
  SearchAndUserIcon({Key key, @required this.pfp}) : super(key: key);
  /*const SearchAndUserIcon({
    Key key,
  }) : super(key: key);*/
  @override
  _SearchAndUserIcon createState() => _SearchAndUserIcon();
}

class _SearchAndUserIcon extends State<SearchAndUserIcon> {
  //var User = user.User(FirebaseAuth.instance.currentUser.uid);
  //var currentUser = user.U;
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
        ),
        //),
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                // Navigator should go here. It should navigate to the EditProfile page
                Navigator.pushNamed(context, Routes.editProfile, arguments: "https://firebasestorage.googleapis.com/v0/b/acm-fluent.appspot.com/o/uploads%2FHtFumEzDq1O5Z37x58xZ2bak9uE3?alt=media&token=e7671430-eca8-4de4-999c-e1920aa18883");

                //print(currentUser.);
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
                        image: NetworkImage(
                            "https://firebasestorage.googleapis.com/v0/b/acm-fluent.appspot.com/o/uploads%2FHtFumEzDq1O5Z37x58xZ2bak9uE3?alt=media&token=e7671430-eca8-4de4-999c-e1920aa18883"),
                      ))),
            ),
          ),
        ),
      ],
    );
  }
}
