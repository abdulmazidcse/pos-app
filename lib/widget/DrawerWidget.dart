import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeDrawer extends StatefulWidget {
  const HomeDrawer(
      {Key? key,
        this.screenIndex,
        this.iconAnimationController,
        this.callBackIndex})
      : super(key: key);

  final AnimationController? iconAnimationController;
  final DrawerIndex? screenIndex;
  final Function(DrawerIndex)? callBackIndex;

  @override
  _HomeDrawerState createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {
  List<DrawerList>? drawerList;
  late Map<String, dynamic> userInfo = {};
  @override
  void initState() {
    setDrawerListArray();
    super.initState();
  }

  userProfile() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = localStorage.getString('user');
    setState(() {
      userInfo = json.decode(user!);
    });
  }

  Widget _infoTile(String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle.isEmpty ? 'Not set' : subtitle),
    );
  }

  void setDrawerListArray() {
    drawerList = <DrawerList>[
      DrawerList(
        index: DrawerIndex.HOME,
        labelName: 'Home',
        icon: Icon(Icons.home),
      ),

      DrawerList(
        index: DrawerIndex.Profile,
        labelName: 'Profile',
        icon: Icon(Icons.account_box_rounded),
      ),

      DrawerList(
        index: DrawerIndex.DailyActivity,
        labelName: 'Daily Activities',
        icon: Icon(Icons.task),
      ),

      DrawerList(
        index: DrawerIndex.Leave,
        labelName: 'Leave',
        icon: Icon(Icons.access_time_filled),
      ),

      DrawerList(
        index: DrawerIndex.Adjustment,
        labelName: 'Adjustment',
        icon: Icon(Icons.verified_user_sharp),
      ),

      DrawerList(
        index: DrawerIndex.Loan,
        labelName: 'Loan',
        icon: Icon(Icons.monetization_on_sharp),
      ),

      DrawerList(
        index: DrawerIndex.Payslip,
        labelName: 'Payslip',
        icon: Icon(Icons.edit_document),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    String name = userInfo['employeeName'].toString();
    String employeeCode = userInfo['employeeCode'].toString();
    String departmentName = userInfo['departmentName'].toString();
    String designationID = userInfo['designationID'].toString();
    String employeeimage = userInfo['employeeimage'].toString();

    final employeeImage = userInfo['employeeimage'];
    final urlImage = employeeImage != null
        ? 'https://hris.ssgbd.com/${employeeImage.replaceAll('~', '')}'
        : '';

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isLightMode = brightness == Brightness.light;
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 162,
            width: double.infinity,
            color: Colors.red,
            // decoration: BoxDecoration(
            //     image: DecorationImage(
            //         image: AssetImage("assets/images/drawer04.jpg"),
            //         fit: BoxFit.fill)),
            padding: const EdgeInsets.only(top: 35.0),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    AnimatedBuilder(
                      animation: widget.iconAnimationController!,
                      builder: (BuildContext context, Widget? child) {
                        return ScaleTransition(
                          scale: AlwaysStoppedAnimation<double>(1.0 -
                              (widget.iconAnimationController!.value) * 0.2),
                          child: RotationTransition(
                            turns: AlwaysStoppedAnimation<double>(Tween<double>(
                                begin: 0.0, end: 24.0)
                                .animate(CurvedAnimation(
                                parent: widget.iconAnimationController!,
                                curve: Curves.fastOutSlowIn))
                                .value /
                                360),
                            child: Container(
                              height: 80,
                              width: 80,
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.6),
                                      offset: const Offset(2.0, 4.0),
                                      blurRadius: 8),
                                ],
                              ),
                              child: CircleAvatar(
                                radius: 10.0,
                                backgroundImage: urlImage != null
                                    ? NetworkImage(urlImage)
                                    : null,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 2.0),
                          child: Text(
                            '${name}',
                            style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            ),
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Employee ID : ${employeeCode}',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Designation : ${designationID}',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'Department : ${departmentName}',
                          style: TextStyle(
                              fontSize: 12.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Container(
                  padding: const EdgeInsets.only(
                    top: 4.0,
                  ),
                  height: 30,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(0.0),
              itemCount: drawerList?.length,
              itemBuilder: (BuildContext context, int index) {
                return inkwell(drawerList![index]);
              },
            ),
          ),
          Divider(
            height: 1,
            color: Colors.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  onTapped();
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  void onTapped() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setBool('isLoggedIn', false);
    // Navigator.of(context).pushAndRemoveUntil(
    //     new MaterialPageRoute(builder: (context) => new LogIn()),
    //     (route) => false);

    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(builder: (context) => new LogIn()),
    //         (Route<dynamic> route) => false);
    // RemoteServices.successMessage('Logout Success!');
  }

  Widget inkwell(DrawerList listData) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.grey.withOpacity(0.1),
        highlightColor: Colors.transparent,
        onTap: () {
          navigationtoScreen(listData.index!);
        },
        child: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 6.0,
                    height: 46.0,
                    // decoration: BoxDecoration(
                    //   color: widget.screenIndex == listData.index
                    //       ? Colors.blue
                    //       : Colors.transparent,
                    //   borderRadius: new BorderRadius.only(
                    //     topLeft: Radius.circular(0),
                    //     topRight: Radius.circular(16),
                    //     bottomLeft: Radius.circular(0),
                    //     bottomRight: Radius.circular(16),
                    //   ),
                    // ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  listData.isAssetsImage
                      ? Container(
                    width: 24,
                    height: 24,
                  )
                      : Icon(listData.icon?.icon,
                      color: widget.screenIndex == listData.index
                          ? Colors.blue
                          : Colors.green),
                  const Padding(
                    padding: EdgeInsets.all(4.0),
                  ),
                  Text(
                    listData.labelName,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
            widget.screenIndex == listData.index
                ? AnimatedBuilder(
              animation: widget.iconAnimationController!,
              builder: (BuildContext context, Widget? child) {
                return Transform(
                  transform: Matrix4.translationValues(
                      (MediaQuery.of(context).size.width * 0.75 - 64) *
                          (1.0 -
                              widget.iconAnimationController!.value -
                              1.0),
                      0.0,
                      0.0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8, bottom: 8),
                    child: Container(
                      width:
                      MediaQuery.of(context).size.width * 0.75 - 64,
                      height: 46,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.4),
                        borderRadius: new BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(28),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(28),
                        ),
                      ),
                    ),
                  ),
                );
              },
            )
                : const SizedBox()
          ],
        ),
      ),
    );
  }

  Future<void> navigationtoScreen(DrawerIndex indexScreen) async {
    widget.callBackIndex!(indexScreen);
  }
}

enum DrawerIndex {
  HOME,
  History,
  Help,
  Profile,
  ChangePass,
  Share,
  About,
  Invite,
  Testing,
  Leave,
  Adjustment,
  Loan,
  Payslip,
  DailyActivity
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.imageName = '',
  });

  String labelName;
  Icon? icon;
  bool isAssetsImage;
  String imageName;
  DrawerIndex? index;
}
