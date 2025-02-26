import 'package:flutter/material.dart';
import 'package:heroapp/pages/settings_page/help_and_support_page.dart';

import '../../utils/constants.dart';
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
            Center(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: HexColor.fromHex(AppConstants.primaryColor)
                ),
              ),
            ),
            SizedBox(height: 120,),
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width - 50,
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: HexColor.fromHex(AppConstants.primaryColor)
                ),
                child: Column(
                  children: [
                    SizedBox(height: 20,),
                    Text("Logout", style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                    )),
                    SizedBox(height: 50,),
                    Text("Are you sure you want to logout?", style: TextStyle(
                        color: Colors.black,
                        // fontWeight: FontWeight.bold,
                        fontSize: 16
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
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 3
                                  ),
                                color: Colors.white
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
                              height: 45,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.black
                              ),
                              child: Center(
                                  child: Text("Logout", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.red
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
            SizedBox(height: 150,),
            InkWell(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HelpAndSupportPage())),
              child: Center(
                child: Text("Need Help? Visit our help center", style: TextStyle(
                  fontWeight: FontWeight.bold
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
