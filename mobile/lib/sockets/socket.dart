import "package:socket_io_client/socket_io_client.dart" as IO;
import '../global/consts.dart';
import '../utilities/secure_storage.dart';

IO.Socket? socket;

void socketInit() async {
  print("init sockte");
  socket = IO.io(serverURL, {
    'transports': ['websocket'],
    'extraHeaders': {'Authorization': getKey('token')},
  });

  socket?.onConnect((data) {
    print("socket connected 1");
  });

  socket?.onDisconnect((data) {
    print("socket disconnected 1");
  });
}
