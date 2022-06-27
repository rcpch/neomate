import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static var green_highlight = const Color.fromRGBO(11, 231, 135, 1);
  static var redRow = const Color.fromARGB(255, 254, 222, 222);
  static var colIcon = const Color.fromARGB(255, 255, 255, 255);
  static var blueList = Color.fromRGBO(3, 148, 148, 1);
  static var greyRow = Color.fromRGBO(198, 234, 252, 1);
  static var colChecklistCard = Color.fromRGBO(69, 123, 135, 1);
  static var colChecklistAbstract = Color.fromRGBO(236, 241, 243, 1);

  static List<Color> colChecklist = [
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

  IVInfusionDetails maintIV(
      {required double dex,
      required double sodium,
      required double potassium,
      required double total}) {
    return neomate.maintIV(
        dex: dex, sodium: sodium, potassium: potassium, total: total);
  }

  get weightStringShort => neomate.weightStringShort();
  get weightValid => neomate.weightValid;
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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey)),
      home: const NeomateHome(),
    );
  }
}

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

// Popup dialog for weight selection

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
              padding: const EdgeInsets.fromLTRB(4, 2, 4, 2),
              child: SizedBox(
                height: 32,
                width: 42,
                child: TextButton(
                  style: TextButton.styleFrom(
                      side:
                          const BorderSide(color: Colors.blueAccent, width: 2),
                      backgroundColor: Colors.lightBlue),
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
        Row(
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
              padding: const EdgeInsets.fromLTRB(10, 20, 0, 0),
              child: Visibility(
                visible: weightMessage.isNotEmpty,
                maintainAnimation: true,
                maintainState: true,
                maintainSize: true,
                child: SizedBox(
                  width: 150,
                  height: 50,
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
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
          child: Text('Estimate weight from gestation '),
        ),
        Wrap(runSpacing: 4, children: estimateButtons),
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
              itemIcon: CustomIcons.head_side_virus,
            ),
            calcItem(
                itemBody: const CalcEmergency(),
                itemTitle: 'Emergency Drugs',
                itemIcon: CustomIcons.exclamation_circle),
            calcItem(
              itemBody: const CalcCooling(),
              itemTitle: 'Cooling Criteria',
              itemIcon: CustomIcons.snowflake,
            ),
            calcItem(
              itemBody: CalcIVFluids(),
              itemTitle: 'Intravenous Fluids',
              itemIcon: CustomIcons.coffee,
            ),
            calcItem(
              itemBody: OICalc(),
              itemTitle: 'Oxygenation Index',
              itemIcon: CustomIcons.lungs,
            ),
            calcItem(
              itemBody: Container(),
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
        child: htmlWidget(NeomateHtml.cooling),
      ),
    );
  }
}

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
  String? _errorText = null;
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
                    child: Text('${_dex.toString().replaceAll('.0', '')} %'),
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
                              print('temp $tempTotal');
                            } else {
                              _total = 0;
                            }
                            print('total $_total');
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
                              if (_total < 30) {
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
                                print(_total);

                                Navigator.of(context).push(
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: IVFluidDetail(
                                        dex: _dex,
                                        sodium: _sodium,
                                        potassium: _potassium,
                                        total: _total),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    ]);
  }
}

class IVFluidDetail extends ConsumerWidget {
  final double dex;
  final double sodium;
  final double potassium;
  final double total;

