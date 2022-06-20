import 'package:accordion/controllers.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:flutter/services.dart';
import 'neomate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
Need to add license info: https://pub.dev/packages/accordion/versions/1.0.3/install
*/

/// * Entypo, Copyright (C) 2012 by Daniel Bruce
///         Author:    Daniel Bruce
///         License:   SIL (http://scripts.sil.org/OFL)
///         Homepage:  http://www.entypo.com
/// * Font Awesome 4, Copyright (C) 2016 by Dave Gandy
///         Author:    Dave Gandy
///         License:   SIL ()
///         Homepage:  http://fortawesome.github.com/Font-Awesome/
/// * Font Awesome 5, Copyright (C) 2016 by Dave Gandy
///         Author:    Dave Gandy
///         License:   SIL (https://github.com/FortAwesome/Font-Awesome/blob/master/LICENSE.txt)
///         Homepage:  http://fortawesome.github.com/Font-Awesome/

// Edited accordion_section to remove _isOpen from if (scrollIntoViewOfItems != ScrollIntoViewOfItems.none etc.
// and changed preferPosition: AutoScrollPosition.begin

class AppConstants {
  static var green = const Color.fromARGB(255, 3, 92, 53);
  static var green_highlight = const Color.fromRGBO(11, 231, 135, 1);
  static var redRow = const Color.fromARGB(255, 254, 222, 222);
  static var colIcon = const Color.fromARGB(255, 255, 255, 255);
}

// Icons
class CustomIcons {
  CustomIcons._();
  static const _kFontFam = 'Neomate';
  static const String? _kFontPkg = null;

  static const IconData droplet =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData heart =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData head_side_virus =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData edit =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData wrench =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ok =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData book =
      IconData(0xf02d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData exclamation_circle =
      IconData(0xf06a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData coffee =
      IconData(0xf0f4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calc =
      IconData(0xf1ec, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bed =
      IconData(0xf236, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snowflake =
      IconData(0xf2dc, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData balance_scale_left =
      IconData(0xf515, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lungs =
      IconData(0xf604, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

// This is the top level object instance with all the Neomate logic
final neomate = Neomate();

// This is the top level notifer for the above
final neomateNotifier = ChangeNotifierProvider<NeomateModel>(
  (ref) => NeomateModel(),
);

class NeomateModel extends ChangeNotifier {
  bool setWeightGrams(double newWeight) {
    bool retVal = neomate.setWeightGrams(newWeight);
    notifyListeners();
    debugPrint('notified');
    return retVal;
  }

  get weightStringShort => neomate.weightStringShort();
  get weightNumGrams => neomate.weightNumGrams();
  List<Drug> drugList(DrugType myType) => neomate.drugList(myType);
}

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Neomate',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: NeomateHome(),
    );
  }
}

class NeomateHome extends StatefulWidget {
  const NeomateHome({Key? key}) : super(key: key);

  @override
  State<NeomateHome> createState() => _NeomateHomeState();
}

class _NeomateHomeState extends State<NeomateHome> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Neomate"),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: IndexedStack(
          index: selectedIndex,
          key: ValueKey<int>(selectedIndex),
          children: [
            NicuCalc(),
            Clinic(),
            Checklists(),
            Reference(),
            About(),
          ],
        ),
      ),
      bottomNavigationBar: _neomateNav(),
    );
  }

// Bottom navigation
  Widget _neomateNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: AppConstants.green_highlight,
      unselectedItemColor: Colors.white,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      currentIndex: selectedIndex,
      onTap: (value) {
        setState(() {
          selectedIndex = value;
        });
        // Respond to item press.
      },
      items: const [
        BottomNavigationBarItem(
          label: 'NICU Calc',
          icon: Icon(Icons.calculate),
        ),
        BottomNavigationBarItem(
          label: 'Clinic',
          icon: Icon(Icons.baby_changing_station),
        ),
        BottomNavigationBarItem(
          label: 'Checklists',
          icon: Icon(Icons.fact_check),
        ),
        BottomNavigationBarItem(
          label: 'Reference',
          icon: Icon(Icons.book),
        ),
        BottomNavigationBarItem(
          label: 'About',
          icon: Icon(Icons.info_outline),
        ),
      ],
    );
  }
}

class NicuCalc extends StatelessWidget {
  NicuCalc({Key? key}) : super(key: key);

