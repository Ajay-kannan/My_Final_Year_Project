import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:plantify/Pages/home.dart';
import 'package:plantify/Pages/login.dart';
import 'package:plantify/Pages/register.dart';
import 'package:plantify/Provider/auth.dart';
import 'package:plantify/firebase_options.dart';
import 'package:plantify/models/firebaseuser.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ChangeNotifierProvider(
    create: (context) => ThemeProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        theme: Provider.of<ThemeProvider>(context).themeData ,
        home: const LoaderPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser?>(context);

    if (user == null) {
      return const Handler();
    } else {
      return const Home();
    }
  }
}

class Handler extends StatefulWidget {
  const Handler({super.key});

  @override
  State<StatefulWidget> createState() {
    return _Handler();
  }
}

class _Handler extends State<Handler> {
  bool showSignin = true;

  void toggleView() {
    setState(() {
      showSignin = !showSignin;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showSignin) {
      return Login(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}

class LoaderPage extends StatefulWidget {
  const LoaderPage({super.key});

  @override
  _LoaderPageState createState() => _LoaderPageState();
}

class _LoaderPageState extends State<LoaderPage> {
  @override
  void initState() {
    super.initState();
    // Delay navigation to login page by 1 second
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context as BuildContext,
        MaterialPageRoute(builder: (context) => const Wrapper()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 1.0; // Adjust animation speed if necessary

    return Scaffold(
      body: Container(
        color:
            const Color(0xff00a86b), // Set your desired background color here
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Logo at the center top
              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Image.asset(
                  "assets/logo.png", // Set your logo image here
                  height: 175,
                  width: 175,
                ),
              ),
              const SizedBox(height: 20),
              // App name in the middle
              const Text(
                "Plantify",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 100),
              // Loader at the bottom
              Container(
                child: LoadingAnimationWidget.discreteCircle(
                  color: Colors.white,
                  size: 50,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
