import 'package:flutter/material.dart';
import 'package:loopyfeed/utils/constants.dart';

import '../../pages/settings_page/help_and_support_page.dart';
import '../../utils/components/full_logo.dart';
import '../../utils/extensions/color.dart';

class LogoutPage extends StatelessWidget {
  const LogoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logout", style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18
      )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),
            FullLogo(),
            SizedBox(height: 90,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor.fromHex(AppConstants.primaryWhite)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.arrow_back, color: Colors.black, size: 35,),
                        Text("Logout", style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 24
                        )),
                        Container()
                        // Spacer()
                      ],
                    ),
                    SizedBox(height: 50,),
                    Text("Are you sure you want to logout?", style: TextStyle(
                        color: Colors.black,
                        fontSize: 20
                    ), textAlign: TextAlign.center,),
                    SizedBox(height: 50,),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap:(){
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: HexColor.fromHex(AppConstants.primaryColor)
                              ),
                              child: Center(
                                child: Text("Cancel", style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: Colors.black
                                ))
                              ),
                            ),
                          ),
                          SizedBox(width: 10,),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3.5,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.black
                              ),
                              child: Center(
                                  child: Text("Logout", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.white
                                  ))
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30,),
                  ],
                ),
              ),
            ),
            SizedBox(height: 130,),
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportPage())),
              child: Center(
                child: Text("Need Help? Visit our help center", style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
