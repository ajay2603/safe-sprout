import "package:socket_io_client/socket_io_client.dart" as IO;


void socketHandlers(IO.Socket? socket) async {

  
  socket?.on("childInfo", (data) {
    print(data);
  });
}
