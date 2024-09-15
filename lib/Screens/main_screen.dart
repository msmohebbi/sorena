import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/afradc.dart';
import '../index.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    // return Container(
    //   child: Column(
    //     children: [
    //       ...(Provider.of<Grooha>(context).grooha.map((g) {
    //         return ExpansionTile(
    //           trailing: Text(g.name),
    //           children: [
    //             ...Provider.of<Afrad>(context).afradd.where((p) {
    //               return p.group == g;
    //             }).map((a) {
    //               return ListTile(trailing: Text(a.name));
    //             }).toList(),
    //           ],
    //         );
    //       }).toList()),
    //     ],
    //   ),
    // );
    return Provider.of<Grooha>(context).grooha.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                    "از بخش مدیریت گروه ها، گروه مورد نظر خود را بسازید"),
                TextButton(
                  child: Text(
                    "رفتن به مدیریت گروه ها",
                    style: TextStyle(color: Colors.tealAccent[700]),
                  ),
                  onPressed: () {
                    Provider.of<Index>(context, listen: false).changeIndex(2);
                  },
                )
              ],
            ),
          )
        : TabBarView(
            children: [
              ...(Provider.of<Grooha>(context).grooha.reversed.map((g) {
                var cAfrad = Provider.of<Afrad>(context).afradd.where((p) {
                  return p.groupp.where((gg) {
                        return gg.name == g.name;
                      }).length ==
                      1;
                });
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (cAfrad.isEmpty) ...[
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 4,
                          child: const Center(
                            child: Text(
                              "لیست افراد خالی می باشد",
                            ),
                          ),
                        ),
                      ],
                      ...cAfrad.map((a) {
                        final agllist =
                            Provider.of<Labelha>(context).afradgroohatolabelha;
                        final thisagl = agllist.where((agl) {
                          return g.name == agl["gname"] &&
                              a.name == agl["aname"];
                        });
                        final labellist = Provider.of<Labelha>(context).labelha;

                        return Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerRight,
                                  end: Alignment.centerLeft,
                                  // tileMode: TileMode.mirror,
                                  stops: [
                                // 0,
                                MediaQuery.of(context).size.width / 100,
                                MediaQuery.of(context).size.width / 20,
                              ],
                                  colors: [
                                thisagl.isEmpty
                                    ? Colors.tealAccent[700]!
                                    : labellist.firstWhere((ll) {
                                        return thisagl.first["number"] ==
                                            ll.number;
                                      }).color,
                                Colors.tealAccent[700]!,
                              ])),
                          margin: const EdgeInsets.only(bottom: 1),
                          child: ListTile(
                            // tileColor: thisagl.isEmpty
                            //     ? Colors.tealAccent[700]
                            //     : labellist.firstWhere((ll) {
                            //         return thisagl.first["number"] == ll.number;
                            //       }).color,
                            trailing: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                reverse: true,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    PopupMenuButton(
                                      tooltip: "اضافه کردن به گروه",
                                      // icon: ,
                                      onSelected: (value) {
                                        log("ff");
                                        Provider.of<Afrad>(context,
                                                listen: false)
                                            .addremovetoGroup(
                                                value[0] as Person,
                                                value[1] as Group,
                                                context);
                                      },

                                      itemBuilder: (BuildContext ctx) {
                                        return Provider.of<Grooha>(context,
                                                listen: false)
                                            .grooha
                                            .map((g) {
                                          return PopupMenuItem(
                                            textStyle: TextStyle(
                                              color: a.groupp.map((x) {
                                                return x.name;
                                              }).contains(g.name)
                                                  ? Colors.tealAccent[700]
                                                  : Colors.black,
                                            ),
                                            value: [a, g],
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.25,
                                                  child: Text(
                                                    g.name,
                                                    softWrap: true,
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                Checkbox(
                                                  materialTapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,

                                                  visualDensity:
                                                      VisualDensity.compact,
                                                  onChanged: (_) {
                                                    Provider.of<Afrad>(context,
                                                            listen: false)
                                                        .addremovetoGroup(
                                                            a, g, context);
                                                    Navigator.of(context).pop();
                                                  },
                                                  // checkColor: Colors.tealAccent[700],
                                                  activeColor:
                                                      Colors.tealAccent[700],
                                                  value: a.groupp.map((x) {
                                                    return x.name;
                                                  }).contains(g.name),
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList();
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                          "${a.groupp.isEmpty ? "" : a.groupp.where((gp) {
                                              return gp.name != g.name;
                                            }).map((x) {
                                              return x.name;
                                            })}",
                                          softWrap: true,
                                          overflow: TextOverflow.fade,
                                          textAlign: TextAlign.right,
                                          textDirection: TextDirection.rtl,
                                          style: TextStyle(
                                            fontSize: 12,
                                            color:
                                                Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 3,
                                    ),
                                    Text(
                                      a.name,
                                      textAlign: TextAlign.right,
                                      textDirection: TextDirection.rtl,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                  tooltip: "حذف فرد از گروه",
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red[900],
                                  ),
                                  onPressed: () {
                                    Provider.of<Afrad>(context, listen: false)
                                        .addremovetoGroup(a, g, context);
                                  },
                                ),
                                IconButton(
                                  tooltip: "ارسال پیامک",
                                  icon: const Icon(
                                    Icons.sms,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    launchUrl(
                                        Uri.parse('sms:${a.phone}?body='));
                                  },
                                ),
                                IconButton(
                                  tooltip: "تماس",
                                  icon: const Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    launchUrl(Uri.parse('tel://${a.phone}'));
                                  },
                                ),
                                PopupMenuButton(
                                  tooltip: "اضافه کردن برچسب",
                                  // icon: ,
                                  onSelected: (value) {
                                    Provider.of<Labelha>(context, listen: false)
                                        .addremovetoLabelha(value[0] as Person,
                                            value[1] as Group, value[2] as int);
                                  },
                                  // color: Colors.red,
                                  padding: const EdgeInsets.all(0),
                                  itemBuilder: (BuildContext ctx) {
                                    final labelha = Provider.of<Labelha>(
                                            context,
                                            listen: false)
                                        .labelha;
                                    return labelha.map((l) {
                                      return PopupMenuItem(
                                        value: [a, g, l.number],
                                        child: Icon(
                                          Icons.circle,
                                          color: labellist.firstWhere((ll) {
                                            return ll.number == l.number;
                                          }).color,
                                        ),
                                      );
                                    }).toList();
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(left: 5, right: 1),
                                    child: Icon(Icons.color_lens,
                                        color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                    color: Colors.black12)
                              ],
                            ),
                            child: IconButton(
                                icon: const Icon(Icons.message_outlined),
                                tooltip: "ارسال پیامک گروهی",
                                onPressed: () {
                                  final afrads =
                                      Provider.of<Afrad>(context, listen: false)
                                          .afradd
                                          .where((x) {
                                    return x.groupp.map((ggg) {
                                      return ggg.name;
                                    }).contains(g.name);
                                  });
                                  if (afrads.isNotEmpty) {
                                    final phones = afrads.map((ppp) {
                                      return ppp.phone;
                                    }).toList();
                                    launchUrl(Uri.parse('sms:$phones?body='));
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: const Text(""),
                                      action: SnackBarAction(
                                        label:
                                            "فردی به این گروه اضافه نشده است",
                                        onPressed: () {},
                                        textColor: Colors.white,
                                      ),
                                    ));
                                  }
                                }),
                          ),
                          Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[200],
                              boxShadow: const [
                                BoxShadow(
                                    blurRadius: 10,
                                    spreadRadius: 3,
                                    color: Colors.black12)
                              ],
                            ),
                            child: IconButton(
                                tooltip: "ویرایش لیست",
                                icon: const Icon(
                                    Icons.library_add_check_outlined),
                                onPressed: () {
                                  // log(g.name);
                                  showModalBottomSheet(
                                      context: context,
                                      isDismissible: true,
                                      builder: (context) => ModalBAfradToGroup(
                                            g: g,
                                          ));
                                }),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }).toList()),
              // Icon(Icons.directions_car),
              // Icon(Icons.directions_transit),
              // Icon(Icons.directions_bike),
            ],
          );
  }
}

