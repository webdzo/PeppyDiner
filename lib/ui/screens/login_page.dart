import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:hotelpro_mobile/screen_util/flutter_screenutil.dart';

import '../../bloc/login/login_bloc.dart';
import '../../bloc/login/login_event.dart';
import '../../bloc/login/login_state.dart';
import '../../models/login_request.dart';
import '../../route_generator.dart';
import '../widgets/auth_button.dart';
import '../widgets/text_field.dart';
import '../widgets/text_widget.dart';

class Signin extends StatefulWidget {
  const Signin({Key? key}) : super(key: key);

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final usernameController = TextEditingController();
  final pwdController = TextEditingController();
  bool locationAccess = true;
  String get phonenumber => usernameController.text.trim();
  String get otp => pwdController.text.trim();
  String? verifiedId;
  LoginBloc loginBloc = LoginBloc();

  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context)
      ..stream.listen((event) {
        if (event is LoginLoad) {
          EasyLoading.show(status: 'loading...');
        }
        if (event is LoginDone) {
          EasyLoading.showSuccess('Success!');
          navigatorKey.currentState?.pushNamedAndRemoveUntil(
            "/home",
            (route) {
              return false;
            },
          );
        } else if (event is LoginError) {
          EasyLoading.showError('Failed with Error');
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30.w),
              height: MediaQuery.of(context).size.height * 0.20,
              child: Image.asset(
                "assets/appicon.png",
                height: 90.w,
                fit: BoxFit.fill,
                width: 130.w,
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: HexColor("#d4ac2c"),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(100.w),
                        topRight: Radius.circular(100.w))),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 100.w, horizontal: 30.w),
                        child: TextWidget(
                          "LOGIN",
                          color: HexColor("#434344"),
                          style: GoogleFonts.sono(
                              fontWeight: FontWeight.bold,
                              fontSize: 50.w,
                              shadows: [
                                const Shadow(
                                  offset: Offset(3, 0),
                                  blurRadius: 10.0,
                                  color: Colors.white,
                                ),
                                const Shadow(
                                  offset: Offset(3, 0),
                                  blurRadius: 10.0,
                                  color: Colors.white,
                                ),
                              ]),
                        ),
                      ),
                      SizedBox(
                        height: 24.w,
                      ),
                      CustomFormField(
                        headingText: "Username",
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        obsecureText: false,
                        suffixIcon: const SizedBox(
                          width: 3,
                        ),
                        controller: usernameController,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.029,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.width * 0.009,
                      ),
                      CustomFormField(
                        headingText: "Password",
                        maxLines: 1,
                        textInputAction: TextInputAction.done,
                        textInputType: TextInputType.text,
                        obsecureText: false,
                        suffixIcon: const SizedBox(
                          width: 3,
                        ),
                        controller: pwdController,
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                      ),
                      AuthButton(
                        onTap: () {
                          /*   loginBloc.add(Login(LoginRequest(
                            username:
                                "admin@webdzostayz.com", //usernameController.text,
                            password: "Admin@2023", //pwdController.text
                          ))); */

                          //  makePdf(Invoice.fromJson({"data": "akshaya"}));

                          loginBloc.add(Login(LoginRequest(
                              username: usernameController.text,
                              password: pwdController.text)));
                        },
                        text: "SIGN IN",
                        color: Colors.white,
                        fontColor: HexColor("#d4ac2c"),
                        fontweight: FontWeight.bold,
                        fontsize: 20.sp,
                      )
                      /*  AuthButton(
                        onTap: () async {
                          
                        },
                        text: 'LOGIN',
                        fontweight: FontWeight.bold,
                      ), */
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
