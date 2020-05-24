import 'package:flutter/material.dart';
import 'package:flutter_crud/models/user.dart';
import 'package:flutter_crud/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserForm createState() => _UserForm();
}

class _UserForm extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  bool _validate = false;
  final Map<String, String> _formData = {};

  String _isEmpty(String value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo não pode ser vazio';
    }
    return null;
  }

  void _submitForm() {
    if (_form.currentState.validate()) {
      _form.currentState.save();
      Provider.of<Users>(context, listen: false).put(
        User(
          id: _formData['id'],
          name: _formData['name'],
          email: _formData['email'],
          avatarUrl: _formData['avatarUrl'],
        ),
      );
      Navigator.of(context).pop();
    } else {
      setState(() {
        _validate = true;
      });
    }
  }

  void _loadFormData(User user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['name'] = user.name;
      _formData['email'] = user.email;
      _formData['avatarUrl'] = user.avatarUrl;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final User user = ModalRoute.of(context).settings.arguments;
    _loadFormData(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Form user'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _submitForm)
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: EdgeInsets.all(15),
            child: Form(
                key: _form,
                autovalidate: _validate,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Nome'),
                      validator: _isEmpty,
                      initialValue: _formData['name'],
                      onSaved: (value) => _formData['name'] = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: _isEmpty,
                      initialValue: _formData['email'],
                      keyboardType: TextInputType.emailAddress,
                      onSaved: (value) => _formData['email'] = value,
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Avatar'),
                      validator: _isEmpty,
                      initialValue: _formData['avatarUrl'],
                      onSaved: (value) => _formData['avatarUrl'] = value,
                    )
                  ],
                ))),
      ),
    );
  }
}
