import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:news_app/provider/theme_provider.dart';
import 'package:news_app/provider/count_provider.dart';
import 'package:news_app/screens/home_screen.dart';

import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:provider/provider.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

void main() async {




  WidgetsFlutterBinding.ensureInitialized();
  final appDirectory = await pathProvider.getApplicationDocumentsDirectory();
  Hive.init(appDirectory.path);

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;


  runApp(
    /**
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(isLightTheme: isLightTheme),
      child: AppStart(),
    ),
       **/

      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ThemeProvider(isLightTheme: isLightTheme),
          ),
          ChangeNotifierProvider(create: (_) => Counter()),
        ], child: AppStart()
      )

  );


}




class AppStart extends StatelessWidget {
  const AppStart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {



    Counter counter = Provider.of<Counter>(context);
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return MyApp(themeProvider: themeProvider,counter:counter);
  }
}

class MyApp extends StatelessWidget with WidgetsBindingObserver {
  final ThemeProvider themeProvider;
  final Counter counter;
  const MyApp({Key? key, required this.themeProvider,required this.counter});

  @override
  Widget build(BuildContext context) {
    int count = Provider.of<Counter>(context).count;
    if(count == 0) {


      SSEClient.subscribeToSSE(
          url:
          'https://reward-api.staging.newming.io/api/newming/deploy/listen',
          header: {
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          }).listen((event) {
        print('Id: ' + event.id!);
        print('Event: ' + event.event!);
        print('Data: ' + event.data!);


       // this.counter.increment();
      }, onError: (error) {
            print('main ${error}' );
        /**
         * todo 구독용 Provider 추구 하기
         */
        //this.counter.init();
      });
    }


    return MaterialApp(
      theme: themeProvider.themeData(),
      home: HomeScreen(category: '0'),
    );
  }
}