  // This is the calculator page

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          weightPanel,
          Expanded(child: calcPanel),
        ]);
  }

  final Widget weightPanel = Container(
    decoration: BoxDecoration(color: AppConstants.green),
    //child: Expanded(
    child: Container(
      decoration: BoxDecoration(
        border: Border.all(),
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
      margin: const EdgeInsets.all(10),
      child: WeightForm(),
    ),
    //),
  );

  static const headerStyle = TextStyle(color: Colors.white, fontSize: 15);
  static headerIcon(IconData myIcon) {
    return Icon(myIcon, color: Colors.white, size: 15);
  }

  final Widget calcPanel = Accordion(
    maxOpenSections: 1,
    headerBackgroundColor: AppConstants.green,
    paddingListHorizontal: 4,
    headerBorderRadius: 4,
    contentBorderRadius: 4,
    scrollIntoViewOfItems: ScrollIntoViewOfItems.slow,
    disableScrolling: false,
    rightIcon: Container(),
    children: [
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.lungs),
        // ignore: prefer_const_constructors
        header: Text(style: headerStyle, 'Intubation'),
        content: const CalcIntubation(),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.droplet),
        // ignore: prefer_const_constructors
        header: Text(style: headerStyle, 'Central Lines'),
        content:
            Icon(Icons.airline_seat_flat, size: 120, color: Colors.blue[200]),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.heart),
        // ignore: prefer_const_constructors
        header: Text(style: headerStyle, 'Cardiac Drugs'),
        content: const CalcCardiac(),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.bed),
        // ignore: prefer_const_constructors
        header: Text(style: headerStyle, 'Sedative Drugs'),
        content: const CalcSedative(),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.head_side_virus),
        // ignore: prefer_const_constructors
        header: Text(style: headerStyle, 'Neurology Drugs'),
        content: const CalcNeurology(),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.exclamation_circle),
        // ignore: prefer_const_constructors
        header: Text(style: headerStyle, 'Emergency Drugs'),
        content: const CalcEmergency(),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.snowflake),
        // ignore: prefer_const_constructors
        header: Text(style: headerStyle, 'Cooling Criteria'),
        content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.edit),
        header:
            // ignore: prefer_const_constructors
            Text(style: headerStyle, 'Admission to Unit'),
        content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.coffee),
        header:
            // ignore: prefer_const_constructors
            Text(style: headerStyle, 'Intravenous Fluids'),
        content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.lungs),
        header:
            // ignore: prefer_const_constructors
            Text(style: headerStyle, 'Oxygenation Index'),
        content: Icon(CustomIcons.heart, size: 70, color: Colors.green[200]),
      ),
      AccordionSection(
        isOpen: false,
        contentHorizontalPadding: 0,
        leftIcon: headerIcon(CustomIcons.wrench),
        header:
            // ignore: prefer_const_constructors
            Text(style: headerStyle, 'Infusion Calculators'),
        content: Icon(Icons.airplay, size: 70, color: Colors.green[200]),
      ),
    ],
  );
}

class CalcIntubation extends StatelessWidget {
  const CalcIntubation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BolusDrugs(selectedDrugs: DrugType.intubation);
  }
}

class CalcCardiac extends StatelessWidget {
  const CalcCardiac({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BolusDrugs(selectedDrugs: DrugType.cardiac);
  }
}

class CalcSedative extends StatelessWidget {
  const CalcSedative({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BolusDrugs(selectedDrugs: DrugType.sedative);
  }
}

class CalcNeurology extends StatelessWidget {
  const CalcNeurology({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BolusDrugs(selectedDrugs: DrugType.neurology);
  }
}

class CalcEmergency extends StatelessWidget {
  const CalcEmergency({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BolusDrugs(selectedDrugs: DrugType.emergency);
  }
}

/// * Widgets for displaying lists of bolus drugs and infusions *

class BolusDrugs extends ConsumerWidget {
  // Build a list of drugs and return a column of rows that contain the formatted drug information

  final DrugType selectedDrugs;

