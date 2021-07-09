import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:schoolproject/components/consts.dart';
import 'package:schoolproject/components/customDialogs.dart';
import 'package:schoolproject/components/customText.dart';
import 'package:schoolproject/components/noData.dart';
import 'package:schoolproject/providers/classesProvider.dart';
import 'package:schoolproject/providers/profileProvider.dart';
import 'package:schoolproject/screens/SplashScreen/splashPage.dart';
import 'package:schoolproject/screens/student/HomePage/page1.dart';
import 'package:schoolproject/screens/student/HomePage/page2.dart';
import 'package:schoolproject/screens/student/HomePage/page3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StudentHomePage extends StatefulWidget {
  const StudentHomePage({Key key}) : super(key: key);

  @override
  _StudentHomePageState createState() => _StudentHomePageState();
}

class _StudentHomePageState extends State<StudentHomePage> {
  String email;
  int _index = 0;
  int selectedIndex;
  //get data
  getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      email = prefs.getString("studentEmail");
      selectedIndex = int.tryParse(prefs.getString("index"));
    });
    final infoProvider = Provider.of<ClassesProvider>(context, listen: false);
    infoProvider.getData(email);
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    profileProvider.getProfil(email);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ClassesProvider infoProvider = Provider.of<ClassesProvider>(context);
    ProfileProvider profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
          color: Colors.white,
          sizes: TextSize.title,
          text: "Anasayfa",
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        actions: [
          IconButton(
              icon: Icon(
                Icons.logout,
                color: Colors.white,
              ),
              onPressed: () {
                _onBackPressed();
              })
        ],
      ),
      body: infoProvider.loading || profileProvider.loading
          ? const Center(
              child: const CircularProgressIndicator(),
            )
          : infoProvider.error || profileProvider.error
              ? NoData(
                  text: "Veri bulunamadı.İnternet bağlantınızı kontrol ediniz",
                )
              : _index == 0
                  ? WillPopScope(
                      onWillPop: _onBackPressed,
                      child: Page1(
                        infoProvider: infoProvider,
                        selectedIndex: selectedIndex,
                      ),
                    )
                  : _index == 1
                      ? WillPopScope(
                          onWillPop: _onBackPressed,
                          child: Page2(
                            infoProvider: infoProvider,
                            selectedIndex: selectedIndex,
                          ),
                        )
                      : WillPopScope(
                          onWillPop: _onBackPressed,
                          child: Page3(
                              infoProvider: infoProvider,
                              selectedIndex: selectedIndex,
                              profileProvider: profileProvider)),
      bottomNavigationBar: BottomNavigationBar(
        selectedFontSize: 15,
        unselectedFontSize: 13,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Anasayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Ders Programı',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ayarlar',
          ),
        ],
        currentIndex: _index,
        selectedItemColor: primaryColor,
        onTap: _onItemTapped,
      ),
    );
  }

  //for onBackPress
  Future<bool> _onBackPressed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CustomDialog()
        .secondDialog(context, "Çıkış yapmak istediğinize emin misiniz?", () {
      prefs.clear();
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => SplashPage()),
          (Route<dynamic> route) => false);
    }, () {
      Navigator.pop(context);
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}
