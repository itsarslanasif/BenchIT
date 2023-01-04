import moment from 'moment'

export class handleDateTime {
  constructor() {}
  convertToTimeStamp(time) {

    switch (time) {
      case '30 minutes':
        console.log("30 minutes:", 1)
        break;
      case '1 hour':
        console.log("1 hour:", 2)
        break;
      case '4 hours':
        console.log("4 hours:", 3)
        break;
      case 'This Week':
        console.log("This Week:", 4)
        break;
      case 'Today':
        console.log("Today", 5)
        break;
        default:
        console.log("Custom:", 5)
    }
  }

}
