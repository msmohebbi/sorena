import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';

import 'Screens/afred_screen.dart';
import 'Screens/grooha_screen.dart';
import 'Models/afradc.dart';
import 'Screens/main_screen.dart';
import 'index.dart';

void main() async {
  var dbman = DataBaseMan();
  await dbman.firstInit();
  runApp(MainApp());
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Afrad(),
        ),
        ChangeNotifierProvider(
          create: (_) => Grooha(),
        ),
        ChangeNotifierProvider(
          create: (_) => Index(),
        ),
        ChangeNotifierProvider(
          create: (_) => Labelha(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'IRANYekan'),
        home: MyScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyScaffold extends StatefulWidget {
  MyScaffold({Key? key}) : super(key: key);
  @override
  _MyScaffoldState createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  List<Widget> mainWidgets = [
    MainScreen(),
    AfradScreen(),
    GroupsScreen(),
  ];
  List<Widget?> mainModal = [
    null,
    ModalBAfrad(
      isedit: false,
      oldPerson: Person("", "", []),
    ),
    ModalBGrooha(
      isedit: false,
      oldGroup: Group(""),
    ),
  ];
  List<Icon?> mainIcon = [
    null,
    Icon(Icons.person_add),
    Icon(Icons.group_add),
  ];

  // @override
  // void didChangeDependencies() {
  //   Afrad().updateLocal();
  //   Grooha().updateLocal();
  //   Labelha().updateLocal();
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    int mainIndex = Provider.of<Index>(context).index;
    int lenn = Provider.of<Grooha>(context).grooha.length;
    // print(lenn);
    return DefaultTabController(
      length: lenn,
      initialIndex: lenn == 0 ? lenn : lenn - 1,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[800],
          centerTitle: true,
          leading: 0 < mainIndex && mainIndex < 3
              ? IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isDismissible: true,
                        builder: (context) =>
                            mainModal[mainIndex] ?? Container());
                  },
                )
              : null,
          title: Text(
            Provider.of<Index>(context).index == 0
                ? "سورنا"
                : Provider.of<Index>(context).index == 1
                    ? "مدیریت افراد"
                    : "مدیریت گروه ها",
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.right,
          ),
          bottom: mainIndex == 0 &&
                  Provider.of<Grooha>(context).grooha.length != 0
              ? TabBar(
                  isScrollable: true,
                  tabs: [
                    ...(Provider.of<Grooha>(context).grooha.reversed.map((g) {
                      return Tab(
                        text: g.name,
                      );
                    })),
                    // Tab(
                    //   text: "+",
                    // )
                  ],
                )
              : null,
        ),
        endDrawer: Drawer(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Container(
                      height: AppBar().preferredSize.height,
                      color: Colors.grey[800],
                      child: Center(
                        child: Text(
                          "سورنا",
                          textAlign: TextAlign.right,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Provider.of<Index>(context, listen: false)
                              .changeIndex(0);
                          Navigator.of(context).pop();
                        });
                      },
                      child: ListTile(
                        tileColor:
                            mainIndex == 0 ? Colors.grey[200] : Colors.white,
                        title: Text(
                          "صفحه اصلی",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: Icon(
                          Icons.home,
                          color: mainIndex == 0
                              ? Colors.tealAccent[700]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Provider.of<Index>(context, listen: false)
                              .changeIndex(1);
                          Navigator.of(context).pop();
                        });
                      },
                      child: ListTile(
                        tileColor:
                            mainIndex == 1 ? Colors.grey[200] : Colors.white,
                        title: Text(
                          "مدیریت افراد",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: Icon(
                          Icons.person_add,
                          color: mainIndex == 1
                              ? Colors.tealAccent[700]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          Provider.of<Index>(context, listen: false)
                              .changeIndex(2);
                          Navigator.of(context).pop();
                        });
                      },
                      child: ListTile(
                        tileColor:
                            mainIndex == 2 ? Colors.grey[200] : Colors.white,
                        title: Text(
                          "مدیریت گروه ها",
                          textDirection: TextDirection.rtl,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        trailing: Icon(
                          Icons.group,
                          color: mainIndex == 2
                              ? Colors.tealAccent[700]
                              : Colors.grey[700],
                        ),
                      ),
                    ),
                    // ListTile(
                    //   tileColor:
                    //       mainIndex == 4 ? Colors.grey[200] : Colors.white,
                    //   title: Text(
                    //     "تنظیمات",
                    //     textDirection: TextDirection.rtl,
                    //     style: TextStyle(
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    //   trailing: Icon(
                    //     Icons.settings,
                    //     color: mainIndex == 3
                    //         ? Colors.tealAccent[700]
                    //         : Colors.grey[700],
                    //   ),
                    // ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    launchUrl(Uri.parse("http://www.msmcode.ir"));
                  },
                  child: Text(
                    "© 2022 Sorena App By @msmohebbi76, All rights reserved",
                    style: TextStyle(fontSize: 12),
                  ),
                )
              ],
            ),
          ),
        ),
        body: mainWidgets[mainIndex],
        floatingActionButton: 0 < mainIndex && mainIndex < 3
            ? FloatingActionButton(
                backgroundColor: Colors.tealAccent[700],
                // elevation: 20,
                shape: CircleBorder(
                    side: BorderSide(color: Colors.white38, width: 1)),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      builder: (context) =>
                          mainModal[mainIndex] ?? Container());
                },
                child: mainIcon[mainIndex])
            : null,
      ),
    );
  }
}