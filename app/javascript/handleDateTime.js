export class handleDateTime {
  constructor() {
    this.now=new Date();
    this.dateTime = new Date();
    this.dontClear=false;
  }
  convertStringToTimeStamp(time) {
    this.now = new Date();
    this.dateTime = new Date();
    switch (time) {
      case '30 minutes':
        this.dateTime.setTime(this.now.getTime() + 30 * 60 * 1000);
        break;
      case "Don't clear":
        this.dontClear=true
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
    if( this.dontClear){
      console.log("Don't Clear")
      return "Don't Clear"
    }
    console.log( this.dateTime)
    return  this.dateTime
  }

  secondsToHoursAndMinutes(totalSeconds) {
    const totalMinutes = Math.floor(totalSeconds / 60);
    const hours = Math.floor(totalMinutes / 60);
    const minutes = totalMinutes % 60;
    if (hours > 1) {
      return "- " + hours + " hours"
    } else if (hours == 1) {
      return "- " + hours + " hour"
    } else {
      return "- " + minutes + " minutes"
    }
  }
  incremntTimeStampBySeconds(seconds){
    this.now = new Date();
    this.dateTime=new Date(+this.now + seconds * 1000);
    return this.dateTime
  }
}