  const IVFluidDetail({
    Key? key,
    required this.dex,
    required this.sodium,
    required this.potassium,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(neomateNotifier);
    String weight = notifier.weightStringShort;

    if (weight.isEmpty) {
      return Container();
    }

    var fluid = notifier.maintIV(
      dex: dex,
      sodium: sodium,
      potassium: potassium,
      total: total,
    );

    var dexString = '${dex} %';
    dexString = dexString.replaceAll('.0 ', ' ');
    dexString = dexString.replaceAll(' ', '');

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            const BackButton(),
            Expanded(
              child: Text(
                'Infusion calculation at ${total.toStringAsFixed(0)} mL/kg/day',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ]),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: AppConstants.colChecklist[0],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextHeading(text: 'Calculations for a $weight baby'),
                        TextStandard(text: fluid.total),
                        TextSubHeading(
                            text:
                                'Glucose infusion rate for $dexString dextrose'),
                        CalcFormulaColumn(
                          topLine: fluid.girTop,
                          bottomLine: fluid.girBottom,
                        ),
                        TextResult(text: fluid.girResult),
                        const TextMiniAdvisory(
                            text:
                                '(not accounting for added electolytes and other infusions)'),
                        Visibility(
                          visible: dex > 12.5,
                          child: const Padding(
                              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: TextAlert(
                                text:
                                    'Fluids with dextrose concentration greater than 12.5% should be infused via a central line',
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: (dex != 10 && dex != 5),
                  child: Card(
                    color: AppConstants.colChecklist[3],
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextHeading(text: 'To prepare $dexString dextrose'),
                          CalcFormulaColumn(
                            topLine: fluid.dexTop,
                            bottomLine: fluid.dexBottom,
                          ),
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 5)),
                          TextResult(text: fluid.dexSummary)
                        ],
                      ),
                    ),
                  ),
                ),
                Card(
                  color: AppConstants.colChecklist[1],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextHeading(text: 'Electrolytes per 500mL bag'),
                        Visibility(
                          visible: sodium == 0,
                          child: const TextStandard(text: '(No sodium added)'),
                        ),
                        Visibility(
                            visible: sodium != 0,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextSubHeading(
                                    text: 'Sodium at $sodium mmol/kg/day'),
                                CalcFormulaColumn(
                                  topLine: fluid.sodiumTop,
                                  bottomLine: fluid.electrolyteBottom,
                                ),
                                TextResult(text: fluid.sodium),
                              ],
                            )),
                        Visibility(
                          visible: potassium == 0,
                          child:
                              const TextStandard(text: '(No potassium added)'),
                        ),
                        Visibility(
                          visible: potassium != 0,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                              TextSubHeading(
                                text: 'Potassium at $potassium mmol/kg/day',
                              ),
                              CalcFormulaColumn(
                                topLine: fluid.potassiumTop,
                                bottomLine: fluid.electrolyteBottom,
                              ),
                              TextResult(
                                text: fluid.potassium,
                              ),
                              Visibility(
                                visible: potassium > 4.5,
                                child: const Padding(
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    'Fluids with potassium concentration greater than 0.2 mmol/kg/hour (>4.8 mmol/kg/day) should be infused via a central line',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.redAccent),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                )
              ],
            ),
          ))
        ],
      ),
    );
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
                                  labelStyle: TextStyle(fontSize: 13),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 6),
                                  suffixText: _mapUnitsString[_mapSelUnits]),
                              controller: controllerMAP,
                              textAlign: TextAlign.right,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: false,
                                decimal: false,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
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
                                    print('PaO2 $tempPaO2');
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
                                  labelStyle: TextStyle(fontSize: 13),

                                  //border: OutlineInputBorder(),
                                  contentPadding:
                                      const EdgeInsets.fromLTRB(0, 0, 10, 6),
                                  suffixText: _o2UnitsString[_o2SelUnits]),
                              //controller: fluidController,
                              textAlign: TextAlign.right,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: false,
                                decimal: false,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(3),
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

                            Navigator.of(context).push(
                              PageTransition(
                                type: PageTransitionType.rightToLeft,
                                child: OIDetail(
                                  inspiredO2: _inspired,
                                  map: _map,
                                  paO2: _paO2,
                                  mapUnits: (_mapSelUnits == 0)
                                      ? MapUnits.cmH2O
                                      : MapUnits.mmHg,
                                  paO2Units: (_o2SelUnits == 0)
                                      ? PaO2Units.kPa
                                      : PaO2Units.mmHg,
                                ),
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
              ],
            ),
          ),
        ),
      ),
      const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
    ]);
  }
}

class OIDetail extends StatelessWidget {
  final double inspiredO2;
  final double map;
  final double paO2;
  final MapUnits mapUnits;
  final PaO2Units paO2Units;

