import 'dart:io';

import "package:socket_io_client/socket_io_client.dart" as IO;
import '../global/consts.dart';
import '../utilities/secure_storage.dart';

IO.Socket? socket;

void socketInit() async {
  print("init sockte");

  String token = await getKey('token') ?? "";

  socket = IO.io(serverURL, {
    'transports': ['websocket'],
    'extraHeaders': {'Authorization': token},
  });

  socket?.on("event", (_) {
    print(_);
  });

  socket?.onConnect((data) {
    print("socket connected 1");
  });

  socket?.onDisconnect((data) {
    print("socket disconnected 1");
  });
}

IO.Socket? getSocket() {
  return socket;
}

void reconnect() async {
  socket?.connect();
}

void disconnectSocket() {
  socket?.disconnect();
}
