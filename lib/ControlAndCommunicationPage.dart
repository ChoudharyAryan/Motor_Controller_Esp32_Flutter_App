// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';
// import 'dart:typed_data';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'GenericSnackBar.dart';

// class ControlAndCommunicationPage extends StatefulWidget {
//   //final BluetoothDevice server;

//   const ControlAndCommunicationPage({super.key, required this.server});

//   @override
//   _ChatPage createState() => _ChatPage();
// }

// class _Message {
//   int whom;
//   String text;

//   _Message(this.whom, this.text);
// }

// class _ChatPage extends State<ControlAndCommunicationPage> {
//   static const clientID = 0;
//   //BluetoothConnection? connection; //BluetoothConnection

//   // List<_Message> messages = [];
  

//   // final TextEditingController textEditingController = TextEditingController();
//   // final ScrollController listScrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     log("inide of the initstate of the CONTROLAND COMMUNICATIONPAGE");
//     // try {
//     //   BluetoothConnection.toAddress(widget.server.address).then((_connection) {
//     //     log('Connected to the device');
//     //     connection = _connection;
//     //     setState(() {
//     //       isConnecting = false;
//     //       isDisconnecting = false;
//     //     });

//     //     connection?.input?.listen(_onDataReceived).onDone(() {
//     //       // Example: Detect which side closed the connection
//     //       // There should be `isDisconnecting` flag to show are we are (locally)
//     //       // in middle of disconnecting process, should be set before calling
//     //       // `dispose`, `finish` or `close`, which all causes to disconnect.
//     //       // If we except the disconnection, `onDone` should be fired as result.
//     //       // If we didn't except this (no flag set), it means closing by remote.
//     //       if (isDisconnecting) {
//     //         log('Disconnecting locally!');
//     //       } else {
//     //         log('Disconnected remotely!');
//     //       }
//     //       if (mounted) {
//     //         setState(() {});
//     //       }
//     //     });
//     //   });
//     // } catch (e) {
//     //   ShowSnackBarClass.ShowErrorSnackBar(context, e.toString());
//     //   Navigator.of(context).pop();
//     // }
//   }

//   @override
//   void dispose() {
//     // Avoid memory leak (`setState` after dispose) and disconnect

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final List<Row> list = messages.map((_message) {
//       return Row(
//         mainAxisAlignment: _message.whom == clientID
//             ? MainAxisAlignment.end
//             : MainAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: const EdgeInsets.all(12.0),
//             margin: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
//             width: 222.0,
//             decoration: BoxDecoration(
//                 color:
//                     _message.whom == clientID ? Colors.blueAccent : Colors.grey,
//                 borderRadius: BorderRadius.circular(7.0)),
//             child: Text(
//                 (text) {
//                   return text == '/shrug' ? '¯\\_(ツ)_/¯' : text;
//                 }(_message.text.trim()),
//                 style: const TextStyle(color: Colors.white)),
//           ),
//         ],
//       );
//     }).toList();

//     return Scaffold(
//       appBar: AppBar(
//           title: (isConnecting
//               ? Text('Connecting chat to ${widget.server.name}...')
//               : isConnected()
//                   ? Text('Live chat with ${widget.server.name}')
//                   : Text('Chat log with ${widget.server.name}'))),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             Flexible(
//               child: ListView(
//                   padding: const EdgeInsets.all(12.0),
//                   controller: listScrollController,
//                   children: list),
//             ),
//             Row(
//               children: <Widget>[
//                 Flexible(
//                   child: Container(
//                     margin: const EdgeInsets.only(left: 16.0),
//                     child: TextField(
//                       style: const TextStyle(fontSize: 15.0),
//                       controller: textEditingController,
//                       decoration: InputDecoration.collapsed(
//                         hintText: isConnecting
//                             ? 'Wait until connected...'
//                             : isConnected()
//                                 ? 'Type your message...'
//                                 : 'Chat got disconnected',
//                         hintStyle: const TextStyle(color: Colors.grey),
//                       ),
//                       enabled: isConnected(),
//                     ),
//                   ),
//                 ),
//                 Container(
//                   margin: const EdgeInsets.all(8.0),
//                   child: IconButton(
//                       icon: const Icon(Icons.send),
//                       onPressed: isConnected()
//                           ? () => _sendMessage(
//                               "${textEditingController.text}concatanation is working")
//                           : null),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }

// // DATA IS COMING BACK JUST NOT HOW I WANT IT TO
//   void _onDataReceived(Uint8List data) {
//     // Allocate buffer for parsed data
//     int backspacesCounter = 0;
//     data.forEach((byte) {
//       if (byte == 8 || byte == 127) {
//         backspacesCounter++;
//       }
//     });
//     Uint8List buffer = Uint8List(data.length - backspacesCounter);
//     int bufferIndex = buffer.length;

//     // Apply backspace control character
//     backspacesCounter = 0;
//     for (int i = data.length - 1; i >= 0; i--) {
//       if (data[i] == 8 || data[i] == 127) {
//         backspacesCounter++;
//       } else {
//         if (backspacesCounter > 0) {
//           backspacesCounter--;
//         } else {
//           buffer[--bufferIndex] = data[i];
//         }
//       }
//     }

//     // Create message if there is new line character
//     String dataString = String.fromCharCodes(buffer);
//     int index = buffer.indexOf(13);
//     if (~index != 0) {
//       setState(() {
//         messages.add(
//           _Message(
//             1,
//             backspacesCounter > 0
//                 ? _messageBuffer.substring(
//                     0, _messageBuffer.length - backspacesCounter)
//                 : _messageBuffer + dataString.substring(0, index),
//           ),
//         );
//         _messageBuffer = dataString.substring(index);
//       });
//     } else {
//       _messageBuffer = (backspacesCounter > 0
//           ? _messageBuffer.substring(
//               0, _messageBuffer.length - backspacesCounter)
//           : _messageBuffer + dataString);
//     }
//   }
// }
