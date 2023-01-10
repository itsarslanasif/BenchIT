import moment from "moment";

export const convertUTCToLocal = (date) => {
  const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];
  const dateInUTC = moment(new Date(date));
  return `${months[dateInUTC.month()]} ${dateInUTC.date()}, ${dateInUTC.year()}`;
}
