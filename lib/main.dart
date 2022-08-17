import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'neomate.dart';
import 'neomate_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:url_launcher/url_launcher.dart';
import 'neomate_checklists.dart';
import 'package:page_transition/page_transition.dart';
import 'package:async/async.dart';

class AppConstants {
  static var green = const Color.fromRGBO(27, 126, 90, 1);
  static var greenHighlight = const Color.fromRGBO(11, 231, 135, 1);
  static var redRow = const Color.fromARGB(255, 254, 222, 222);
  static var colIcon = const Color.fromARGB(255, 255, 255, 255);
  static var blueList = const Color.fromRGBO(3, 148, 148, 1);
  static var greyRow = const Color.fromRGBO(198, 234, 252, 1);
  static var colChecklistCard = const Color.fromRGBO(69, 123, 135, 1);
  static var colChecklistAbstract = const Color.fromRGBO(236, 241, 243, 1);

  static List<Color> colChecklist = const [
    Color.fromRGBO(255, 246, 235, 1),
    Color.fromRGBO(218, 230, 239, 1),
    Color.fromRGBO(232, 253, 241, 1),
    Color.fromRGBO(251, 234, 234, 1),
    //Color.fromRGBO(235, 253, 239, 1),
  ];

  static List<Color> colIcons = [
    const Color.fromRGBO(172, 158, 0, 1),
    const Color.fromRGBO(0, 111, 148, 1),
    const Color.fromRGBO(5, 142, 0, 1),
    const Color.fromRGBO(174, 0, 0, 1),
  ];
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
  static const IconData headSideVirus =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData edit =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData wrench =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData ok =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData book =
      IconData(0xf02d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData exclamationCircle =
      IconData(0xf06a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData coffee =
      IconData(0xf0f4, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData calc =
      IconData(0xf1ec, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bed =
      IconData(0xf236, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData snowflake =
      IconData(0xf2dc, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData balanceScaleLeft =
      IconData(0xf515, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData lungs =
      IconData(0xf604, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

// This is the top level notifer for the neomate object
final neomateNotifier = ChangeNotifierProvider<NeomateModel>(
  (ref) => NeomateModel(),
);

class NeomateModel extends ChangeNotifier {
  bool setWeightGrams(double newWeight) {
    bool retVal = _neomate.setWeightGrams(newWeight);
    notifyListeners();
    debugPrint('notified');
    return retVal;
  }

  final _neomate = Neomate();

  CalcResults dailyFluids(
          double dex, double sodium, double potassium, double total) =>
      _neomate.dailyFluids(
          dex: dex, sodium: sodium, potassium: potassium, total: total);

  get weightStringShort => _neomate.weightStringShort();
  get weightValid => _neomate.weightValid;
  get weightNumGrams => _neomate.weightNumGrams();
  get weightNumKg => _neomate.weightNumKg();
  List<Drug> drugList(DrugType myType) => _neomate.drugList(myType);
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)),
      home: const NeomateHome(),
    );
  }
}

/// -------- Main Structure -------- ///

class NeomateHome extends ConsumerStatefulWidget {
  const NeomateHome({Key? key}) : super(key: key);

  @override
  NeomateHomeState createState() => NeomateHomeState();
}

class NeomateHomeState extends ConsumerState<NeomateHome> {
  int selectedIndex = 0;
  final weightDialogKey = GlobalKey<WeightDialogState>();
  bool weightEstimate = false;

  @override
  void initState() {
    super.initState();
    ref.read(neomateNotifier);
  }

  // Page names
  final List<String> _appName = [
    'NeoMate NICU Calc',
    'NeoMate Checklists',
    'NeoMate Reference',
    'About NeoMate',
  ];
  // Weight flag for each page
  final List<bool> _hasWeight = [true, false, false, false];

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(neomateNotifier);
    var myWeightString = notifier.weightStringShort;
    if (myWeightString.isEmpty) {
      myWeightString = 'weight';
    }
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.0),
            child: Image.asset('graphics/icon-57.png'),
          ),
        ),
        title: Text(_appName[selectedIndex]),
        actions: [
          // If this page uses the global baby weight then build a button to
          // display and change the weight
          Visibility(
            visible: _hasWeight[selectedIndex],
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 8, 10, 8),
              child: TextButton(
                style: TextButton.styleFrom(
                  side: const BorderSide(color: Colors.white70, width: 1),
                  padding: const EdgeInsets.all(0),
                ),
                onPressed: () {
                  weightDialog();
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      myWeightString,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Visibility(
                      visible: weightEstimate,
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: const [
                          Text(
                            ' estimated ',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.redAccent,
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: IndexedStack(
          index: selectedIndex,
          key: ValueKey<int>(selectedIndex),
          children: const [
            NicuCalc(),
            //Clinic(),
            Checklists(),
            References(),
            About(),
          ],
        ),
      ),
      bottomNavigationBar: neomateNav(),
    );
  }

  void weightDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Set baby weight'),
            insetPadding: const EdgeInsets.fromLTRB(15, 5, 15, 10),
            content: WeightDialog(key: weightDialogKey),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    if (weightDialogKey.currentState is WeightDialogState) {
                      if (weightDialogKey.currentState!.valid) {
                        dismissDialog();
                        var tempWeight = weightDialogKey.currentState!.weight;
                        weightEstimate = weightDialogKey.currentState!.estimate;
                        ref.read(neomateNotifier).setWeightGrams(tempWeight);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                'Weight set to ${tempWeight.toStringAsFixed(0)} g'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Set Weight')),
              TextButton(
                onPressed: () {
                  dismissDialog();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Weight change cancelled'),
                    ),
                  );
                },
                child: const Text('Cancel'),
              )
            ],
          );
        });
  }

  dismissDialog() {
    Navigator.pop(context);
  }

// Bottom navigation
  Widget neomateNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.black,
      selectedItemColor: AppConstants.greenHighlight,
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
        /*BottomNavigationBarItem(
          label: 'Clinic',
          icon: Icon(Icons.baby_changing_station),
        ),*/
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

/// -------- Weight Selection -------- ///

class WeightDialog extends StatefulWidget {
  const WeightDialog({Key? key}) : super(key: key);

  @override
  State<WeightDialog> createState() => WeightDialogState();
}

class WeightDialogState extends State<WeightDialog> {
  String weightString = '';
  double weight = 0;
  final weightController = TextEditingController();
  bool estimate = false;
  String weightMessage = '';
  bool valid = false;

