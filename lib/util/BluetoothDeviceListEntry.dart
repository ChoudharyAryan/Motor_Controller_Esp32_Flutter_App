import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class BluetoothDeviceListEntry extends ListTile {
  BluetoothDeviceListEntry({
    super.key,
    required BluetoothDevice device,
    required rssi,
    required GestureTapCallback onTap,
    bool enabled = true,
  }) : super(
          onTap: onTap,
          enabled: enabled,
          leading: const Icon(Icons.devices),
          // @TODO . !BluetoothClass! class aware icon
          title: Text(device.name ?? "Unknown device"),
          // subtitle: Text(device.address.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              rssi != null
                  ? Container(
                      margin: const EdgeInsets.all(8.0),
                      child: DefaultTextStyle(
                        style: _computeTextStyle(rssi),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(rssi.toString()),
                            const Text('dBm'),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox(width: 0, height: 0),
              device.isConnected
                  ? const Icon(Icons.import_export)
                  : const SizedBox(width: 0, height: 0),
              device.isBonded
                  ? const Icon(Icons.link)
                  : const SizedBox(width: 0, height: 0),
            ],
          ),
        );

  static TextStyle _computeTextStyle(int rssi) {
    /**/ if (rssi >= -35) {
      return TextStyle(color: Colors.grey[600]);
    } else if (rssi >= -45)
      // ignore: curly_braces_in_flow_control_structures
      return TextStyle(
          color: Color.lerp(
              Colors.grey[600], Colors.grey[600], -(rssi + 35) / 10));
    else if (rssi >= -55)
      // ignore: curly_braces_in_flow_control_structures
      return TextStyle(
          color: Color.lerp(
              Colors.grey[600], Colors.grey[600], -(rssi + 45) / 10));
    else if (rssi >= -65)
      // ignore: curly_braces_in_flow_control_structures
      return TextStyle(
          color: Color.lerp(
              Colors.grey[600], Colors.grey[600], -(rssi + 55) / 10));
    else if (rssi >= -75)
      // ignore: curly_braces_in_flow_control_structures
      return TextStyle(
          color: Color.lerp(
              Colors.grey[600], Colors.grey[600], -(rssi + 65) / 10));
    else if (rssi >= -85)
      // ignore: curly_braces_in_flow_control_structures
      return TextStyle(
          color: Color.lerp(
              Colors.grey[600], Colors.grey[600], -(rssi + 75) / 10));
    else
      /*code symetry*/
      // ignore: curly_braces_in_flow_control_structures
      return const TextStyle(color: Colors.redAccent);
  }
}
