<template>
  <DateAndTimePicker
    v-if="customScheduleFlag"
    :setSchedule="setSchedule"
    :toggleCustomScheduleFlag="toggleCustomScheduleFlag"
    class="w-1/2"
    v-bind:style="{
      position: 'fixed',
      top: '50%',
      left: '50%',
      transform: 'translate(-50%, -50%)',
    }"
  />
  <div
    class="bottom-0 right-0 w-1/6 py-3 text-left mb-10 absolute bg-primary text-white rounded-md h-auto"
  >
    <div class="px-5 py-1 text-black-400 text-xs">
      {{ $t('schedule.title') }}
    </div>
    <div
      class="px-5 py-1 hover:bg-primaryHover cursor-pointer"
      @click="scheduleTomorrow"
    >
      {{ $t('schedule.tomorrow') }}
    </div>
    <div
      class="px-5 py-1 hover:bg-primaryHover cursor-pointer"
      @click="scheduleNextWeek"
    >
      {{ $t('schedule.next_monday') }}
    </div>
    <hr class="my-2 border-black-400" />
    <div
      class="px-5 py-1 hover:bg-primaryHover cursor-pointer"
      @click="toggleCustomScheduleFlag"
    >
      {{ $t('schedule.custom_time') }}
    </div>
  </div>
</template>
<script>
import moment from 'moment';
import vClickOutside from 'click-outside-vue3';
import DateAndTimePicker from './DateAndTimePicker.vue';
export default {
  data() {
    return {
      customScheduleFlag: false,
    };
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  props: ['setSchedule', 'toggleSchedule'],
  components: {
    DateAndTimePicker,
  },
  methods: {
    scheduleTomorrow() {
      const date = moment();
      const tomorrow = date
        .startOf('day')
        .add(1, 'days')
        .set({ hour: 9, minute: 0, second: 0 });
      this.setSchedule(tomorrow.format('YYYY-MM-DD HH:mm:ss Z'));
    },
    scheduleNextWeek() {
      const date = moment();
      const nextMonday = date
        .day('Monday')
        .startOf('day')
        .set({ hour: 9, minute: 0, second: 0 });
      if (nextMonday.isBefore(moment())) {
        nextMonday.add(7, 'days');
      }
      this.setSchedule(nextMonday.format('YYYY-MM-DD HH:mm:ss Z'));
    },
    toggleCustomScheduleFlag() {
      this.customScheduleFlag = !this.customScheduleFlag;
    },
  },
};
</script>