  weightChanged() {
    // Called whenever the textbox changes

    if (weightController.text != weightString) {
      setState(() {
        estimate = false;
        weightString = weightController.text;
        weightMessage = '';
        if (weightString.length > 2) {
          double? tempWeight = double.tryParse(weightString);
          if (tempWeight is double) {
            if (tempWeight < Neomate.minWeightGrams) {
              weightMessage = "Weight too low please double check";
              valid = false;
            } else if (tempWeight > Neomate.maxWeightGrams) {
              weightMessage =
                  "Too high, this app is for neonatal patients only";
              valid = false;
            } else {
              valid = true;
              weight = tempWeight;
            }
          }
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Build a list ofestimate buttons for all the gestations
    final List<Widget> estimateButtons = [];
    Neomate.weightEstimates.forEach((weeks, estWeight) => {
          estimateButtons.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
              child: SizedBox(
                height: 32,
                width: 42,
                child: TextButton(
                  style: TextButton.styleFrom(
                      side: const BorderSide(color: Colors.indigo, width: 2),
                      backgroundColor: AppConstants.colIcons[1]),
                  child: Text(
                    weeks.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    setState(() {
                      weightString = estWeight.toStringAsFixed(0);
                      weight = estWeight;
                      weightController.text = weightString;
                      weightMessage =
                          'Estimate based on ${weeks.toStringAsFixed(0)} weeks gestation';
                      estimate = true;
                      valid = true;
                      weightController.selection = TextSelection.fromPosition(
                          TextPosition(offset: weightController.text.length));
                    });
                  },
                ),
              ),
            ),
          )
        });

    // Handle validation and messages when the weight is changed
    weightController.addListener(weightChanged);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
            flex: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(padding: EdgeInsets.fromLTRB(15, 0, 0, 0)),
                SizedBox(
                  width: 80,
                  height: 40,
                  child: TextField(
                    autofocus: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.fromLTRB(0, 5, 10, 0),
                        suffixText: 'g'),
                    controller: weightController,
                    textAlign: TextAlign.right,
                    keyboardType: const TextInputType.numberWithOptions(
                      signed: false,
                      decimal: false,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Visibility(
                    visible: weightMessage.isNotEmpty,
                    maintainAnimation: true,
                    maintainState: true,
                    maintainSize: true,
                    child: SizedBox(
                      width: 150,
                      height: 30,
                      child: Text(
                        weightMessage,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.redAccent,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        const Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 20, 0, 10),
              child: Text('Estimate weight from gestation '),
            )),
        Flexible(
            flex: 5, child: Wrap(runSpacing: 4, children: estimateButtons)),
      ],
    );
  }

  @override
  void dispose() {
    // Good housekeeping
    weightController.dispose();
    super.dispose();
  }
}

/// -------- Nicu Calculator Page -------- ///

class NicuCalc extends StatefulWidget {
  const NicuCalc({Key? key}) : super(key: key);

  @override
  State<NicuCalc> createState() => NicuCalcState();
}

class NicuCalcState extends State<NicuCalc> {
  final ScrollController _scrollController = ScrollController();

  var scrollTimer = RestartableTimer(const Duration(milliseconds: 500), () {});

  final calcNavKey = GlobalKey<NavigatorState>();

  final List<GlobalKey> itemKeys = List<GlobalKey>.generate(11, (_) {
    return GlobalKey();
  });

  int openIndex = -1;
  var itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await calcNavKey.currentState!.maybePop(),
      child: Navigator(
          key: calcNavKey,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => buildScroller(context),
            );
          }),
    );
  }

  //@override
  Widget buildScroller(BuildContext context) {
    _scrollController.addListener(() {});
    itemCount = 0;
    openIndex = -1;
    return SingleChildScrollView(
      controller: _scrollController,
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      child: ExpansionPanelList.radio(
          elevation: 3,
          animationDuration: const Duration(milliseconds: 400),
          expansionCallback: (int index, bool isExpanded) {
            // Lots of messing around as the callbacks are a bit strange
            // and it's weirdly difficult to scroll the open panel
            // to the top of the screen, which should be quite normal behaviour
            //
            // We can find the height of each panel header by interrogating
            // the first item. Could just be a constant but doing this avoids
            // a change elsewhere breaking this function.
            var headerHeight =
                (itemKeys[1].currentContext?.findRenderObject() as RenderBox)
                    .size
                    .height;
            if (index == openIndex) {
              // Item is being closed while we're still waiting to animate
              // so stop the timer
              scrollTimer.cancel();
            }
            if (isExpanded && index == openIndex) {
              // Closing an open panel
              openIndex = -1;
            }
            if (!isExpanded && index != openIndex) {
              // Opening a closed panel
              if (scrollTimer.isActive) {
                scrollTimer.cancel();
              }
              // Waiting until all the widgets have rendered
              WidgetsBinding.instance.addPostFrameCallback((_) {
                // Give time for the panel open animation to finish
                scrollTimer =
                    RestartableTimer(const Duration(milliseconds: 440), () {
                  var scrollLoc = 16 + ((index) * headerHeight);
                  if (scrollLoc > _scrollController.position.maxScrollExtent) {
                    // Avoid scrolling past the end of the list as it gives
                    // an annoying bounceback behaviour
                    scrollLoc = _scrollController.position.maxScrollExtent;
                  }
                  // Don't try to scroll if we're already at the top
                  if (scrollLoc > headerHeight) {
                    _scrollController.animateTo(scrollLoc,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease);
                  }
                  openIndex = index;
                });
              });
            }
          },
          children: [
            calcItem(
                itemBody: const CalcIntubation(),
                itemTitle: 'Intubation',
                itemIcon: CustomIcons.lungs),
            calcItem(
              itemBody: const CalcCentral(),
              itemTitle: 'Central Lines',
              itemIcon: CustomIcons.droplet,
            ),
            calcItem(
              itemBody: const CalcCardiac(),
              itemTitle: 'Cardiac Drugs',
              itemIcon: CustomIcons.heart,
            ),
            calcItem(
              itemBody: const CalcSedative(),
              itemTitle: 'Sedative Drugs',
              itemIcon: CustomIcons.bed,
            ),
            calcItem(
              itemBody: const CalcNeurology(),
              itemTitle: 'Neurology Drugs',
              itemIcon: CustomIcons.headSideVirus,
            ),
            calcItem(
                itemBody: const CalcEmergency(),
                itemTitle: 'Emergency Drugs',
                itemIcon: CustomIcons.exclamationCircle),
            calcItem(
              itemBody: const CalcCooling(),
              itemTitle: 'Cooling Criteria',
              itemIcon: CustomIcons.snowflake,
            ),
            calcItem(
              itemBody: const CalcIVFluids(),
              itemTitle: 'Intravenous Fluids',
              itemIcon: CustomIcons.coffee,
            ),
            calcItem(
              itemBody: const Ventilation(),
              itemTitle: 'Ventilation and OI',
              itemIcon: CustomIcons.lungs,
            ),
            calcItem(
              itemBody: const AnyDrug(),
              itemTitle: 'Infusion Calculators',
              itemIcon: CustomIcons.wrench,
            ),
          ]),
    );
  }

  ExpansionPanelRadio calcItem(
      {required Widget itemBody,
      required String itemTitle,
      required IconData itemIcon}) {
    itemCount++;
    var itemColor = itemCount % AppConstants.colIcons.length;
    var itemKey = itemKeys[itemCount];
    return ExpansionPanelRadio(
      canTapOnHeader: true,
      headerBuilder: (_, isExpanded) => Container(
          key: itemKey,
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: Row(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Icon(
                      itemIcon,
                      color: AppConstants.colIcons[itemColor],
                    ),
                  ),
                ),
                Text(
                  itemTitle,
                  style: const TextStyle(fontSize: 18),
                )
              ]))),
      body: itemBody,
      value: itemCount,
    );
  }
}