  const OIDetail({
    Key? key,
    required this.inspiredO2,
    required this.map,
    required this.paO2,
    required this.mapUnits,
    required this.paO2Units,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var oiResult = Neomate.oiCalculator(
      inspiredO2: inspiredO2,
      map: map,
      paO2: paO2,
      mapUnits: mapUnits,
      paO2Units: paO2Units,
    );

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: const [
            BackButton(),
            Expanded(
              child: Text(
                'Oxygenation Index (OI) Calculation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ]),
          Expanded(
              child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  color: AppConstants.colChecklist[2],
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextStandard(
                          text:
                              '''The oxygenation index (OI) measures the fraction of inspired oxygen and its usage within the body. A lower OI is better: as oxygenation improves, a baby will be able to achieve a higher PaO\u2082 at a lower FiO\u2082.

					OI > 25: indicates severe respiratory failure
					OI > 40: consider ECMO''',
                        ),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 20)),
                        const TextSubHeading(
                          text: 'Calculation',
                        ),
                        Visibility(
                          visible: oiResult.mmHgToCmH2O.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: TextCondensed(
                              text: oiResult.mmHgToCmH2O,
                            ),
                          ),
                        ),
                        Visibility(
                          visible: oiResult.kPaToMmHg.isNotEmpty,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                            child: TextCondensed(
                              text: oiResult.kPaToMmHg,
                            ),
                          ),
                        ),
                        CalcFormulaColumn(
                            topLine: oiResult.formulaTop,
                            bottomLine: oiResult.formulaBottom),
                        const Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                        Text(
                          '= Oxygenation Index ${oiResult.resultString}',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Visibility(
                          visible:
                              oiResult.result > 25 && oiResult.result <= 40,
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: TextAlert(
                              text:
                                  'OI > 25 indicates severe respiratory failure',
                            ),
                          ),
                        ),
                        Visibility(
                          visible: oiResult.result > 40,
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: TextAlert(
                              text: 'OI > 40 indicates consideration of ECMO',
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}

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
            padding: const EdgeInsets.all(10),
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
            ),
          ),
        ));
        redRow = !redRow;
      }
      if (drug is DrugBanded && !drug.weight!.isNaN) {
        // Row to display drug based on bandings of the weight
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(10),
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
            ),
          ),
        ));
        redRow = !redRow;
      }
      if (drug is DrugInfo && !drug.weight!.isNaN) {
        // Row to display drug that's information only
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(10),
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
            ),
          ),
        ));
        redRow = !redRow;
      }
      if (drug is DrugFormula && !drug.weight!.isNaN) {
        // Row to display drug that's information only
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(10),
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
                          text: '${drug.instructions}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ]))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
        redRow = !redRow;
      }
      if (drug is DrugInfusion && !drug.weight!.isNaN) {
        // Row to display drug that's information only
        drugRows.add(Container(
          color: redRow ? AppConstants.redRow : Colors.transparent,
          child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
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
                          const Padding(
                              padding: EdgeInsets.fromLTRB(0, 5, 0, 0)),
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
                                  type: PageTransitionType.rightToLeft,
                                  child: InfusionDrugDetail(drug: drug),
                                ),
                              )
                            },
                            icon: const Icon(Icons.calculate),
                            label: const Text('calculate'),
                          ),
                        ),
                      ),
                    ),
                    const Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 0)),
                  ])),
        ));
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
}

class InfusionDrugDetail extends ConsumerWidget {
  final DrugInfusion drug;

  const InfusionDrugDetail({
    Key? key,
    required this.drug,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.watch(neomateNotifier);
    String weight = notifier.weightStringShort;

    if (weight.isEmpty) {
      return Container();
    }

    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            const BackButton(),
            Expanded(
              child: Text(
                '${drug.name} infusion calculation',
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ]),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                      color: AppConstants.colChecklist[0],
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextHeading(
                                text: 'Calculations for a $weight baby',
                              ),
                              TextStandard(
                                text: drug.calcPreNarrative,
                              ),
                              CalcFormulaColumn(
                                topLine: drug.calcTop,
                                bottomLine: drug.calcBottom,
                              ),
                              Visibility(
                                visible: drug.calcRight.isNotEmpty,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 10, 0, 0),
                                  child: Text(
                                    drug.calcRight,
                                    style: const TextStyle(
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              TextResult(
                                text: drug.calcPostNarrative,
                              ),
                              TextResult(
                                text: drug.doseMsg,
                              ),
                            ]),
                      )),
                  Visibility(
                    visible: drug.dilute,
                    child: Card(
                      color: AppConstants.colChecklist[1],
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TextHeading(
                              text: 'To make a more concentrated solution',
                            ),
                            const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10)),
                            const TextStandard(
                              text:
                                  '''This drug calculation is for a dilute solution. That means it runs at a faster rate so that the fluid runs through the line dead space more quickly and is delivered to the patient sooner.
      
This is useful in the acute situation but can lead to fluid overload in the longer term. Once stable it may be appropriate to write up a more concentrated solution.''',
                            ),
                            const Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 14)),
                            const TextStandard(
                              text:
                                  '''To achieve this you need to multiply the added drug dose by a factor, and divide the rate by the same factor (usually 10).
  
For example:''',
                            ),
                            TextResult(
                              text: drug.concentratedCalc,
                            ),
                            TextResult(
                              text: drug.concentratedDoseRange,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
    return const ChecklistPage();
  }
}

