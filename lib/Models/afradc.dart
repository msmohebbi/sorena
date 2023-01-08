// ignore_for_file: avoid_function_literals_in_foreach_calls, depend_on_referenced_packages

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Afrad with ChangeNotifier {
  Afrad() {
    _afradd = updateLocal();
  }
  List<Person> _afradd = [];
  List<Person> get afradd {
    return _afradd;
  }

  List<Person> updateLocal() {
    DataBaseMan dbman = DataBaseMan();
    dbman.fetchAfrad().then((val) {
      _afradd = val;
      // notifyListeners();
      dbman.fetchAfradtoGrooha().then((val) {
        val.forEach((x) {
          _afradd
              .firstWhere((p) {
                return p.name == x["aname"];
              })
              .groupp
              .add(Group(x["gname"]!));
        });
        notifyListeners();
      });
    });
    return _afradd;
  }

  void addtolist(Person p1) {
    DataBaseMan dbman = DataBaseMan();
    dbman.insertAfrad(p1).then((x) {
      updateLocal();
      // notifyListeners();
    });
  }

  void updatefromlist(Person newp1, Person oldp1, BuildContext context) {
    DataBaseMan dbman = DataBaseMan();
    dbman.updateAfrad(newp1, oldp1).then((x) {
      updateLocal();
      Provider.of<Labelha>(context, listen: false)
          .updateLocal(); // notifyListeners();
    });
  }

  void removefromlist(Person p1) {
    DataBaseMan dbman = DataBaseMan();
    dbman.deleteAfrad(p1.name);

    updateLocal();
    // notifyListeners();
  }

  void addremovetoGroup(Person p1, Group g1, BuildContext context) {
    DataBaseMan dbman = DataBaseMan();
    dbman.addDeleteAfradtoGrooha(p1, g1).then((_) {
      updateLocal();
      Provider.of<Labelha>(context, listen: false).updateLocal();
    });
  }

  void restoretolist(Person p1, int ind) {
    _afradd.insert(ind, p1);
    notifyListeners();
  }
}

class Grooha with ChangeNotifier {
  Grooha() {
    _grooha = updateLocal();
  }
  List<Group> _grooha = [];
  List<Group> _oldG = [];
  List<Group> get oldG {
    return _oldG;
  }

  List<Group> get grooha {
    return _grooha;
  }

  List<Group> updateLocal() {
    DataBaseMan dbman = DataBaseMan();
    dbman.fetchGrooha().then((val) {
      _grooha = val;
      notifyListeners();
    });
    return _grooha;
  }

  void addtolist(Group g1) {
    // _grooha.add(g1);
    DataBaseMan dbman = DataBaseMan();
    dbman.insertGrooha(g1);
    updateLocal();
    notifyListeners();
  }

  void updatefromlist(Group newg1, Group oldg1, BuildContext context) {
    // _afradd.add(p1);
    DataBaseMan dbman = DataBaseMan();
    dbman.updateGrooha(newg1, oldg1).then((x) {
      updateLocal();
      Provider.of<Labelha>(context, listen: false).updateLocal();
      // Afrad().updateLocal();
      // Afrad().notifyListeners();
      // notifyListeners();
    });
  }

  void removefromlist(Group g1) {
    _oldG = _grooha;
    DataBaseMan dbman = DataBaseMan();
    dbman.deleteGrooha(g1.name);

    updateLocal();
    // log(_oldG);
    // _grooha.remove(g1);
    notifyListeners();
  }

  reOrderList(List<Group> newG) {
    newG.forEach((element) {
      _oldG = _grooha;
      DataBaseMan dbman = DataBaseMan();
      dbman.deleteGrooha(element.name);
      dbman.insertGrooha(element);
    });
    notifyListeners();
  }

  void restoretolist(Group g1, int ind) {
    _grooha.insert(ind, g1);
    notifyListeners();
  }
}

