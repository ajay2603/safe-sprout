import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:mobile/sockets/sockethandler.dart';
import "package:socket_io_client/socket_io_client.dart" as IO;
import '../global/consts.dart';
import '../utilities/secure_storage.dart';

IO.Socket? socket;

void socketInit(ServiceInstance service) async {
  print("init sockte");

  String token = await getKey('token') ?? "";

  socket = IO.io(serverURL, {
    'transports': ['websocket'],
    'extraHeaders': {'Authorization': token},
  });

  socket?.on("event", (_) {
    service.invoke("demo", {"data": _});
  });

  if (await getKey("type") == "parent") socketHandlers(socket, service);

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
