<template>
  <div>
    <div class="flex gap-3">
      <n-date-picker v-model:value="date" class="w-1/2" />
      <n-time-picker v-model:value="time" class="w-1/2" />
    </div>
    <div v-if="isError()" class="px-1 pt-3 text-danger">
      {{ $t('schedule.error') }}
    </div>
    <div class="w-full">
      <button @click="setCustom" :disabled="isDisabled"
        class="bg-success float-right text-white hover:bg-successHover px-4 py-1 my-3 rounded">
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
  props: {
    setSchedule: {
      type: Function
    },
    toggleCustomScheduleFlag: {
      type: Function
    }
  },
  data() {
    return {
      date: null,
      time: null,
      error: {
        date: false,
        time: false
      }
    };
  },
  computed: {
    isDisabled() {
      return this.error.date || this.error.time
    }
  },
  watch: {
    date() {
      const now = moment().format('YYYY-MM-DD')
      const date = moment(this.date).format('YYYY-MM-DD')
      this.error.date = date < now
    },
    time() {
      const now = moment().format('HH:mm:ss')
      const time = moment(this.time).format('HH:mm:ss')
      this.error.time = time < now
    },
  },
  methods: {
    setCustom() {
      const date = moment(this.date);
      const time = moment(this.time);
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
    isError() {
      return this.error.date || (this.error.date && this.error.time)
    }
  },
};
</script>