class CalcCooling extends StatelessWidget {
  const CalcCooling({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppConstants.colChecklist[0],
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
        child: HtmlWidget(data: NeomateHtml.cooling),
      ),
    );
  }
}

/// -------- Daily Infusion Calculator -------- ///

class CalcIVFluids extends ConsumerStatefulWidget {
  const CalcIVFluids({Key? key}) : super(key: key);

  @override
  CalcIVFluidsState createState() => CalcIVFluidsState();
}

class CalcIVFluidsState extends ConsumerState<CalcIVFluids> {
  var _dex = 10.0;
  var _sodium = 0.0;
  var _potassium = 0.0;
  var _total = 0.0;
  String? _errorText;
  var fluidController = TextEditingController();
  var valid = false;
  Map<String, String> calculations = {};

  @override
  void initState() {
    super.initState();
    ref.read(neomateNotifier);
  }

  @override
  Widget build(BuildContext context) {
    var notifier = ref.watch(neomateNotifier);
    return Column(children: [
      const BolusDrugs(selectedDrugs: DrugType.bolus),
      const Divider(
        color: Colors.black26,
        thickness: 1,
      ),
      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
      GestureDetector(
          onTap: (() => {FocusScope.of(context).unfocus()}),
          child: Card(
            color: AppConstants.colChecklist[1],
            margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(14, 0, 0, 15),
                    child: TextHeading(
                      text: 'Daily infusion calculator',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                    child: Text('Dextrose'),
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: Slider(
                          min: 5.0,
                          max: 30.0,
                          divisions: 10,
                          value: _dex,
                          onChanged: (value) {
                            setState(() {
                              _dex = value;
                              valid = false;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child:
                            Text('${_dex.toString().replaceAll('.0', '')} %'),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                    child: Text('Sodium'),
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: Slider(
                          min: 0.0,
                          max: 10.0,
                          divisions: 20,
                          value: _sodium,
                          onChanged: (value) {
                            setState(() {
                              _sodium = value;
                              valid = false;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: Text(
                            '${_sodium.toString().replaceAll('.0', '')} mmol/kg/day'),
                      ),
                    ],
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                    child: Text('Potassium'),
                  ),
                  Row(
                    children: [
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 3,
                        child: Slider(
                          min: 0.0,
                          max: 8.0,
                          divisions: 16,
                          value: _potassium,
                          onChanged: (value) {
                            setState(() {
                              _potassium = value;
                              valid = false;
                            });
                          },
                        ),
                      ),
                      Flexible(
                        fit: FlexFit.tight,
                        flex: 2,
                        child: Text(
                            '${_potassium.toString().replaceAll('.0', '')} mmol/kg/day'),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 135,
                          height: 55,
                          child: TextField(
                            onChanged: (text) => {
                              setState(() {
                                valid = false;
                                double? tempTotal = double.tryParse(text);
                                if (tempTotal is double) {
                                  _total = tempTotal;
                                } else {
                                  _total = 0;
                                }
                              })
                            },
                            autofocus: true,
                            decoration: InputDecoration(
                                errorText: _errorText,
                                labelText: 'Total daily fluid',
                                //border: OutlineInputBorder(),
                                contentPadding:
                                    const EdgeInsets.fromLTRB(0, 0, 10, 6),
                                suffixText: 'mL/kg/day'),
                            controller: fluidController,
                            textAlign: TextAlign.right,
                            keyboardType: const TextInputType.numberWithOptions(
                              signed: false,
                              decimal: false,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(3),
                            ],
                          ),
                        ),
                        Visibility(
                            visible: !notifier.weightValid,
                            child: const Padding(
                                padding: EdgeInsets.fromLTRB(10, 0, 20, 0),
                                child: Text('Please enter weight'))),
                        Visibility(
                          visible: notifier.weightValid,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                            child: ElevatedButton.icon(
                              onPressed: () => {
                                setState(() {
                                  valid = true;
                                  if (_total < 10) {
                                    setState(() {
                                      _errorText = 'too low';
                                    });
                                  } else if (_total > 250) {
                                    setState(() {
                                      _errorText = 'too high';
                                    });
                                  } else {
                                    setState(() {
                                      _errorText = null;
                                    });
                                    FocusScope.of(context).unfocus();

                                    var fluidResult = notifier.dailyFluids(
                                        _dex, _sodium, _potassium, _total);

                                    Navigator.of(context).push(
                                      PageTransition(
                                          type: PageTransitionType.leftToRight,
                                          child:
                                              CalcDetail(results: fluidResult)),
                                    );
                                  }
                                })
                              },
                              icon: const Icon(Icons.calculate),
                              label: const Text('calculate'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ))
    ]);
  }
}

/// -------- Ventilation and Oxygenation Index -------- ///

class Ventilation extends StatelessWidget {
  const Ventilation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: const [
      OICalc(),
      CalcVentilation(),
    ]);
  }
}

class OICalc extends StatefulWidget {
  const OICalc({Key? key}) : super(key: key);

  @override
  State<OICalc> createState() => _OICalcState();
}

class _OICalcState extends State<OICalc> {
  var _inspired = 100.0;
  var _map = 0.0;
  var _paO2 = 0.0;
  final List<bool> _mapUnits = [true, false];
  final List<bool> _o2Units = [true, false];
  final List<String> _mapUnitsString = ['cmH\u2082O', 'mmHg'];
  final List<String> _o2UnitsString = ['kPa', 'mmHg'];
  int _mapSelUnits = 0;
  int _o2SelUnits = 0;
  String? _mapErrorText;
  String? _paO2ErrorText;
  final controllerMAP = TextEditingController();
  final controllerPaO2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
      GestureDetector(
        onTap: (() => {FocusScope.of(context).unfocus()}),
        child: Card(
          color: AppConstants.colChecklist[1],
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(14, 0, 0, 20),
                  child: Text('Oxygenation Index calculator',
                      style: TextStyle(fontSize: 15)),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                  child: Text('Inspired oxygen percentage (%)'),
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child: Slider(
                        min: 21.0,
                        max: 100.0,
                        divisions: 100,
                        value: _inspired,
                        onChanged: (value) {
                          setState(() {
                            _inspired = value;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Text('${_inspired.toStringAsFixed(0)} %'),
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 165,
                            height: 55,
                            child: TextField(
                              onChanged: (text) => {
                                setState(() {
                                  double? mapTotal = double.tryParse(text);
                                  if (mapTotal is double) {
                                    _map = mapTotal;
                                  } else {
                                    _map = 0;
                                  }
                                })
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                  errorText: _mapErrorText,
                                  labelText: 'Mean airway pressure (MAP)',
                                  labelStyle: const TextStyle(fontSize: 13),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 6),
                                  suffixText: _mapUnitsString[_mapSelUnits]),
                              controller: controllerMAP,
                              textAlign: TextAlign.right,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: false,
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'\d*\.?\d*')),
                                LengthLimitingTextInputFormatter(4),
                              ],
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                          ToggleButtons(
                            selectedColor: Colors.blueAccent,
                            borderRadius:
                                const BorderRadius.all(Radius.elliptical(5, 5)),
                            constraints:
                                BoxConstraints.loose(const Size.fromHeight(30)),
                            isSelected: _mapUnits,
                            onPressed: (int index) {
                              setState(() {
                                _mapUnits[(index + 1) % 2] = false;
                                _mapUnits[index] = true;
                                _mapSelUnits = index;
                              });
                            },
                            children: const <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                  child: Text('cmH\u2082O')),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Text('mmHg'),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          )
                        ])),
                Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 165,
                            height: 55,
                            child: TextField(
                              onChanged: (text) => {
                                setState(() {
                                  double? tempPaO2 = double.tryParse(text);
                                  if (tempPaO2 is double) {
                                    _paO2 = tempPaO2;
                                  } else {
                                    _paO2 = 0;
                                  }
                                })
                              },
                              autofocus: true,
                              decoration: InputDecoration(
                                  errorText: _paO2ErrorText,
                                  labelText:
                                      'Partial pressure oxygen (PaO\u2082)',
                                  labelStyle: const TextStyle(fontSize: 13),

                                  //border: OutlineInputBorder(),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 6),
                                  suffixText: _o2UnitsString[_o2SelUnits]),
                              //controller: fluidController,
                              textAlign: TextAlign.right,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: false,
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'\d*\.?\d*')),
                                LengthLimitingTextInputFormatter(4),
                              ],
                            ),
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(5, 0, 0, 0)),
                          ToggleButtons(
                            selectedColor: Colors.blueAccent,
                            borderRadius:
                                const BorderRadius.all(Radius.elliptical(5, 5)),
                            constraints:
                                BoxConstraints.loose(const Size.fromHeight(30)),
                            isSelected: _o2Units,
                            onPressed: (int index) {
                              setState(() {
                                _o2Units[(index + 1) % 2] = false;
                                _o2Units[index] = true;
                                _o2SelUnits = index;
                              });
                            },
                            children: const <Widget>[
                              Padding(
                                  padding: EdgeInsets.fromLTRB(16, 5, 17, 5),
                                  child: Text('kPa')),
                              Padding(
                                padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Text('mmHg'),
                              ),
                            ],
                          ),
                          const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                          )
                        ])),
                Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: ElevatedButton.icon(
                      onPressed: () => {
                        setState(() {
                          var valid = true;
                          if (_map < 5) {
                            _mapErrorText = 'too low';
                            valid = false;
                          } else if (_map > 30) {
                            _mapErrorText = 'too high';
                            valid = false;
                          } else {
                            _mapErrorText = null;
                          }
                          if (_paO2 < 1) {
                            _paO2ErrorText = 'too low';
                            valid = false;
                          } else if (_paO2 > 500) {
                            _paO2ErrorText = 'too high';
                            valid = false;
                          } else {
                            _paO2ErrorText = null;
                          }
                          if (valid) {
                            FocusScope.of(context).unfocus();

                            var oiResult = Neomate.oiCalculator(
                              inspiredO2: _inspired,
                              map: _map,
                              paO2: _paO2,
                              mapUnits: (_mapSelUnits == 0)
                                  ? MapUnits.cmH2O
                                  : MapUnits.mmHg,
                              paO2Units: (_o2SelUnits == 0)
                                  ? PaO2Units.kPa
                                  : PaO2Units.mmHg,
                            );

                            Navigator.of(context).push(
                              PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: CalcDetail(results: oiResult)),
                            );
                          }
                        })
                      },
                      icon: const Icon(Icons.calculate),
                      label: const Text('calculate'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ]);
  }
}

