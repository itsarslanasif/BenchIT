<template>
  <n-modal v-model:show="customScheduleFlag">
    <n-card
      class="w-2/6"
      :title="$t('schedule.custom_time')"
      :bordered="false"
      size="huge"
      role="dialog"
      aria-modal="true"
    >
      <DateAndTimePicker
        :setSchedule="setSchedule"
        :toggleCustomScheduleFlag="toggleCustomScheduleFlag"
      />
    </n-card>
  </n-modal>
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
import { NModal, NCard } from 'naive-ui';
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
    NModal,
    NCard,
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
