import 'package:easymakers_tracker/models/easymaker.dart';
import 'package:easymakers_tracker/stores/mission_storage.dart';
import 'package:easymakers_tracker/ui/cards/easymaker_card.dart';
import 'package:easymakers_tracker/ui/forms/easymaker_form.dart';
import 'package:flutter/material.dart';

import '../../stores/easymaker_storage.dart';

class EasymakersPage extends StatefulWidget {
  const EasymakersPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EasymakersPage();
}

class _EasymakersPage extends State<EasymakersPage> {
  final EasymakerStorage _storage = EasymakerStorage();
  final MissionStorage _missionStorage = MissionStorage();
  Future<List<Easymaker>> _easymakers = Future.value([]);

  @override
  void initState() {
    super.initState();
    loadEasymakers();
  }

  void loadEasymakers() {
    setState(() {
      _easymakers = _storage.getAll();
    });
  }

  Future<void> _askForConfirmation(Easymaker easymaker) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Please, confirm that'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('So ' + easymaker.firstName + ' leaves us?'),
                const Text('This will also remove all his missions!'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.red)),
              child: const Text('Confirm'),
              onPressed: () => remove(context, easymaker),
            ),
          ],
        );
      },
    );
  }

  void remove(BuildContext context, Easymaker easymaker) {
    _missionStorage.removeByEasymakerId(easymaker.id);
    _storage.remove(easymaker.id).then((value) => loadEasymakers());
    const snackBar = SnackBar(
      content: Text('Removed!'),
      backgroundColor: Colors.green,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: FutureBuilder(
            future: _easymakers,
            initialData: const <Easymaker>[],
            builder: (BuildContext context,
                AsyncSnapshot<List<Easymaker>> snapshot) {
              return ListView(
                children: (snapshot.data ?? <Easymaker>[]).map((easymaker) {
                  return EasymakerCard(
                    easymaker: easymaker,
                    onRemove: () => _askForConfirmation(easymaker),
                  );
                }).toList(),
              );
            },
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(16),
            child: Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EasymakerFormPage()),
                      ).then((value) => loadEasymakers());
                    },
                    child: const Icon(Icons.add)))),
      ],
    );
  }
}
