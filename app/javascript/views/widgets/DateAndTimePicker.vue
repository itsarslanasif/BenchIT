<template>
  <div>
    <div class="flex gap-3">
      <n-date-picker v-model:value="dateTimestamp" class="w-1/2" />
      <n-time-picker v-model:value="timeTimestamp" class="w-1/2" />
    </div>
    <div class="w-full">
      <button
        @click="setCustom"
        class="bg-success float-right text-white hover:bg-successHover px-4 py-1 my-3 rounded"
      >
        {{ $t('actions.go') }}
      </button>
    </div>
  </div>
</template>
<script>
import moment from 'moment';
import { NDatePicker, NTimePicker, NModal, NCard } from 'naive-ui';
export default {
  components: {
    NDatePicker,
    NTimePicker,
    NModal,
    NCard,
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
