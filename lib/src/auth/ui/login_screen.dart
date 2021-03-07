import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app/index.dart';
import '../../core/index.dart';
import '../bloc/login_screen_bloc.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ApplicationBloc _applicationBloc;
  NotificationBloc _notificationBloc;
  LoginScreenBloc _loginScreenBloc;

  final _usernameController = TextEditingController(text: 'eve.holt@reqres.in');
  final _passwordController = TextEditingController(text: 'password');

  @override
  void initState() {
    super.initState();
    _applicationBloc = BlocProvider.of(context);
    _notificationBloc = BlocProvider.of(context);
    _loginScreenBloc = LoginScreenBloc(
      applicationBloc: _applicationBloc,
      analyticsService: sl(),
      loginRepo: sl(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginScreenBloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocListener(
        cubit: _loginScreenBloc,
        listener: (context, LoginScreenState state) {
          if (state is LoginScreenStateError) {
            _notificationBloc.add(NotificationEvent(message: 'Login Failed'));
          }
        },
        child: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CircleAvatar(
                    child: Icon(Icons.person, size: 80),
                    radius: 80,
                  ),
                ),
                TextField(
                  key: Key('__username_text_field__'),
                  decoration: InputDecoration(labelText: 'Username Label'),
                  controller: _usernameController,
                ),
                SizedBox(height: 8),
                TextField(
                  key: Key('__password_text_field__'),
                  decoration: InputDecoration(labelText: 'Password Label'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 8),
                BlocBuilder(
                  cubit: _loginScreenBloc,
                  builder: (_, LoginScreenState state) {
                    if (state is LoginScreenStateLoading) {
                      return CircularProgressIndicator();
                    } else {
                      return Column(
                        children: <Widget>[
                          RaisedButton(
                            child: Text('Click to login'),
                            onPressed: _loginPressed,
                          ),
                          SizedBox(height: 8),
                          RaisedButton(
                            child: Text('OAuth Login'),
                            onPressed: _loginOAuthPressed,
                          ),
                        ],
                      );
                    }
                  },
                ),
                Expanded(child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loginPressed() {
    _loginScreenBloc.add(LoginScreenEventLoginPressed(
      _usernameController.text,
      _passwordController.text,
    ));
  }

  void _loginOAuthPressed() async {
    _loginScreenBloc.add(LoginScreenEventOAuthLoginPressed());
  }
}
