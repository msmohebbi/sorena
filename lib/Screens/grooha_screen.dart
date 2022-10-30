import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/afradc.dart';
import '../index.dart';

class GroupsScreen extends StatefulWidget {
  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Group> number2 = Provider.of<Grooha>(context).grooha;
    return number2.length == 0
        ? Center(
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
        : Container(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: number2.map((g) {
                  // int gindex = number2.indexOf(g);
                  return Container(
                    margin: EdgeInsets.only(bottom: 1),
                    child: ListTile(
                      tileColor: Colors.tealAccent[700],
                      trailing: Text(
                        g.name,
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      title: Row(
                        children: [
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
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();

                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: Text(""),
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
                            icon: Icon(
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
                            icon: Icon(
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
                              if (afrads.length > 0) {
                                final phones = afrads.map((ppp) {
                                  return ppp.phone;
                                }).toList();
                                launchUrl(Uri.parse('sms:$phones?body='));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text(""),
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
                            icon: Icon(
                              Icons.remove_red_eye_rounded,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Provider.of<Index>(context, listen: false)
                                  .changeIndex(0);
                              final gp =
                                  Provider.of<Grooha>(context, listen: false)
                                      .grooha;
                              int ind = (gp.length - 1) - gp.indexOf(g);

                              DefaultTabController.of(context)!.animateTo(ind);
                            },
                          ),
                        ],
                        mainAxisAlignment: MainAxisAlignment.start,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
  }
}

class ModalBGrooha extends StatefulWidget {
  ModalBGrooha({required this.isedit, required this.oldGroup});
  final bool isedit;
  final Group oldGroup;

  @override
  _ModalBGroohaState createState() => _ModalBGroohaState();
}

class _ModalBGroohaState extends State<ModalBGrooha> {
  String? enname;
  bool isinit = true;

  @override
  Widget build(BuildContext context) {
    if (isinit) {
      enname = widget.oldGroup.name;
      isinit = false;
    }
    bool _formKey = false;

    List<String> _listG = Provider.of<Grooha>(context).grooha.map((g) {
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
                        if (_listG.contains(str) && widget.isedit) {
                          _formKey = false;
                          return "نام تکراری";
                        } else if (widget.isedit) {
                          if (_listG.where((gg) {
                            return gg != widget.oldGroup.name;
                          }).contains(str)) {
                            _formKey = false;
                            return "نام از قبل موجود است";
                          } else {
                            _formKey = true;
                            return null;
                          }
                        } else {
                          _formKey = true;
                          return null;
                        }
                      },
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      initialValue: widget.oldGroup.name,
                      textInputAction: TextInputAction.done,
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
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
                    child:
                        widget.isedit ? Text("ذخیره کردن") : Text("اضافه کردن"),
                    onPressed: () {
                      if (_formKey) {
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
