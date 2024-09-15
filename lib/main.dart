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
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
        theme: ThemeData(
          fontFamily: 'IRANYekan',
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.greenAccent,
          ),
        ),
        home: const MyScaffold(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyScaffold extends StatefulWidget {
  const MyScaffold({super.key});
  @override
  MyScaffoldState createState() => MyScaffoldState();
}

class MyScaffoldState extends State<MyScaffold> {
  List<Widget> mainWidgets = [
    const MainScreen(),
    const AfradScreen(),
    const GroupsScreen(),
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
    const Icon(Icons.person_add),
    const Icon(Icons.group_add),
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
                  icon: const Icon(Icons.add),
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
            style: const TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.right,
          ),
          bottom: mainIndex == 0 &&
                  Provider.of<Grooha>(context).grooha.isNotEmpty
              ? TabBar(
                  isScrollable: true,
                  tabs: [
                    ...(Provider.of<Grooha>(context).grooha.reversed.map((g) {
                      return Tab(
                        child: Text(
                          g.name,
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
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
                      child: const Center(
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
                        title: const Text(
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
                        title: const Text(
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
                        title: const Text(
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
                    var url = Uri(
                      scheme: "https",
                      host: "www.linkedin.com",
                      path: "in/msmohebbi/",
                    );
                    launchUrl(
                      url,
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  child: Text(
                    "© 2024 Sorena App By @msmohebbi76\n All rights reserved",
                    textAlign: TextAlign.left,
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.tealAccent[700],
                    ),
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
                shape: const CircleBorder(
                    side: BorderSide(color: Colors.white38, width: 1)),
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: true,
                      builder: (context) =>
                          mainModal[mainIndex] ?? Container());
                },
                child: mainIcon[mainIndex],
              )
            : null,
      ),
    );
  }
}
