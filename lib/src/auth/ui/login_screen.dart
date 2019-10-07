import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quick_start/src/auth/bloc/login_screen_bloc.dart';
import 'package:flutter_quick_start/src/core/analytics/bloc/analytics_bloc.dart';
import 'package:flutter_quick_start/src/core/core.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  ApplicationBloc _applicationBloc;
  AnalyticsBloc _analyticsBloc;
  LoginScreenBloc _loginScreenBloc;

  var _usernameController = TextEditingController();
  var _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _applicationBloc = BlocProvider.of(context);
    _analyticsBloc = BlocProvider.of(context);
    _loginScreenBloc = LoginScreenBloc(
      applicationBloc: _applicationBloc,
      analyticsBloc: _analyticsBloc,
      loginRepo: sl(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _loginScreenBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: BlocListener(
        bloc: _loginScreenBloc,
        listener: (context, LoginScreenState state) {
          if (state is LoginScreenStateError) {
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text('Login Failed'),
            ));
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
                  decoration: InputDecoration(labelText: 'Username Label'),
                  controller: _usernameController,
                ),
                SizedBox(height: 8),
                TextField(
                  decoration: InputDecoration(labelText: 'Password Label'),
                  controller: _passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 8),
                BlocBuilder(
                  bloc: _loginScreenBloc,
                  builder: (_, LoginScreenState state) {
                    if (state is LoginScreenStateLoading) {
                      return CircularProgressIndicator();
                    } else {
                      return RaisedButton(
                        child: Text('Click to login'),
                        onPressed: _loginPressed,
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
    _loginScreenBloc.dispatch(LoginScreenEventLoginPressed(
      _usernameController.text,
      _passwordController.text,
    ));
  }
}
