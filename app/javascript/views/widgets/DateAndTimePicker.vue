<template>
  <div
    class="bg-slate-50 p-10 border rounded"
    v-click-outside="toggleCustomScheduleFlag"
  >
    <div class="my-2 text-base">
      {{ $t('schedule.custom_time') }}
    </div>
    <div class="flex gap-3">
      <n-date-picker v-model:value="dateTimestamp" />
      <n-time-picker v-model:value="timeTimestamp" />
    </div>
    <div class="w-full">
      <button
        @click="setCustom"
        class="bg-success right-0 text-white hover:bg-successHover px-4 py-1 my-3 rounded mr-auto"
      >
        {{ $t('actions.go') }}
      </button>
    </div>
  </div>
</template>
<script>
import moment from 'moment';
import { NDatePicker, NTimePicker } from 'naive-ui';
import vClickOutside from 'click-outside-vue3';
export default {
  components: {
    NDatePicker,
    NTimePicker,
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  props: ['setSchedule', 'toggleCustomScheduleFlag'],
  data() {
    return {
      dateTimestamp: null,
      timeTimestamp: null,
    };
  },
  methods: {
    setCustom() {
      const date = moment(this.dateTimestamp);
      const time = moment(this.timeTimestamp);
      let dateTime = moment();
      dateTime.set({
        year: date.year(),
        month: date.month(),
        date: date.date(),
        hour: time.hour(),
        minute: time.minute(),
        second: time.second(),
      });
      this.setSchedule(dateTime.format('YYYY-MM-DD HH:mm:ss Z'));
    },
  },
};
</script>
<style lang=""></style>
