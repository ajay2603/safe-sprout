import "package:flutter_background_service/flutter_background_service.dart";
import "package:socket_io_client/socket_io_client.dart" as IO;

void socketHandlers(IO.Socket? socket, ServiceInstance service) async {
  socket?.on("childInfo", (data) {
    service.invoke("updateChild", {"data": data});
  });

  socket?.on("upDateTracking", (data) {
    print("hello hello");
    print(data);
    service.invoke("upDateTracking", {"data": data});
  });
}