class ModalBAfradToGroup extends StatefulWidget {
  const ModalBAfradToGroup({super.key, required this.g});
  final Group g;

  @override
  ModalBAfradToGroupState createState() => ModalBAfradToGroupState();
}

class ModalBAfradToGroupState extends State<ModalBAfradToGroup> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ...Provider.of<Afrad>(context).afradd.map((p) {
          return InkWell(
            onTap: () {
              Provider.of<Afrad>(context, listen: false)
                  .addremovetoGroup(p, widget.g, context);
            },
            child: ListTile(
              tileColor: Colors.grey[100],
              title: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                reverse: true,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      "${p.groupp.isEmpty ? "" : p.groupp.map((x) {
                          return x.name;
                        })}",
                      softWrap: true,
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                    Text(
                      p.name,
                      textAlign: TextAlign.right,
                      textDirection: TextDirection.rtl,
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
              ),
              trailing: Checkbox(
                activeColor: Colors.tealAccent[700],
                onChanged: (x) {
                  // value = !value;
                  Provider.of<Afrad>(context, listen: false)
                      .addremovetoGroup(p, widget.g, context);
                },
                value: p.groupp.where((gg) {
                  return gg.name == widget.g.name;
                }).isEmpty
                    ? false
                    : true,
              ),
            ),
          );
        })
      ],
    );
  }
}
