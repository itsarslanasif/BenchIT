export class handleDateTime {
  constructor() {
    this.now = new Date();
    this.dateTime = new Date();
    this.dontClear = false;
  }
  convertStringToTimeStamp(time) {
    this.now = new Date();
    this.dateTime = new Date();
    switch (time) {
      case '30 minutes':
        this.dateTime.setTime(this.now.getTime() + 30 * 60 * 1000);
        break;
      case "Don't clear":
        this.dontClear = true
        break;
      case '1 hour':
        this.dateTime.setTime(this.now.getTime() + 60 * 60 * 1000);
        break;
      case '4 hours':
        this.dateTime.setTime(this.now.getTime() + 4 * 60 * 60 * 1000);
        break;
      case 'This Week':
        this.dateTime.setDate(this.now.getDate() + 7);
        break;
      case 'Today':
        this.dateTime.setTime(this.now.setHours(24, 0, 0, 0));
        break;
    }
    if (this.dontClear) {
      return "don't clear"
    }
    return this.dateTime
  }

  secondsToHoursAndMinutes(totalSeconds) {
    if (totalSeconds == "don't clear")
      return "  don't clear"
      if (totalSeconds == "based on your Google Calender")
      return "  based on your Google Calender"
    totalSeconds=+totalSeconds+60;
    var day = 86400;
    var hour = 3600;
    var minute = 60;
    var daysout = Math.floor(totalSeconds / day);
    var hoursout = Math.floor((totalSeconds - daysout * day) / hour);
    var minutesout = Math.floor((totalSeconds - daysout * day - hoursout * hour) / minute);

    if (daysout >= 1) {
      if (daysout == 7)
        return "This Week"
    } else if (hoursout >= 1)
      return  hoursout + " hours"
    else
      return minutesout + " minutes"
  }
  incremntTimeStampBySeconds(seconds) {
    this.now = new Date();
    this.dateTime = new Date(+this.now + seconds * 1000);
    return this.dateTime
  }

}
