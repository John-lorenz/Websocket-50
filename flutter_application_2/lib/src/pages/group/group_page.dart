import 'package:flutter/material.dart';
import 'package:flutter_application_2/src/foundation/msg_widget/other_msg_widget.dart';
import 'package:flutter_application_2/src/pages/group/msg_model.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:uuid/uuid.dart';
import '../../foundation/msg_widget/own_msg-widget.dart';

class GroupPage extends StatefulWidget {
  final String name;
  final String userId;
  const GroupPage({Key? key, required this.name, required this.userId})
      : super(key: key);
      

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  IO.Socket? socket;
  List<MsgModel> listMsg = [];
  TextEditingController _msgController = TextEditingController();
  @override
  void initState() {
    super.initState();
    connect();
  }
// TODO: implement initState

  void connect() {
    socket = IO.io("http://localhost:3000/", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket!.connect();
    socket!.onConnect((_) {
      print('connected into frontend');
      socket!.on("sendMsgServe", (msg) {
        print(msg);

        if (msg["userId"] != widget.userId) {
          setState(() {
            listMsg.add(
              MsgModel(
                  msg: msg["msg"],
                  type: msg["type"],
                  sender: msg["senderName"]),
            );
          });
        }
      });
    });
  }

  void sendMsg(String msg, String senderName) {
    MsgModel ownmsg = MsgModel(
      msg: msg,
      type: "ownMsg",
      sender: senderName,
    );
    listMsg.add(ownmsg);
    setState(() {
      listMsg;
    });
    socket!.emit(
      'sendMsg',
    );
    socket!.emit('sendMsg', {
      "type": "ownMsg",
      "msg": msg,
      "senderName": senderName,
      "userId": widget.userId
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Grupo de apostas"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  itemCount: listMsg.length,
                  itemBuilder: (context, index) {
                    if (listMsg[index].type == "ownMsg") {
                      return OwnMsgWidget(
                          msg: listMsg[index].msg,
                          sender: listMsg[index].sender);
                    } else
                      return OtherMsgWidget(
                        msg: listMsg[index].msg,
                        sender: listMsg[index].sender,
                      );
                  })),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: "Digite aqui ...",
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    String msg = _msgController.text;
                    if (msg.isNotEmpty) {
                      sendMsg(msg, widget.name);
                      _msgController.clear();
                    }
                  },
                  icon: const Icon(
                    Icons.send,
                    color: Colors.teal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