  const BolusDrugs({
    Key? key,
    required this.selectedDrugs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(neomateNotifier);
    List<Drug> myDrugs = notifier.drugList(selectedDrugs);
    List<Widget> drugRows = [];
    bool redRow = true;

    for (var drug in myDrugs) {
      if (drug is DrugMultiplier) {
        // Row to display drug based on a multiple of the weight
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and dose column
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drug.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 2)),
                      Text(
                        '(${drug.dose})',
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(3, 0, 3, 0)),
                // Calculated dose and instructions column
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: drugDetail(drug),
                  ),
                ),
              ],
            ),
          ),
        ));
        redRow = !redRow;
      }
      if (drug is DrugBanded) {
        // Row to display drug based on bandings of the weight
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and dose column
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drug.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 2)),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(3, 0, 3, 0)),
                // Calculated dose and instructions column
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: drugDetail(drug),
                  ),
                ),
              ],
            ),
          ),
        ));
        redRow = !redRow;
      }
      if (drug is DrugInfo) {
        // Row to display drug that's information only
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and dose column
                Expanded(
                  flex: 2,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        drug.name,
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 2)),
                    ],
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(3, 0, 3, 0)),
                // Calculated dose and instructions column
                Expanded(
                  flex: 3,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: drugDetail(drug),
                  ),
                ),
              ],
            ),
          ),
        ));
        redRow = !redRow;
      }
      if (drug is DrugInfusion) {
        // Row to display drug that's information only
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${drug.name} infusion',
                  style: const TextStyle(fontSize: 16),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 0)),
                Text(
                  drug.calcPreNarrative,
                  style: const TextStyle(fontSize: 14),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Center(
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1, color: Colors.black54),
                      ),
                    ),
                    child: Text(
                      drug.calcTop,
                      style: const TextStyle(fontSize: 11),
                    ),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 4, 0, 0)),
                Center(
                  child: Text(
                    drug.calcBottom,
                    style: const TextStyle(fontSize: 11),
                  ),
                ),
                const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                Text(
                  drug.calcPostNarrative,
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ));
        redRow = !redRow;
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: drugRows,
    );
  }

  List<Widget> drugDetail(Drug drug) {
    // Put together the drug details column
    List<Widget> myDetails = [];

    myDetails.addAll(drugDetailInner(drug));

    myDetails.add(const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 2)));
    myDetails.add(Text(
      drug.notes,
      style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
    ));
    return myDetails;
  }

  List<Widget> drugDetailInner(Drug drug) {
    // Recursive method to unwrap a list of follow-on doses and display nicely
    List<Widget> ret = [
      Text.rich(TextSpan(children: [
        (drug.qualifier == '')
            ? const TextSpan(text: '')
            : TextSpan(
                text: '${drug.qualifier}:\n',
                style: const TextStyle(fontSize: 13),
              ),
        TextSpan(
          text: '${drug.calcString} ',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        TextSpan(
          text: '${drug.units} ',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        TextSpan(
          text: '${drug.instructions}',
          style: const TextStyle(fontSize: 13),
        ),
      ]))
    ];
    if (drug.followOn is Drug) {
      ret.add(const Padding(padding: EdgeInsets.fromLTRB(0, 2, 0, 2)));
      ret.addAll(drugDetailInner(drug.followOn!));
    }
    return ret;
  }
}

/// * Widgets for inputting and displaying weight *

class WeightForm extends ConsumerWidget {
  WeightForm({Key? key}) : super(key: key);
  final _weightInput = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(neomateNotifier);
    var initVal = "";
    if (notifier.weightStringShort != "NaN") {
      initVal = notifier.weightStringShort;
    }

    return Row(children: <Widget>[
      Flexible(
        flex: 1,
        fit: FlexFit.loose,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: TextFormField(
            key: _weightInput,
            initialValue: initVal,
            decoration: InputDecoration(
              constraints: BoxConstraints.loose(const Size.fromHeight(30)),
              contentPadding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              border: const OutlineInputBorder(),
            ),
            textAlign: TextAlign.right,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4),
            ],
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(0, 0, 10, 0)),
      const Flexible(
        flex: 1,
        child: Text('grams'),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.fromHeight(30)),
          child: ElevatedButton(
            onPressed: () {
              String outcome = "";
              if (_weightInput.currentState!.value != null) {
                double? tempWeight =
                    double.tryParse(_weightInput.currentState!.value);
                if (tempWeight is double) {
                  if (tempWeight < Neomate.minWeightGrams) {
                    outcome = "Weight too low - please recheck";
                  } else if (tempWeight > Neomate.maxWeightGrams) {
                    outcome =
                        "Weight too high - please recheck - this app is for neonatal patients only";
                  } else {
                    ref.read(neomateNotifier).setWeightGrams(tempWeight);
                    FocusScope.of(context).unfocus();
                    outcome = "Parameters calculated";
                  }
                } else {
                  outcome = "That's not a valid weight - please recheck";
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(outcome),
                  ),
                );
              }
            },
            child: const Text('Calculate'),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
      Flexible(
        flex: 2,
        fit: FlexFit.tight,
        child: ConstrainedBox(
          constraints: BoxConstraints.loose(const Size.fromHeight(30)),
          child: ElevatedButton(
            onPressed: () {},
            child: const Text('Gestation'),
          ),
        ),
      ),
    ]);
    //);
  }
}

class Clinic extends StatelessWidget {
  const Clinic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Clinic");
  }
}

class Checklists extends StatelessWidget {
  const Checklists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Checklists");
  }
}

class Reference extends StatelessWidget {
  const Reference({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("Reference");
  }
}

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text("About");
  }
}