class CalcVentilation extends StatefulWidget {
  const CalcVentilation({Key? key}) : super(key: key);

  @override
  CalcVentilationState createState() => CalcVentilationState();
}

class CalcVentilationState extends State<CalcVentilation> {
  var _ti = 0.4;
  var _te = 0.6;
  var _rate = 60.0;
  var _pip = 18.0;
  var _peep = 4.0;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Card(
          color: AppConstants.colChecklist[1],
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.fromLTRB(14, 0, 0, 15),
                      child: TextHeading(
                        text: 'Ventilation setting calculator',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(15, 0, 10, 10),
                      child: TextStandard(
                        text:
                            'If you have a basic ventilator you can use this calculator to help with settings and to calculate mean airway pressure (MAP)',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text('Ventilator rate'),
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Slider(
                            min: 10.0,
                            max: 70.0,
                            divisions: 60,
                            value: _rate,
                            onChanged: (value) {
                              setState(() {
                                _rate = value;
                                var tempTe = ((60 - (_ti * _rate)) / _rate)
                                    .toPrecision(2);
                                if (tempTe < 0.1) {
                                  _te = 0.1;
                                  _rate = (60 / (_ti + _te)).toPrecision(0);
                                } else {
                                  _te = tempTe;
                                }
                              });
                            },
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                              '${_rate.toString().replaceAll('.0', '')} breaths/min'),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text('Inspiratory time (Ti)'),
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Slider(
                            min: 0.1,
                            max: 2.0,
                            divisions: 19,
                            value: _ti,
                            onChanged: (value) {
                              setState(() {
                                _ti = value.toPrecision(1);
                                var tempTe = ((60 - (_ti * _rate)) / _rate)
                                    .toPrecision(2);
                                if (tempTe < 0.1) {
                                  _te = 0.1;
                                  _ti = ((60 - (_rate * _te)) / _rate)
                                      .toPrecision(2);
                                } else {
                                  _te = tempTe;
                                }
                              });
                            },
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                              '${_ti.toString().replaceAll('.0', '')} secs'),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text('Expiratory time (Te)'),
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Slider(
                            min: 0.1,
                            max: 10.0,
                            divisions: 99,
                            value: _te,
                            onChanged: (value) {
                              setState(() {
                                _te = value.toPrecision(1);
                                var tempRate =
                                    (60 / (_ti + _te)).toPrecision(0);
                                if (tempRate < 10) {
                                  _rate = 10;
                                  _te = ((60 - (_ti * _rate)) / _rate)
                                      .toPrecision(2);
                                } else {
                                  _rate = tempRate;
                                }
                              });
                            },
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                              '${_te.toString().replaceAll('.0', '')} secs'),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text('Inspiratory Pressure (PIP)'),
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Slider(
                            min: 4,
                            max: 40.0,
                            divisions: 72,
                            value: _pip,
                            onChanged: (value) {
                              setState(() {
                                if (value < _peep) {
                                  _pip = _peep + 0.5;
                                } else {
                                  _pip = value.toPrecision(1);
                                }
                              });
                            },
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                              '${_pip.toString().replaceAll('.0', '')} cmH\u2082O'),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                      child: Text('Expiratory Pressure (PEEP)'),
                    ),
                    Row(
                      children: [
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 3,
                          child: Slider(
                            min: 0,
                            max: 15.0,
                            divisions: 30,
                            value: _peep,
                            onChanged: (value) {
                              setState(() {
                                if (value > _pip) {
                                  _peep = _pip - 0.5;
                                } else {
                                  _peep = value.toPrecision(1);
                                }
                              });
                            },
                          ),
                        ),
                        Flexible(
                          fit: FlexFit.tight,
                          flex: 2,
                          child: Text(
                              '${_peep.toString().replaceAll('.0', '')} cmH\u2082O'),
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
                        child: ElevatedButton.icon(
                          onPressed: () => {
                            setState(() {
                              FocusScope.of(context).unfocus();
                              var results = Neomate.mapCalc(
                                  rate: _rate,
                                  ti: _ti,
                                  te: _te,
                                  pip: _pip,
                                  peep: _peep);
                              Navigator.of(context).push(
                                PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: CalcDetail(results: results),
                                ),
                              );
                            })
                          },
                          icon: const Icon(Icons.calculate),
                          label: const Text('calculate'),
                        ),
                      ),
                    ),
                  ])))
    ]);
  }
}

