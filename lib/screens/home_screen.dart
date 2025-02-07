import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:telegram_web_app/telegram_web_app.dart';

class HomeScreen extends StatefulWidget{
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // final TelegramWebApp telegram = TelegramWebApp.instance;
  // TelegramUser? telegramUser;


  @override
  void initState() {
    super.initState();
    // telegramUser = telegram.initData.user;

    // FlutterError.onError = (details) {
    //   showSnackBar("Flutter error: $details");
    //   print("Flutter error happened: $details");
    // };

    // TelegramWebApp.instance.ready();

    check();
  }

  void check() async {
    await Future.delayed(const Duration(seconds: 2));
    // isDefinedVersion = telegram.isVersionAtLeast('Bot API 6.1');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // if (telegramUser == null){
    //   return Text('Error');
    // }
    // TelegramWebApp.instance.initData.;


    return  Scaffold(
      appBar: AppBar(
        title:  Column(
          children: [
            Row(
              children: [
                CircleAvatar(),
                SizedBox(width: 5,),
                Column(
                  children: [
                    Text('telegramUser!.firstname!', style: Theme.of(context).textTheme.bodySmall!,),
                    Text('telegramUser!.lastname!', style: Theme.of(context).textTheme.bodySmall!),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

          ],
        ),
      ),
    );
  }
}