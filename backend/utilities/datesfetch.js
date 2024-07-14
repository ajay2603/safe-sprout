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

module.exports = { isSameDay, getCurrentDayLoc };