/// -------- Any Drug infusion calculator -------- ///

class AnyDrug extends ConsumerStatefulWidget {
  const AnyDrug({Key? key}) : super(key: key);

  @override
  AnyDrugState createState() => AnyDrugState();
}

class AnyDrugState extends ConsumerState<AnyDrug> {
  var _infusionRate = 1.0;
  var _syringeSize = 50.0;
  var _dose = 0.0;
  var _units = 'mg';
  var _timescale = 'hour';
  String? _errorMessage;

  final controllerMAP = TextEditingController();
  final controllerPaO2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    // "ref" can be used in all life-cycles of a StatefulWidget.
    ref.read(neomateNotifier);
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.watch(neomateNotifier);
    final babyWeight = notifier.weightNumKg;

    return Column(children: [
      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
      GestureDetector(
        onTap: (() => {FocusScope.of(context).unfocus()}),
        child: Card(
          color: AppConstants.colChecklist[1],
          margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(14, 0, 0, 20),
                  child: Text('Any drug infusion calculator',
                      style: TextStyle(fontSize: 15)),
                ),
                Row(
                  children: [
                    Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 10),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: 60,
                                height: 55,
                                child: TextField(
                                  onChanged: (text) => {
                                    setState(() {
                                      double? doseTemp = double.tryParse(text);
                                      if (doseTemp is double) {
                                        _dose = doseTemp;
                                      } else {
                                        _dose = 0;
                                      }
                                    })
                                  },
                                  autofocus: true,
                                  decoration: InputDecoration(
                                    labelText: 'Dose',
                                    errorText: _errorMessage,
                                    labelStyle: const TextStyle(fontSize: 13),
                                    contentPadding:
                                        const EdgeInsets.fromLTRB(0, 0, 10, 6),
                                  ),
                                  controller: controllerMAP,
                                  textAlign: TextAlign.right,
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    signed: false,
                                    decimal: false,
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(4),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 45,
                                width: 105,
                                child: DropdownButton<String>(
                                  value: _units,
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  elevation: 16,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _units = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'g',
                                    'mg',
                                    'mmol',
                                    'micrograms',
                                    'nanograms'
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: SizedBox(
                                          width: 75,
                                          child: Text(
                                            value,
                                            textAlign: TextAlign.right,
                                          )),
                                    );
                                  }).toList(),
                                ),
                              ),
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                  child: Text('/ kg /')),
                              SizedBox(
                                height: 45,
                                width: 100,
                                child: DropdownButton<String>(
                                  value: _timescale,
                                  icon: const Icon(
                                    Icons.edit,
                                    size: 18,
                                    color: Colors.black54,
                                  ),
                                  elevation: 16,
                                  style: const TextStyle(
                                      fontSize: 13, color: Colors.black),
                                  underline: Container(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      _timescale = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'minute',
                                    'hour',
                                    'day',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ])),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                  child: Text('Infusion Rate'),
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child: Slider(
                        min: 0.1,
                        max: 5.0,
                        divisions: 49,
                        value: _infusionRate,
                        onChanged: (value) {
                          setState(() {
                            _infusionRate = value.toPrecision(2);
                          });
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Text('$_infusionRate mL/h'),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(22, 0, 0, 0),
                  child: Text('Syringe size'),
                ),
                Row(
                  children: [
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 3,
                      child: Slider(
                        min: 5.0,
                        max: 50.0,
                        divisions: 45,
                        value: _syringeSize,
                        onChanged: (value) {
                          setState(() {
                            _syringeSize = value;
                          });
                        },
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      flex: 2,
                      child: Text('${_syringeSize.toStringAsFixed(0)} mL'),
                    ),
                  ],
                ),
                Visibility(
                    visible: !notifier.weightValid,
                    child: const Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 20, 0),
                            child: Text('Please enter weight')))),
                Visibility(
                  visible: notifier.weightValid,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                      child: ElevatedButton.icon(
                        onPressed: () => {
                          setState(() {
                            if (_dose > 0) {
                              FocusScope.of(context).unfocus();
                              var myUnits = DeliveryUnits.invalid;
                              switch (_units) {
                                case 'g':
                                  {
                                    myUnits = DeliveryUnits.gPerKg;
                                    break;
                                  }
                                case 'mg':
                                  {
                                    myUnits = DeliveryUnits.mgPerKg;
                                    break;
                                  }
                                case 'mmol':
                                  {
                                    myUnits = DeliveryUnits.mmolPerKg;
                                    break;
                                  }
                                case 'micrograms':
                                  {
                                    myUnits = DeliveryUnits.microgramsPerKg;
                                    break;
                                  }
                                case 'nanograms':
                                  {
                                    myUnits = DeliveryUnits.nanogramsPerKg;
                                    break;
                                  }
                              }
                              var myTime = DeliveryTime.invalid;
                              switch (_timescale) {
                                case 'minute':
                                  {
                                    myTime = DeliveryTime.perMinute;
                                    break;
                                  }
                                case 'hour':
                                  {
                                    myTime = DeliveryTime.perHour;
                                    break;
                                  }
                                case 'day':
                                  {
                                    myTime = DeliveryTime.perDay;
                                    break;
                                  }
                              }
                              var myDrug = DrugInfusion(
                                types: [DrugType.generic],
                                name: 'your drug',
                                deliveryUnits: myUnits,
                                deliveryTime: myTime,
                                startDose: _dose,
                                fluids: [FluidType.any],
                                desiredRate: _infusionRate,
                                syringe: _syringeSize,
                                minConc: 0,
                                maxConc: 9999,
                                minConcMsg: 'minConcMsg',
                                maxConcMsg: 'maxConcMsg',
                                minDose: 0,
                                maxDose: 9999,
                                generic: true,
                                doseMsg: '',
                                doseRange: 'doseRange',
                                weight: babyWeight,
                              );

                              Navigator.of(context).push(
                                PageTransition(
                                  type: PageTransitionType.leftToRight,
                                  child: CalcDetail(results: myDrug.results),
                                ),
                              );
                            }
                          })
                        },
                        icon: const Icon(Icons.calculate),
                        label: const Text('calculate'),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
    ]);
  }
}