class DataBaseMan {
  late Future<Database> database;
  Future<void> firstInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    log("sakht db1");
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      onCreate: (db, version) async {
        log("sakht db");
        await db.execute(
          "CREATE TABLE grooha(name TEXT PRIMARY KEY)",
        );
        await db.execute(
          "CREATE TABLE afrad(name TEXT PRIMARY KEY, phone TEXT)",
        );
        await db.execute(
          "CREATE TABLE afradtogrooha(aname TEXT ,gname TEXT,  PRIMARY KEY (aname, gname))",
        );
        await db.execute(
          "CREATE TABLE afradtolabelha(aname TEXT, gname TEXT, number INT, PRIMARY KEY (aname, gname))",
        );
      },
      onUpgrade: (db, version, newversion) async {
        await db.execute(
          "CREATE TABLE afradtolabelha(aname TEXT, gname TEXT, number INT, PRIMARY KEY (aname, gname))",
        );
      },
      version: 2,
    );
  }

  Future<void> insertAfrad(Person p) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'afrad',
      p.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Person>> fetchAfrad() async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('afrad');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Person(
        maps[i]['name'],
        maps[i]['phone'],
        [],
      );
    });
  }

  Future<void> updateAfrad(Person newp, Person oldp) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final db = await database;

    // Update the given Dog.
    await db.update(
      'Afrad',
      newp.toMap(),
      // Ensure that the Dog has a matching id.
      where: "name = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [oldp.name],
    );
    await db.update(
      'afradtogrooha',
      {"aname": newp.name},
      // Ensure that the Dog has a matching id.
      where: "aname = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [oldp.name],
    );
    await db.update(
      'afradtolabelha',
      {"aname": newp.name},
      // Ensure that the Dog has a matching id.
      where: "aname = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [oldp.name],
    );
  }

  Future<void> deleteAfrad(String name) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final db = await database;

    await db.delete(
      'afrad',
      where: "name = ?",
      whereArgs: [name],
    );
    await db.delete(
      'afradtogrooha',
      where: "aname = ?",
      whereArgs: [name],
    );
    await db.delete(
      'afradtolabelha',
      where: "aname = ?",
      whereArgs: [name],
    );
  }

  Future<List<Map<String, String>>> fetchAfradtoGrooha() async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Query the table for all The Dogs.

    final List<Map<String, dynamic>> maps = await db.query('afradtogrooha');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Map<String, String>> list = List.generate(maps.length, (i) {
      return {
        "aname": maps[i]['aname'],
        "gname": maps[i]['gname'],
      };
    });
    // log(list);
    return (list);
  }

  Future<void> addDeleteAfradtoGrooha(Person p, Group g) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('afradtogrooha');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Map<String, String>> list = List.generate(maps.length, (i) {
      return {
        "aname": maps[i]['aname'],
        "gname": maps[i]['gname'],
      };
    });
    Map<String, String> newEntry = {"aname": p.name, "gname": g.name};
    if (list.where((x) {
      return x["aname"] == newEntry["aname"] && x["gname"] == newEntry["gname"];
    }).isNotEmpty) {
      await db.delete(
        'afradtogrooha',
        where: "aname = ? and gname=?",
        whereArgs: [p.name, g.name],
      );
      await db.delete(
        'afradtolabelha',
        where: "aname = ? and gname=?",
        whereArgs: [p.name, g.name],
      );
    } else {
      await db.insert(
        'afradtogrooha',
        newEntry,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  // Future<void> deleteAfradtoGrooha(String name) async {
  //   // Get a reference to the database.
  //   database = openDatabase(
  //     join(await getDatabasesPath(), 'soorena_database.db'),
  //     version: 1,
  //   );
  //   final db = await database;

  //   await db.delete(
  //     'afradtogrooha',
  //     where: "aname = ?",
  //     whereArgs: [name],
  //   );
  // }

  // Future<void> deleteAfradtoGrooha2(String name) async {
  //   // Get a reference to the database.
  //   database = openDatabase(
  //     join(await getDatabasesPath(), 'soorena_database.db'),
  //     version: 1,
  //   );
  //   final db = await database;

  //   await db.delete(
  //     'afradtogrooha',
  //     where: "gname = ?",
  //     whereArgs: [name],
  //   );
  // }

  Future<List<Map<String, dynamic>>> fetchAfradtoLabelha() async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Query the table for all The Dogs.

    final List<Map<String, dynamic>> maps = await db.query('afradtolabelha');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Map<String, dynamic>> list = List.generate(maps.length, (i) {
      return {
        "aname": maps[i]['aname'],
        "gname": maps[i]['gname'],
        "number": maps[i]['number'],
      };
    });
    // log(list);
    return (list);
  }

  Future<String> addDeleteAfradtoLabelha(Person p, Group g, int n) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('afradtolabelha');
    // Convert the List<Map<String, dynamic> into a List<Dog>.
    List<Map<String, dynamic>> list = List.generate(maps.length, (i) {
      return {
        "aname": maps[i]['aname'],
        "gname": maps[i]['gname'],
        "number": maps[i]['number'],
      };
    });
    Map<String, dynamic> newEntry = {
      "aname": p.name,
      "gname": g.name,
      "number": n
    };
    final listofx = list.where((x) {
      return x["aname"] == newEntry["aname"] && x["gname"] == newEntry["gname"];
    });
    if (listofx.isNotEmpty) {
      log("dell");
      await db.delete(
        'afradtolabelha',
        where: "aname = ? and gname=?",
        whereArgs: [p.name, g.name],
      );
      if (listofx.first["number"] != n) {
        log("dellinsert");
        await db.insert(
          'afradtolabelha',
          newEntry,
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }
    } else {
      log("insert");
      await db.insert(
        'afradtolabelha',
        newEntry,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    return "";
  }

  // Future<void> deleteAfradtoLabelha(String gname, String aname) async {
  //   // Get a reference to the database.
  //   database = openDatabase(
  //     join(await getDatabasesPath(), 'soorena_database.db'),
  //     version: 1,
  //   );
  //   final db = await database;

  //   await db.delete(
  //     'afradtolabelha',
  //     where: "aname = ? and gname = ?",
  //     whereArgs: [gname, aname],
  //   );
  // }

  // Future<void> deleteAfradtoLabelhabyperson(String name) async {
  //   // Get a reference to the database.
  //   database = openDatabase(
  //     join(await getDatabasesPath(), 'soorena_database.db'),
  //     version: 1,
  //   );
  //   final db = await database;

  //   await db.delete(
  //     'afradtolabelha',
  //     where: "aname = ?",
  //     whereArgs: [name],
  //   );
  // }

  // Future<void> deleteAfradtoLabelhabygroup(String name) async {
  //   // Get a reference to the database.
  //   database = openDatabase(
  //     join(await getDatabasesPath(), 'soorena_database.db'),
  //     version: 1,
  //   );
  //   final db = await database;

  //   await db.delete(
  //     'afradtolabelha',
  //     where: "gname = ?",
  //     whereArgs: [name],
  //   );
  // }

  Future<void> insertGrooha(Group g) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Insert the Dog into the correct table. Also specify the
    // `conflictAlgorithm`. In this case, if the same dog is inserted
    // multiple times, it replaces the previous data.
    await db.insert(
      'grooha',
      g.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Group>> fetchGrooha() async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final Database db = await database;

    // Query the table for all The Dogs.
    final List<Map<String, dynamic>> maps = await db.query('grooha');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Group(
        maps[i]['name'],
      );
    });
  }

  Future<void> updateGrooha(Group newg, Group oldg) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final db = await database;

    // Update the given Dog.
    await db.update(
      'grooha',
      newg.toMap(),
      // Ensure that the Dog has a matching id.
      where: "name = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [oldg.name],
    );

    await db.update(
      'afradtogrooha',
      {"gname": newg.name},
      // Ensure that the Dog has a matching id.
      where: "gname = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [oldg.name],
    );

    await db.update(
      'afradtolabelha',
      {"gname": newg.name},
      // Ensure that the Dog has a matching id.
      where: "gname = ?",
      // Pass the Dog's id as a whereArg to prevent SQL injection.
      whereArgs: [oldg.name],
    );
  }

  Future<void> deleteGrooha(String name) async {
    // Get a reference to the database.
    database = openDatabase(
      join(await getDatabasesPath(), 'soorena_database.db'),
      version: 1,
    );
    final db = await database;

    await db.delete(
      'grooha',
      where: "name = ?",
      whereArgs: [name],
    );
    await db.delete(
      'afradtogrooha',
      where: "gname = ?",
      whereArgs: [name],
    );
    await db.delete(
      'afradtolabelha',
      where: "gname = ?",
      whereArgs: [name],
    );
  }
}

