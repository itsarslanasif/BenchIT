export const convertUTCToLocal = (date) => {
  const months = [
    "January", "February", "March", "April", "May", "June",
    "July", "August", "September", "October", "November", "December"
  ];

  return {
    month: months[new Date(date).getUTCMonth()],
    day: new Date(date).getUTCDate(),
    year: new Date(date).getUTCFullYear()
  }
}