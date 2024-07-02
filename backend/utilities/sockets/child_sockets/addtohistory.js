const { socket } = require("../../../sockets/socket");
const locDistance = require("../../loc_distance");
function isSameDay(date1, date2) {
  const d1 = new Date(date1);
  const d2 = new Date(date2);

  const res =
    d1.getFullYear() === d2.getFullYear() &&
    d1.getMonth() === d2.getMonth() &&
    d1.getDate() === d2.getDate();

  return res;
}

const getCurrentDayLoc = (list, date) => {
  for (let i = 0; i < list.length; i++) {
    if (isSameDay(list[i].date, date)) return i;
  }
  return -1;
};

const addToHistory = async (socket, paylode, loc, ch) => {
  //console.log(ch.history);
  const date = Date.now();
  if (ch.history.length == 0) {
    ch.history.push({
      date: Date.now(),
      locations: [loc],
    });
  } else {
    const index = getCurrentDayLoc(ch.history, date);
    if (index == -1) {
      ch.history.push({
        date: Date.now(),
        locations: [loc],
      });
    } else {
      const currDay = ch.history[index];
      const lastLoc = currDay.locations[currDay.locations.length - 1];
      const distance = locDistance(lastLoc, loc);

      if (distance >= 100) {
        ch.history[index].locations.push(loc);
      }
    }
  }
};

module.exports = addToHistory;
