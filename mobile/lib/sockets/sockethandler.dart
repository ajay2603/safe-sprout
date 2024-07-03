import "package:flutter_background_service/flutter_background_service.dart";
import "package:socket_io_client/socket_io_client.dart" as IO;

void socketHandlers(IO.Socket? socket, ServiceInstance service) async {
  socket?.on("childInfo", (data) {
    print("1111");
    service.invoke("updateChild", {"data": data});
  });
}
