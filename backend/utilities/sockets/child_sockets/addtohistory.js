const { socket } = require("../../../sockets/socket");
const locDistance = require("../../loc_distance");
const { getCurrentDayLoc } = require("../../datesfetch");

function isSameDate(date1, date2) {
  const d1 = new Date(date1);
  const d2 = new Date(date2);

  return (
    d1.getFullYear() === d2.getFullYear() &&
    d1.getMonth() === d2.getMonth() &&
    d1.getDate() === d2.getDate()
  );
}

const getDateIndex = (list, date) => {
  for (var i = 0; i < list.length; i++) {
    if (isSameDate(list[i].date, date)) {
      return i;
    }
  }

  return -1;
};

const addToHistory = async (socket, paylode, loc, ch) => {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, "0"); // getMonth() is zero-based
  const day = String(now.getDate()).padStart(2, "0");
  const dateString = `${year}-${month}-${day}`; // e.g., "2024-07-11"

  // Create a Date object without time
  const dateOnly = new Date(dateString);
  const currentDate = dateOnly.toDateString();
  const index = getDateIndex(ch.history, currentDate);
  if (index == -1) {
    ch.history.push({
      date: currentDate,
      locations: [[loc]],
    });
  } else {
    let list = ch.history[index].locations;
    if (list.length == 0) ch.history[index].locations.push([loc]);
    else {
      if (list[list.length - 1].length == 0) {
        ch.history[index].locations[list.length - 1].push(loc);
      } else {
        let distance = locDistance(list[list.length - 1], loc);
        if (distance > 100) {
          ch.history[index].locations[list.length - 1].push(loc);
        }
      }
    }
  }
};

module.exports = addToHistory;