/// -------- Remaining NICU Calc Rows -------- ///

class CalcIntubation extends StatelessWidget {
  const CalcIntubation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BolusDrugs(selectedDrugs: DrugType.intubation);
  }
}

class CalcCentral extends StatelessWidget {
  const CalcCentral({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const BolusDrugs(selectedDrugs: DrugType.central);
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

/// -------- Drug Calculation Pages -------- ///

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
      Widget myRow = Container();
      if (drug is DrugMultiplier) {
        // Row to display drug based on a multiple of the weight
        myRow = DrugMultiplierRow(
          drug: drug,
        );
      }
      if (drug is DrugBanded && !drug.weight!.isNaN) {
        // Row to display drug based on bandings of the weight
        myRow = DrugBandedRow(
          drug: drug,
        );
      }
      if (drug is DrugInfo && !drug.weight!.isNaN) {
        // Row to display drug that's information only
        myRow = DrugInfoRow(
          drug: drug,
        );
      }
      if (drug is DrugFormula && !drug.weight!.isNaN) {
        myRow = DrugFormulaRow(
          drug: drug,
        );
      }
      if (drug is DrugInfusion && !drug.weight!.isNaN) {
        myRow = DrugInfusionRow(drug: drug);
      }
      if (myRow is! Container && drug.jumpReference.isEmpty) {
        drugRows.add(Container(
            color: redRow ? AppConstants.redRow : Colors.transparent,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 24, 10),
              child: myRow,
            )));
        redRow = !redRow;
      }
      if (myRow is! Container && drug.jumpReference.isNotEmpty) {
        Widget myJump;
        if (drug.jumpReference.contains('neomate://')) {
          // This is a 'neomate URL' so we want to link to a checklist or reference
          // so extract the actual link text
          myJump = JumpReference(
              reference: drug.jumpReference.replaceAll('neomate://', ''));
        } else {
          // Assume it's a normal webpage and try to launch
          myJump = WebReference(reference: drug.jumpReference);
        }
        drugRows.add(
          Container(
              color: redRow ? AppConstants.redRow : Colors.transparent,
              child: Stack(
                alignment: Alignment.bottomRight,
                fit: StackFit.loose,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 24, 10),
                    child: myRow,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: myJump)
                      ]),
                ],
              )),
        );
        redRow = !redRow;
      }
    }

    drugRows.add(const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: drugRows,
    );
  }
}

class DrugInfusionRow extends StatelessWidget {
  final DrugInfusion drug;
  const DrugInfusionRow({Key? key, required this.drug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${drug.name} infusion',
                style: const TextStyle(fontSize: 16),
              ),
              const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
              Text(
                drug.doseRange,
                style: const TextStyle(fontSize: 14),
              ),
            ]),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: ElevatedButton.icon(
                onPressed: () => {
                  Navigator.of(context).push(
                    PageTransition(
                        type: PageTransitionType.leftToRight,
                        child: CalcDetail(results: drug.results)),
                  )
                },
                icon: const Icon(Icons.calculate),
                label: const Text('calculate'),
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
      ],
    );
  }
}

class DrugFormulaRow extends StatelessWidget {
  final DrugFormula drug;
  const DrugFormulaRow({Key? key, required this.drug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                drug.qualifier,
                style: const TextStyle(fontSize: 12),
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
            children: [
              Text(drug.calcFormula),
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
              ),
              Text.rich(TextSpan(children: [
                TextSpan(
                  text: '= ${drug.calcString} ',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  text: '${drug.units} ',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.w500),
                ),
                TextSpan(
                  // ignore: unnecessary_string_interpolations
                  text: '${drug.instructions}',
                  style: const TextStyle(fontSize: 13),
                ),
              ]))
            ],
          ),
        ),
      ],
    );
  }
}

class DrugInfoRow extends StatelessWidget {
  final DrugInfo drug;
  const DrugInfoRow({Key? key, required this.drug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                drug.qualifier,
                style: const TextStyle(fontSize: 12),
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
              children: [
                Text.rich(TextSpan(children: [
                  TextSpan(
                    text: '${drug.calcString} ',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: '${drug.units} ',
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  TextSpan(
                    text: drug.instructions,
                    style: const TextStyle(fontSize: 13),
                  ),
                ])),
                const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 2)),
                Text(
                  drug.notes,
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                )
              ]),
        ),
      ],
    );
  }
}

class DrugBandedRow extends StatelessWidget {
  final DrugBanded drug;
  const DrugBandedRow({Key? key, required this.drug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
            children: List.from(drugDetailInner(drug))
              ..addAll([
                const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 2)),
                Visibility(
                  visible: drug.notes.isNotEmpty,
                  child: Text(
                    drug.notes,
                    style: const TextStyle(
                        fontSize: 12, fontStyle: FontStyle.italic),
                  ),
                ),
              ]),
          ),
        ),
      ],
    );
  }
}

class DrugMultiplierRow extends StatelessWidget {
  final DrugMultiplier drug;
  const DrugMultiplierRow({Key? key, required this.drug}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
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
                drug.dose,
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
            //children: drugDetail(drug),
            children: List.from(drugDetailInner(drug))
              ..addAll([
                const Padding(padding: EdgeInsets.fromLTRB(0, 3, 0, 2)),
                Text(
                  drug.notes,
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic),
                )
              ]),
          ),
        ),
      ],
    );
  }
}

List<Widget> drugDetailInner(Drug drug) {
  if (drug.weight!.isNaN) {
    return ([const Text('Please enter weight')]);
  }
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
        text: drug.instructions,
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

class JumpReference extends StatelessWidget {
  final String reference;

  // Display a jump reference

  const JumpReference({Key? key, required this.reference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
        icon: const Icon(
          Icons.book,
          color: Color.fromRGBO(50, 100, 255, 0.6),
        ),
        onPressed: () => {jumpTo(reference, context)});
  }
}

class WebReference extends StatelessWidget {
  final String reference;

  // Display a jump reference

  const WebReference({Key? key, required this.reference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        padding: const EdgeInsets.fromLTRB(18, 0, 0, 0),
        icon: const Icon(
          Icons.article_rounded,
          color: Color.fromRGBO(50, 100, 255, 0.6),
        ),
        onPressed: () => {doLaunchUrl(Uri.parse(reference))});
  }
}

class Clinic extends StatelessWidget {
  const Clinic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text("Clinic");
  }
}

