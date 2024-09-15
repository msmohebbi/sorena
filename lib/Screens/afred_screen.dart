// import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:flutter/services.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Models/afradc.dart';
import '../index.dart';

class AfradScreen extends StatefulWidget {
  const AfradScreen({super.key});
  @override
  AfradScreenState createState() => AfradScreenState();
}

class AfradScreenState extends State<AfradScreen> {
  @override
  Widget build(BuildContext context) {
    var number1 = Provider.of<Afrad>(context).afradd;
    var groohaa = Provider.of<Grooha>(context).grooha;

    // ignore: prefer_is_empty
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (pop, _) async {
        Provider.of<Index>(context, listen: false).changeIndex(0);
      },
      child: number1.isEmpty
          ? const Center(
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
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: number1.map((p) {
                  // int pindex = number1.indexOf(p);
                  return Container(
                    margin: const EdgeInsets.only(bottom: 1),
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
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                              textAlign: TextAlign.right,
                              softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          Text(
                            p.phone,
                            style: const TextStyle(color: Colors.white60),
                            textAlign: TextAlign.left,
                            textDirection: TextDirection.ltr,
                          ),
                        ],
                      ),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          PopupMenuButton(
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
                                  value: [p, g],
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
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
                                );
                              }).toList();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.keyboard_arrow_down_outlined),
                            ),
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
                            padding: const EdgeInsets.all(0),
                            visualDensity: VisualDensity.compact,
                            tooltip: "حذف فرد",
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[900],
                            ),
                            onPressed: () {
                              Provider.of<Afrad>(context, listen: false)
                                  .removefromlist(p);
                              ScaffoldMessenger.of(context)
                                  .hideCurrentSnackBar();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBar(
                                content: const Text(""),
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
                            icon: const Icon(
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
                            icon: const Icon(
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
                            icon: const Icon(
                              Icons.call,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              launchUrl(Uri.parse('tel://${p.phone}'));
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
    );
  }
}

class ModalBAfrad extends StatefulWidget {
  const ModalBAfrad({super.key, required this.isedit, required this.oldPerson});
  final bool isedit;
  final Person oldPerson;

  @override
  ModalBAfradState createState() => ModalBAfradState();
}

class ModalBAfradState extends State<ModalBAfrad> {
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
    bool formKey = false;
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
          // key: formkey,
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
                          formKey = false;
                          return "نام تکراری";
                        } else if (widget.isedit) {
                          if (listP.where((pp) {
                            return pp != widget.oldPerson.name;
                          }).contains(str)) {
                            formKey = false;
                            return "نام از قبل موجود است";
                          } else {
                            formKey = true;
                            return null;
                          }
                        } else if (str == null) {
                          formKey = false;
                          return "نام را وارد کنید";
                        } else {
                          formKey = true;
                          return null;
                        }
                      },
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
                  child: TextFormField(
                    controller: phonecon,
                    // initialValue: widget.oldPerson.phone,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (str) {
                      if (str!.length != 11 || int.tryParse(str) == null) {
                        formKey = false;
                        return "شماره تلفن اشتباه است";
                      } else {
                        formKey = true;
                        return null;
                      }
                    },
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    maxLength: 11,
                    autofocus: true,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                            icon: const Icon(Icons.perm_contact_cal),
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
                                x = "0${x.split("+98")[1]}";
                              }
                              x = x.replaceAll(RegExp(r'-'), '');

                              phonecon.text = x;
                              enphone = x;
                            }),
                        fillColor: Colors.blue,
                        alignLabelWithHint: true,
                        labelText: "شماره تلفن",
                        labelStyle: const TextStyle(),
                        hintStyle: const TextStyle()),
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
                    child: widget.isedit
                        ? const Text("ذخیره کردن")
                        : const Text("اضافه کردن"),
                    onPressed: () {
                      if (widget.isedit && enname == null) {
                        enname = widget.oldPerson.name;
                      }
                      if (widget.isedit && enphone == null) {
                        enphone = widget.oldPerson.phone;
                      }
                      Person newP = Person(enname!, enphone!, []);
                      if (formKey) {
                        widget.isedit
                            ? Provider.of<Afrad>(context, listen: false)
                                .updatefromlist(newP, widget.oldPerson, context)
                            : Provider.of<Afrad>(context, listen: false)
                                .addtolist(newP);

                        Navigator.of(context).pop();
                      } else {
                        FocusScope.of(context).requestFocus(FocusNode());
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