class Person {
  Person(this.name, this.phone, this.groupp);
  String name;
  String phone;
  List<Group> groupp;
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class Group {
  Group(this.name);
  String name;
  Map<String, dynamic> toMap() {
    return {
      'name': name,
    };
  }
}

class Label {
  Label(this.number, this.color, this.text);
  int number;
  Color color;
  String text;
  Map<String, dynamic> toMap() {
    return {
      'number': number,
      'acolor': color.alpha,
      'rcolor': color.red,
      'gcolor': color.green,
      'bcolor': color.blue,
      'text': text
    };
  }
}

class Labelha with ChangeNotifier {
  Labelha() {
    _afradgroohatolabelha = updateLocal();
  }
  final List<Label> _labelha = [
    Label(1, Colors.greenAccent[700]!, ""),
    Label(2, Colors.orangeAccent[700]!, ""),
    Label(3, Colors.red[600]!, ""),
    Label(4, Colors.blue, ""),
  ];
  List<Label> get labelha {
    return _labelha;
  }

  List<Map<String, dynamic>> _afradgroohatolabelha = [];
  List<Map<String, dynamic>> get afradgroohatolabelha {
    return _afradgroohatolabelha;
  }

  List<Map<String, dynamic>> updateLocal() {
    DataBaseMan dbman = DataBaseMan();
    log("updated");
    dbman.fetchAfradtoLabelha().then((val) {
      _afradgroohatolabelha = val;
      notifyListeners();
    });
    return _afradgroohatolabelha;
  }

  void addremovetoLabelha(Person p1, Group g1, int n) {
    DataBaseMan dbman = DataBaseMan();
    dbman.addDeleteAfradtoLabelha(p1, g1, n).then((_) {
      updateLocal();
    });
    // notifyListeners();
  }
}