class Checklists extends StatelessWidget {
  const Checklists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ChecklistMenuPage();
  }
}

class References extends StatelessWidget {
  const References({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ReferenceMenuPage();
  }
}

class About extends StatelessWidget {
  // Displays the About page

  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        HtmlWidget(data: NeomateHtml.aboutPage),
        ElevatedButton(
            onPressed: () {
              showLicensePage(
                  context: context,
                  applicationName: 'Neomate',
                  applicationVersion: '2.0',
                  applicationLegalese:
                      '''Copyright 2014-2022 Neomate Ltd. All rights reserved.
    All software components listed below are copyright their respective authors and distributed under the relevant licensing terms. Permission to use is gratefully acknowledged.''');
            },
            child: const Text('Software Licenses')),
        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10))
      ],
    ));
  }
}

/// -------- Checklist Pages -------- ///

class ChecklistMenuPage extends StatefulWidget {
  const ChecklistMenuPage({Key? key}) : super(key: key);

  @override
  State<ChecklistMenuPage> createState() => ChecklistMenuPageState();
}

class ChecklistMenuPageState extends State<ChecklistMenuPage> {
  // Creates a page to show a list of all the checklists

  final checklistNavKey = GlobalKey<NavigatorState>();

  Widget _menu(BuildContext context) {
    List<Widget> checklistPages = [
      Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: HtmlWidget(data: NeomateHtml.checklistPreamble),
      ),
    ];
    for (var checklist in checklistDb) {
      checklistPages.add(
        Card(
          color: AppConstants.colChecklistCard,
          child: ListTile(
            title: Text(
              checklist.heading,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              checklist.subheading,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            isThreeLine: true,
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                    type: PageTransitionType.leftToRight,
                    //child: _checklistPage(checklist),
                    child: ChecklistPage(
                      checklist: checklist,
                    )),
              );
            },
          ),
        ),
      );
    }
    checklistPages
        .add(const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 10)));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: const TextHeading(
            text: 'Neonatal Checklists',
          ),
        ),
        Flexible(
          child: ListView(children: checklistPages),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await checklistNavKey.currentState!.maybePop(),
      child: Navigator(
          key: checklistNavKey,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => _menu(context),
            );
          }),
    );
  }
}

class ChecklistPage extends StatelessWidget {
  final Checklist checklist;
  const ChecklistPage({Key? key, required this.checklist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> checklistSections = [
      Container(
        color: AppConstants.colChecklistAbstract,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: HtmlWidget(data: checklist.abstract),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
    ];

    var sectionNum = 0;

    for (var section in checklist.sections) {
      sectionNum++;
      checklistSections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 0, 0),
              child: Visibility(
                visible: checklist.sections.length > 1,
                child: TextHeading(
                  text: '$sectionNum. ${section.sectionHeading}',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
            ),
            ChecklistItems(
                section: section,
                color: AppConstants.colChecklist[
                    sectionNum % AppConstants.colChecklist.length]),
            const Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SubpageHeader(text: checklist.heading),
          Flexible(
            child: ListView(children: checklistSections),
          ),
        ],
      ),
    );
  }
}

class ChecklistItems extends StatelessWidget {
  final ChecklistSection section;
  final Color color;

  const ChecklistItems({Key? key, required this.section, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    for (var item in section.items) {
      var myKey = GlobalKey<ChecklistCheckboxState>();
      items.add(
        Card(
          margin: const EdgeInsets.fromLTRB(12, 5, 12, 5),
          color: color,
          child: InkWell(
            onTap: () {
              myKey.currentState!.flip();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: (item.length < 150)
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              children: [
                ChecklistCheckbox(key: myKey),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: HtmlWidget(data: item),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: items);
  }
}

class ChecklistCheckbox extends StatefulWidget {
  const ChecklistCheckbox({Key? key}) : super(key: key);

  @override
  State<ChecklistCheckbox> createState() => ChecklistCheckboxState();
}

class ChecklistCheckboxState extends State<ChecklistCheckbox> {
// Creates a check box that remembers whether it's been ticked or not
// until we leave the current page, in which case it resets

  bool isChecked = false;

  void flip() {
    setState(() {
      isChecked = !isChecked;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.grey;
    }

    return Checkbox(
      checkColor: Colors.white,
      fillColor: MaterialStateProperty.resolveWith(getColor),
      value: isChecked,
      onChanged: (bool? value) {
        setState(() {
          isChecked = value!;
        });
      },
    );
  }
}

/// -------- Reference Pages -------- ///

class ReferenceMenuPage extends StatefulWidget {
  const ReferenceMenuPage({Key? key}) : super(key: key);

  // Creates a menu of all the reference HTML objects

  @override
  State<ReferenceMenuPage> createState() => ReferenceMenuPageState();
}

class ReferenceMenuPageState extends State<ReferenceMenuPage> {
  final referenceNavKey = GlobalKey<NavigatorState>();

  Widget _menu(BuildContext context) {
    List<Widget> referencePages = [
      Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: HtmlWidget(data: NeomateHtml.checklistPreamble),
      ),
    ];
    for (var reference in referenceDb) {
      referencePages.add(
        Card(
          color: AppConstants.colChecklistCard,
          child: ListTile(
            title: Text(
              reference.heading,
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              reference.subheading,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            ),
            isThreeLine: true,
            onTap: () {
              Navigator.of(context).push(
                PageTransition(
                  type: PageTransitionType.leftToRight,
                  child: ReferencePage(reference: reference),
                ),
              );
            },
          ),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
          child: const Text(
            'Quick Reference',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: ListView(children: referencePages),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => !await referenceNavKey.currentState!.maybePop(),
      child: Navigator(
          key: referenceNavKey,
          onGenerateRoute: (routeSettings) {
            return MaterialPageRoute(
              builder: (context) => _menu(context),
            );
          }),
    );
  }
}

class ReferencePage extends StatelessWidget {
  // Create a page with all the html sections of a reference page inside Cards
  final Reference reference;
  const ReferencePage({Key? key, required this.reference}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> referenceSections = [
      Container(
        color: AppConstants.colChecklistAbstract,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: HtmlWidget(data: reference.abstract),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
    ];

    var sectionNum = 0;

    for (var section in reference.sections) {
      sectionNum++;
      referenceSections.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Card(
                color: AppConstants.colChecklist[
                    sectionNum % AppConstants.colChecklist.length],
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: HtmlWidget(data: section),
                ),
              ),
            ),
          ],
        ),
      );
    }

    referenceSections
        .add(const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)));

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          SubpageHeader(text: reference.heading),
          Flexible(
            child: ListView(children: referenceSections),
          ),
        ],
      ),
    );
  }
}

