import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/pages/group/group_page.dart';
import 'package:uuid/uuid.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
TextEditingController nameController = TextEditingController();


final formKey = GlobalKey<FormState>();
var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Aposta em grupo"),
      ),
      body: Center(
        child: TextButton(
          onPressed: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text("Por favor, digite seu nome"),
              content: Form(
                key: formKey,
                child: TextFormField(
                  controller: nameController,
                  validator: (value) {
                    if(value == null || value.length<3 )
                    {
                      return "Por favor, insira um nome";
                    }
                    return null;
                  }
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    nameController.clear();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Cancelar",
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    print(nameController.text);
                    if (formKey.currentState!.validate())
                    {
                      String name = nameController.text;
                      nameController.clear();
                      Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupPage(name: name, userId: uuid.v1(),),
                      ),
                    );}
                  },
                  child: const Text(
                    "Entrar",
                    style: TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                ),
              ],
            ),
          ),
          child: Text(
            "Criar grupo",
            style: TextStyle(
              color: Colors.teal,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
