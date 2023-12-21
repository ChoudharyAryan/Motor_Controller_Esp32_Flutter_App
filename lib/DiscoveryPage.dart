// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
// import 'package:motor_controller_esp32/GenericSnackBar.dart';

// import './BluetoothDeviceListEntry.dart';

// class DiscoveryPage extends StatefulWidget {
//   /// If true, discovery starts on page start, otherwise user must press action button.
//   final bool start;

//   const DiscoveryPage({super.key, this.start = true});

//   @override
//   _DiscoveryPage createState() => _DiscoveryPage();
// }

// class _DiscoveryPage extends State<DiscoveryPage> {


//   @override
//   void initState() {
//     super.initState();

//     isDiscovering = widget.start;
//     if (isDiscovering) {
//       _startDiscovery();
//     }
//   }

  

  

//   // @TODO . One day there should be `_pairDevice` on long tap on something... ;)

//   @override
//   void dispose() {
//     // Avoid memory leak (`setState` after dispose) and cancel discovery
    

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: isDiscovering
//             ? const Text('Discovering devices')
//             : const Text('Discovered devices'),
//         actions: <Widget>[
//           isDiscovering
//               ? 
//         ],
//       ),
//       body: 
//     );
//   }
// }