/// -------- Calculation Detail Page for Any Calculation Result -------- ///

class CalcDetail extends StatelessWidget {
  // Displays a page for a drug infusion detail - calculations, advisories etc.
  // This should be pushed onto the navigator so it can be popped off again
  // when we're done

  final CalcResults results;

  const CalcDetail({
    Key? key,
    required this.results,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> nextCard = [];
    List<Widget> resultsColumn = [];
    int cardColor = 0;

    for (var resultLine in results.resultLines) {
      if (resultLine is CalcHeading) {
        // This is a new heading so start a new card
        if (nextCard.isNotEmpty) {
          resultsColumn.add(resultCard(nextCard, cardColor));
          nextCard = [];
          cardColor++;
        }
        nextCard.add(TextHeading(
          text: resultLine.result,
        ));
      }
      if (resultLine is CalcCommentary) {
        nextCard.add(TextStandard(
          text: resultLine.result,
        ));
      }
      if (resultLine is CalcWarning) {
        nextCard.add(TextWarning(
          text: resultLine.result,
        ));
      }
      if (resultLine is CalcAdvisory) {
        nextCard.add(TextAdvisory(
          text: resultLine.result,
        ));
      }
      if (resultLine is CalcFormula) {
        nextCard.add(CalcFormulaColumn(
          topLine: resultLine.top,
          bottomLine: resultLine.bottom,
        ));
        nextCard.add(TextResult(text: resultLine.result));
      }
      if (resultLine is CalcResult) {
        nextCard.add(TextResult(text: resultLine.result));
      }
    }
    resultsColumn.add(resultCard(nextCard, cardColor));

    return Container(
        color: Colors.white,
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          SubpageHeader(text: results.heading),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: resultsColumn)))
        ]));
  }

  Widget resultCard(List<Widget> resultsColumn, int cardColor) {
    return Card(
        color: AppConstants.colChecklist[cardColor],
        child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: resultsColumn)));
  }
}

/// -------- Utililty classes -------- ///

class CalcFormulaColumn extends StatelessWidget {
  // Creates a column to display a formula calculation
  // uses the bottom of the top line's box as the diving line
  // at some point may need to calculate line lengths and decide
  // which one shold draw the box in case the bottom line is longer

  const CalcFormulaColumn(
      {Key? key, required this.topLine, required this.bottomLine})
      : super(key: key);

  final String topLine;
  final String bottomLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 12, 0, 4),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    width: 1.5, color: Color.fromRGBO(54, 54, 54, 0.6)),
              ),
            ),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                topLine,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(0, 6, 0, 0)),
        Center(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              bottomLine,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ),
        const Padding(padding: EdgeInsets.fromLTRB(0, 0, 0, 4)),
      ],
    );
  }
}

class SubpageHeader extends StatelessWidget {
// For subpages that are pushed onto a Navigator
// Creates a header row with back button and page title

  final String text;

  const SubpageHeader({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const BackButton(),
      Expanded(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}

// Text classes for consistent fonts etc.

class TextHeading extends StatelessWidget {
  final String text;

  const TextHeading({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 5, 10),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class TextSubHeading extends StatelessWidget {
  final String text;

  const TextSubHeading({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 15.5,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

class TextStandard extends StatelessWidget {
  final String text;

  const TextStandard({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.3,
        ),
      ),
    );
  }
}

class TextResult extends StatelessWidget {
  final String text;

  const TextResult({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class TextMiniAdvisory extends StatelessWidget {
  final String text;

  const TextMiniAdvisory({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 11,
          height: 1.5,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class TextCondensed extends StatelessWidget {
  final String text;
  const TextCondensed({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 2, 5),
      child: Text(
        text,
        style: const TextStyle(fontSize: 12.5),
      ),
    );
  }
}

class TextWarning extends StatelessWidget {
  final String text;
  const TextWarning({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 2, 5),
      child: Row(children: [
        const Flexible(
          flex: 1,
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
              child: Icon(
                Icons.warning_rounded,
                color: Colors.redAccent,
                size: 30,
              )),
        ),
        Flexible(
          flex: 6,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.redAccent,
              fontWeight: FontWeight.w600,
              height: 1.3,
            ),
          ),
        ),
      ]),
    );
  }
}

class TextAdvisory extends StatelessWidget {
  final String text;
  const TextAdvisory({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 2, 5),
      child: Row(children: [
        const Flexible(
          flex: 1,
          child: Padding(
              padding: EdgeInsets.fromLTRB(5, 0, 15, 0),
              child: Icon(
                Icons.info_rounded,
                color: Colors.blueAccent,
                size: 24,
              )),
        ),
        Flexible(
          flex: 6,
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black,
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ),
      ]),
    );
  }
}

// Classes for rendering html widgets and handling urls

void jumpTo(String jumpLink, BuildContext context) {
  // Pushes a new page as a "jump" from a previous page so that
  // checklists and reference pages can be displayed inline

  for (var checklist in checklistDb) {
    if (checklist.jumpTitle == jumpLink) {
      Navigator.of(context).push(
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: ChecklistPage(checklist: checklist),
        ),
      );
      return;
    }
  }

  for (var reference in referenceDb) {
    if (reference.jumpTitle == jumpLink) {
      Navigator.of(context).push(
        PageTransition(
          type: PageTransitionType.leftToRight,
          child: ReferencePage(reference: reference),
        ),
      );
      return;
    }
  }
}

class HtmlWidget extends StatelessWidget {
  final String data;

  const HtmlWidget({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buildContext = context;
    return Html(
        data: data,
        style: {
          // p tag with text_size
          "p": Style(
            fontSize: const FontSize(13),
            lineHeight: LineHeight.percent(106),
          ),
          "h1": Style(
            fontSize: const FontSize(15),
          ),
          "h2": Style(
            fontSize: const FontSize(14),
          ),
          "h3": Style(
            fontSize: const FontSize(14),
          ),
          "ul": Style(
            fontSize: const FontSize(13),
            padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
          ),
          "ol": Style(
            fontSize: const FontSize(13),
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          ),
          "li": Style(
            fontSize: const FontSize(13),
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 4),
          ),
          "img": Style(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          ),
        },
        onLinkTap: (String? url, RenderContext context,
            Map<String, String> attributes, dom.Element? element) {
          if (url is String) {
            if (url.contains('neomate://')) {
              // This is a 'neomate URL' so we want to link to a checklist or reference
              // so extract the actual link text
              url = url.replaceAll('neomate://', '');
              jumpTo(url, buildContext);
            } else {
              // Assume it's a normal webpage and try to launch
              doLaunchUrl(Uri.parse(url));
            }
          }
        });
  }
}

void doLaunchUrl(Uri url) async {
  // Launch URL as an async task
  if (!await launchUrl(url)) throw 'Could not launch $url';
}
