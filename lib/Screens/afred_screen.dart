// import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/afradc.dart';

class AfradScreen extends StatefulWidget {
  AfradScreen({Key? key}) : super(key: key);
  @override
  _AfradScreenState createState() => _AfradScreenState();
}

class _AfradScreenState extends State<AfradScreen> {
  @override
  Widget build(BuildContext context) {
    var number1 = Provider.of<Afrad>(context).afradd;
    var groohaa = Provider.of<Grooha>(context).grooha;

    return number1.length == 0
        ? Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "فردی برای نمایش وجود ندارد",
                style: TextStyle(fontSize: 16),
              ),
              Text(
                "برای ساخت فرد روی دکمه زیر کلیک کنید",
                style: TextStyle(fontSize: 10),
              ),
            ],
          ))
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: number1.map((p) {
                // int pindex = number1.indexOf(p);
                return Container(
                  margin: EdgeInsets.only(bottom: 1),
                  child: ListTile(
                    tileColor: Colors.tealAccent[700],
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.33,
                          // height: ,
                          child: Text(
                            p.name,
                            style: TextStyle(fontSize: 16, color: Colors.white),
                            textAlign: TextAlign.right,
                            softWrap: true,
                            overflow: TextOverflow.ellipsis,
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        Text(
                          p.phone,
                          style: TextStyle(color: Colors.white60),
                          textAlign: TextAlign.left,
                          textDirection: TextDirection.ltr,
                        ),
                      ],
                    ),
                    title: Row(
                      children: [
                        PopupMenuButton(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(Icons.keyboard_arrow_down_outlined),
                          ),
                          tooltip: "اضافه کردن به گروه",
                          // icon: ,
                          onSelected: (value) {
                            Provider.of<Afrad>(context, listen: false)
                                .addremovetoGroup(value[0] as Person,
                                    value[1] as Group, context);
                          },

                          itemBuilder: (BuildContext ctx) {
                            return groohaa.map((g) {
                              return PopupMenuItem(
                                textStyle: TextStyle(
                                  color: p.groupp.map((x) {
                                    return x.name;
                                  }).contains(g.name)
                                      ? Colors.tealAccent[700]
                                      : Colors.black,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.25,
                                      child: Text(
                                        g.name,
                                        softWrap: true,
                                        textDirection: TextDirection.rtl,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                      onChanged: (_) {},
                                      // checkColor: Colors.tealAccent[700],
                                      activeColor: Colors.tealAccent[700],
                                      value: p.groupp.map((x) {
                                        return x.name;
                                      }).contains(g.name),
                                    ),
                                  ],
                                ),
                                value: [p, g],
                              );
                            }).toList();
                          },
                          // value: _value,
                          // items: [
                          //   DropdownMenuItem(
                          //     child: Text("بدون گروه"),
                          //   ),
                          //   ...groohaa.map((g) {
                          //     return DropdownMenuItem(
                          //         child: Text(g.name),
                          //         value: "${p.name}${g.name}",
                          //         onTap: () {
                          //           Provider.of<Afrad>(context).editGroup(p, g);
                          //         });
                          //   })
                          // ],
                        ),
                        IconButton(
                          padding: EdgeInsets.all(0),
                          visualDensity: VisualDensity.compact,
                          tooltip: "حذف فرد",
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red[900],
                          ),
                          onPressed: () {
                            Provider.of<Afrad>(context, listen: false)
                                .removefromlist(p);
                            ScaffoldMessenger.of(context).hideCurrentSnackBar();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(""),
                              action: SnackBarAction(
                                label: "برگشت",
                                onPressed: () {
                                  Provider.of<Afrad>(context, listen: false)
                                      .addtolist(p);
                                },
                              ),
                            ));
                          },
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: "ویرایش فرد",
                          icon: Icon(
                            Icons.edit,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              // isDismissible: true,
                              builder: (context) => ModalBAfrad(
                                isedit: true,
                                oldPerson: p,
                              ),
                            );
                          },
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: "ارسال پیامک",
                          icon: Icon(
                            Icons.sms,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            launchUrl(Uri.parse('sms:${p.phone}?body='));
                          },
                        ),
                        IconButton(
                          visualDensity: VisualDensity.compact,
                          tooltip: "تماس",
                          icon: Icon(
                            Icons.call,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            launchUrl(Uri.parse('tel://${p.phone}'));
                          },
                        ),
                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}