class References extends StatelessWidget {
  const References({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ReferencePage();
  }
}

class About extends StatelessWidget {
  const About({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        htmlWidget(NeomateHtml.aboutPage),
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

// Checklists

class ChecklistPage extends StatefulWidget {
  const ChecklistPage({Key? key}) : super(key: key);

  @override
  State<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends State<ChecklistPage> {
  final checklistNavKey = GlobalKey<NavigatorState>();

  Widget _menu(BuildContext context) {
    List<Widget> checklistPages = [
      Container(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 5),
        child: htmlWidget(NeomateHtml.checklistPreamble),
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
                  type: PageTransitionType.rightToLeft,
                  child: _checklistPage(checklist),
                ),
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

  Widget _checklistPage(Checklist checklist) {
    List<Widget> checklistSections = [
      Container(
        color: AppConstants.colChecklistAbstract,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: htmlWidget(checklist.abstract),
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
            _checklistItems(
                section,
                AppConstants.colChecklist[
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
          Row(children: [
            const BackButton(),
            Expanded(
              child: Text(
                checklist.heading,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ]),
          Flexible(
            child: ListView(children: checklistSections),
          ),
        ],
      ),
    );
  }

  Widget _checklistItems(ChecklistSection section, Color color) {
    List<Widget> items = [];

    for (var item in section.items) {
      var myKey = GlobalKey<_ChecklistCheckboxState>();
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
                    child: htmlWidget(item),
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

class ChecklistCheckbox extends StatefulWidget {
  const ChecklistCheckbox({Key? key}) : super(key: key);

  @override
  State<ChecklistCheckbox> createState() => _ChecklistCheckboxState();
}

class _ChecklistCheckboxState extends State<ChecklistCheckbox> {
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

// Reference pages

class ReferencePage extends StatefulWidget {
  const ReferencePage({Key? key}) : super(key: key);

  @override
  State<ReferencePage> createState() => _ReferencePageState();
}

class _ReferencePageState extends State<ReferencePage> {
  final referenceNavKey = GlobalKey<NavigatorState>();

  Widget _menu(BuildContext context) {
    List<Widget> referencePages = [
      Container(
        padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
        child: htmlWidget(NeomateHtml.checklistPreamble),
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
                  type: PageTransitionType.rightToLeft,
                  child: _referencePage(reference),
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
            'Neonatal References',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: ListView(children: referencePages),
        ),
      ],
    );
  }

  Widget _referencePage(Reference reference) {
    List<Widget> referenceSections = [
      Container(
        color: AppConstants.colChecklistAbstract,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: htmlWidget(reference.abstract),
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
                  child: htmlWidget(section),
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
          Row(children: [
            const BackButton(),
            Flexible(
              child: Text(
                reference.heading,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ]),
          Flexible(
            child: ListView(children: referenceSections),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: WillPopScope(
        onWillPop: () async => !await referenceNavKey.currentState!.maybePop(),
        child: Navigator(
            key: referenceNavKey,
            onGenerateRoute: (routeSettings) {
              return MaterialPageRoute(
                builder: (context) => _menu(context),
              );
            }),
      ),
    );
  }
}

class CalcFormulaColumn extends StatelessWidget {
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
        )
      ],
    );
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
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
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
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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

class TextAlert extends StatelessWidget {
  final String text;
  const TextAlert({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 2, 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.redAccent,
          fontWeight: FontWeight.w600,
          height: 1.3,
        ),
      ),
    );
  }
}

// Classes for rendering html widgets and handling urls

Widget htmlWidget(data) {
  return Html(
      data: data,
      style: {
        // p tag with text_size
        "p": Style(
          fontSize: const FontSize(13),
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
        print("tap");
        if (url is String) {
          doLaunchUrl(Uri.parse(url));
        }
      });
}

void doLaunchUrl(Uri url) async {
  // Launch URL as an async task
  if (!await launchUrl(url)) throw 'Could not launch $url';
}
