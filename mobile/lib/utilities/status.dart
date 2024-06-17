import 'dart:ui';

Color setBgColor(bool tracking, bool live, bool safe) {
  if (tracking) {
    if (live) {
      return safe
          ? Color.fromARGB(255, 107, 255, 112)
          : Color.fromARGB(255, 253, 116, 106);
    } else {
      return Color.fromARGB(255, 236, 125, 255);
    }
  } else {
    return Color.fromARGB(255, 191, 191, 191);
  }
}

String setStatus(bool tracking, bool live, bool safe) {
  if (tracking) {
    return live ? (safe ? "Safe" : "Off Route") : "Offline";
  } else {
    return "Not Tracking";
  }
}