class ModalBAfrad extends StatefulWidget {
  ModalBAfrad({required this.isedit, required this.oldPerson});
  final bool isedit;
  final Person oldPerson;

  @override
  _ModalBAfradState createState() => _ModalBAfradState();
}

class _ModalBAfradState extends State<ModalBAfrad> {
  String? enname;
  String? enphone;
  bool isinit = true;
  @override
  Widget build(BuildContext context) {
    if (isinit) {
      enname = widget.oldPerson.name;
      enphone = widget.oldPerson.phone;
      isinit = false;
    }
    bool _formKey = false;
    List<String> listP = Provider.of<Afrad>(context).afradd.map((p) {
      return p.name;
    }).toList();

    // Future<String> openContactBook() async {
    //   Contact contact = await ContactPicker().selectContact();
    //   if (contact != null) {
    //     var phoneNumber = contact.phoneNumber.number
    //         .toString()
    //         .replaceAll(new RegExp(r"\s+"), "");
    //     return phoneNumber;
    //   }
    //   return "";
    // }

    TextEditingController phonecon = TextEditingController();
    phonecon.text = widget.oldPerson.phone;
    return Container(
      color: Colors.grey[50],
      height: 500,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Form(
          // key: _formkey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                      initialValue: widget.oldPerson.name,
                      textInputAction: TextInputAction.next,
                      autofocus: true,
                      keyboardType: TextInputType.name,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (str) {
                        if ((listP.contains(str) && !widget.isedit)) {
                          _formKey = false;
                          return "نام تکراری";
                        } else if (widget.isedit) {
                          if (listP.where((pp) {
                            return pp != widget.oldPerson.name;
                          }).contains(str)) {
                            _formKey = false;
                            return "نام از قبل موجود است";
                          } else {
                            _formKey = true;
                            return null;
                          }
                        } else if (str == null) {
                          _formKey = false;
                          return "نام را وارد کنید";
                        } else {
                          _formKey = true;
                          return null;
                        }
                      },
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
                  child: TextFormField(
                    controller: phonecon,
                    // initialValue: widget.oldPerson.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (str) {
                      if (str!.length != 11 || int.tryParse(str) == null) {
                        _formKey = false;
                        return "شماره تلفن اشتباه است";
                      } else {
                        _formKey = true;
                        return null;
                      }
                    },
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 11,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: Icon(Icons.perm_contact_cal),
                            onPressed: () async {
                              // openContactBook().then((x) {
                              //   if (x.contains("+98")) {
                              //     x = "0" + x.split("+98")[1];
                              //   }
                              //   x = x.replaceAll(new RegExp(r'-'), '');
                              //   phonecon.text = x;
                              //   enphone = x;
                              // });
                              final PhoneContact contact =
                                  await FlutterContactPicker.pickPhoneContact();
                              String x;
                              x = contact.phoneNumber!.number!;
                              if (x.contains("+98")) {
                                x = "0" + x.split("+98")[1];
                              }
                              x = x.replaceAll(new RegExp(r'-'), '');

                              phonecon.text = x;
                              enphone = x;
                            }),
                        fillColor: Colors.blue,
                        alignLabelWithHint: true,
                        labelText: "شماره تلفن",
                        labelStyle: TextStyle(),
                        hintStyle: TextStyle()),
                    onChanged: (phone) {
                      enphone = phone;
                    },
                    // textInputAction: Textinput,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    // child: Text("ذخیره کردن"),
                    child:
                        widget.isedit ? Text("ذخیره کردن") : Text("اضافه کردن"),
                    onPressed: () {
                      if (widget.isedit && enname == null) {
                        enname = widget.oldPerson.name;
                      }
                      if (widget.isedit && enphone == null) {
                        enphone = widget.oldPerson.phone;
                      }
                      Person newP = Person(enname!, enphone!, []);
                      if (_formKey) {
                        widget.isedit
                            ? Provider.of<Afrad>(context, listen: false)
                                .updatefromlist(newP, widget.oldPerson, context)
                            : Provider.of<Afrad>(context, listen: false)
                                .addtolist(newP);

                        Navigator.of(context).pop();
                      } else {
                        FocusScope.of(context).requestFocus(new FocusNode());
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
