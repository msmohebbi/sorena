import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/afradc.dart';
import '../index.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  GroupsScreenState createState() => GroupsScreenState();
}

class GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Group> number2 = Provider.of<Grooha>(context).grooha;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, _) async {
        Provider.of<Index>(context, listen: false).changeIndex(0);
      },
      child: number2.isEmpty
          ? const Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "گروهی برای نمایش وجود ندارد",
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  "برای ساخت گروه روی دکمه زیر کلیک کنید",
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ))
          : ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                if (oldIndex < newIndex) {
                  newIndex -= 1;
                }
                var newG = number2;
                var reo = newG.removeAt(oldIndex);
                newG.insert(newIndex, reo);
                Provider.of<Grooha>(context, listen: false).reOrderList(newG);
              },
              children: number2.map((g) {
                // int gindex = number2.indexOf(g);
                return ListTile(
                  key: Key(g.name.toString()),
                  tileColor: Colors.tealAccent[700],
                  trailing: Text(
                    g.name,
                    textAlign: TextAlign.right,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ReorderableDragStartListener(
                          index: number2.indexOf(g),
                          child: const Icon(
                            Icons.menu,
                          )),
                      IconButton(
                        tooltip: "حذف گروه",
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red[900],
                        ),
                        onPressed: () {
                          Provider.of<Grooha>(context, listen: false)
                              .removefromlist(g);
                          Provider.of<Afrad>(context, listen: false)
                              .updateLocal();
                          Provider.of<Labelha>(context, listen: false)
                              .updateLocal();
                          ScaffoldMessenger.of(context).hideCurrentSnackBar();

                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: const Text(""),
                            action: SnackBarAction(
                              label: "برگشت",
                              onPressed: () {
                                Provider.of<Grooha>(context, listen: false)
                                    .addtolist(g);
                                Provider.of<Afrad>(context, listen: false)
                                    .updateLocal();
                                Provider.of<Labelha>(context, listen: false)
                                    .updateLocal();
                              },
                            ),
                          ));
                        },
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: "ویرایش گروه",
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            // isDismissible: true,
                            builder: (context) => ModalBGrooha(
                              isedit: true,
                              oldGroup: g,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: "ارسال پیامک گروهی",
                        icon: const Icon(
                          Icons.message,
                          color: Colors.white,
                        ),
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
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: const Text(""),
                              action: SnackBarAction(
                                label: "فردی به این گروه اضافه نشده است",
                                onPressed: () {},
                                textColor: Colors.white,
                              ),
                            ));
                          }
                        },
                      ),
                      IconButton(
                        visualDensity: VisualDensity.compact,
                        tooltip: "نمایش افراد گروه",
                        icon: const Icon(
                          Icons.remove_red_eye_rounded,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Provider.of<Index>(context, listen: false)
                              .changeIndex(0);
                          final gp = Provider.of<Grooha>(context, listen: false)
                              .grooha;
                          int ind = (gp.length - 1) - gp.indexOf(g);

                          DefaultTabController.of(context).animateTo(ind);
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
    );
  }
}

class ModalBGrooha extends StatefulWidget {
  const ModalBGrooha({super.key, required this.isedit, required this.oldGroup});
  final bool isedit;
  final Group oldGroup;

  @override
  ModalBGroohaState createState() => ModalBGroohaState();
}

class ModalBGroohaState extends State<ModalBGrooha> {
  String? enname;
  bool isinit = true;

  @override
  Widget build(BuildContext context) {
    if (isinit) {
      enname = widget.oldGroup.name;
      isinit = false;
    }
    bool formKey = false;

    List<String> listG = Provider.of<Grooha>(context).grooha.map((g) {
      return g.name;
    }).toList();
    return Container(
      color: Colors.grey[50],
      height: 500,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      validator: (str) {
                        if (listG.contains(str) && widget.isedit) {
                          formKey = false;
                          return "نام تکراری";
                        } else if (widget.isedit) {
                          if (listG.where((gg) {
                            return gg != widget.oldGroup.name;
                          }).contains(str)) {
                            formKey = false;
                            return "نام از قبل موجود است";
                          } else {
                            formKey = true;
                            return null;
                          }
                        } else {
                          formKey = true;
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: widget.oldGroup.name,
                      textInputAction: TextInputAction.done,
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      decoration: const InputDecoration(
                          fillColor: Colors.blue,
                          labelText: "نام",
                          hintStyle: TextStyle()),
                      onChanged: (name) {
                        enname = name;
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    child: widget.isedit
                        ? const Text("ذخیره کردن")
                        : const Text("اضافه کردن"),
                    onPressed: () {
                      if (formKey) {
                        widget.isedit
                            ? Provider.of<Grooha>(context, listen: false)
                                .updatefromlist(
                                    Group(enname!), widget.oldGroup, context)
                            : Provider.of<Grooha>(context, listen: false)
                                .addtolist(Group(enname!));

                        Provider.of<Afrad>(context, listen: false)
                            .updateLocal();
                        Provider.of<Labelha>(context, listen: false)
                            .updateLocal();
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
