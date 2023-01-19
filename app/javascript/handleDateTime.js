import { CONSTANTS } from './assets/constants';
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
      case CONSTANTS.THIRTY_MINUTES:
        this.dateTime.setTime(this.now.getTime() + 30 * 60 * 1000);
        break;
      case CONSTANTS.DONT_CLEAR:
        this.dontClear = true;
        break;
      case CONSTANTS.ONE_HOUR:
        this.dateTime.setTime(this.now.getTime() + 60 * 60 * 1000);
        break;
      case CONSTANTS.FOUR_HOURS:
        this.dateTime.setTime(this.now.getTime() + 4 * 60 * 60 * 1000);
        break;
      case CONSTANTS.THIS_WEEK:
        this.dateTime.setDate(this.now.getDate() + 7);
        break;
      case CONSTANTS.TODAY:
        this.dateTime.setTime(this.now.setHours(24, 0, 0, 0));
        break;
    }
    if (this.dontClear) {
      return CONSTANTS.DONT_CLEAR;
    }
    return this.dateTime;
  }

  secondsToHoursAndMinutes(totalSeconds) {
    if (totalSeconds == CONSTANTS.DONT_CLEAR)
      return '  ' + CONSTANTS.DONT_CLEAR;
    if (totalSeconds == CONSTANTS.TODAY) return '  ' + CONSTANTS.TODAY;
    totalSeconds = +totalSeconds + 60;
    let day = 86400;
    let hour = 3600;
    let minute = 60;
    let daysout = Math.floor(totalSeconds / day);
    let hoursout = Math.floor((totalSeconds - daysout * day) / hour);
    let minutesout = Math.floor(
      (totalSeconds - daysout * day - hoursout * hour) / minute
    );

    if (daysout == 7)
     return CONSTANTS.THIS_WEEK;
    else if (hoursout > 1)
      return hoursout + CONSTANTS.HOURS;
    else if (hoursout==1)
      return hoursout + CONSTANTS.HOUR;
    else
      return minutesout + CONSTANTS.MINUTES;
  }
  incremntTimeStampBySeconds(seconds) {
    this.now = new Date();
    this.dateTime = new Date(+this.now + seconds * 1000);
    return this.dateTime;
  }

  getEndOfDayTime() {
    return new Date(new Date().setHours(23, 59, 59, 999));
  }
}
