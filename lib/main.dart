import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pro1/redux/reducer/auth_reducer.dart';
import 'package:redux/redux.dart';
import 'package:pro1/login/login.dart';

void main() {
  // Initialize Redux store
  final Store<String> store = Store<String>(
    authReducer,
    initialState: "",
  );

  runApp(MyApp(store: store));
}

class MyApp extends StatelessWidget {
  final Store<String> store;

  const MyApp({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<String>(
      store: store, // Providing store to the whole app
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            color: Colors.blue
          )
        ),
        debugShowCheckedModeBanner: false,
        home: Login(), // Start with the Login screen
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:redux/redux.dart';
// import 'package:redux_thunk/redux_thunk.dart';
// import 'package:pro1/redux/reducer/auth_reducer.dart';
// import 'package:pro1/redux/action/auth_action.dart';
// import 'package:pro1/login/login.dart';
// import 'package:pro1/category/category_list.dart';
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//
//   // Initialize Redux store with AppState
//   final Store<AppState> store = Store<AppState>(
//     authReducer,
//     initialState: initialState,
//     middleware: [thunkMiddleware], // Add middleware for async operations
//   );
//
//   runApp(MyApp(store: store));
// }
//
// class MyApp extends StatelessWidget {
//   final Store<AppState> store;
//
//   const MyApp({super.key, required this.store});
//
//   @override
//   Widget build(BuildContext context) {
//     return StoreProvider<AppState>(
//       store: store,
//       child: StoreConnector<AppState, String>(
//         converter: (store) => store.state.token,
//         builder: (context, token) {
//           return MaterialApp(
//             theme: ThemeData(appBarTheme: AppBarTheme(color: Colors.blue)),
//             debugShowCheckedModeBanner: false,
//             home: Login(), // Redirect if logged in
//           );
//         },
//       ),
//     );
//   }
// }
