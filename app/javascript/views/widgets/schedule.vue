<template>
  <n-dropdown
    class="rounded-md border border-slate-100 w-48"
    placement="top-end"
    size="medium"
    :show="true"
    :options="options"
    @select="handleSelect($event)"
  >
    <p />
  </n-dropdown>
  <n-modal v-model:show="customScheduleFlag">
    <n-card
      class="flex justify-center w-100"
      :title="$t('schedule.schedule_message')"
      role="dialog"
    >
      <n-date-picker
        type="datetime"
        :default-value="Date.now()"
        :is-date-disabled="dateDisabled"
        v-model:value="customTime"
      />
      <span class="flex justify-end gap-1">
        <button
          class="mt-4 px-3 py-1 border border-black-600 flex items-center font-semibold rounded focus:outline-none"
          @click="toggleCustomScheduleFlag"
        >
          Cancel
        </button>
        <button
          class="mt-4 px-3 py-1 border border-black-600 flex items-center bg-success text-white font-semibold rounded focus:outline-none"
          @click="setCustomTime"
        >
          {{ $t('schedule.schedule_message') }}
        </button>
      </span>
    </n-card>
  </n-modal>
</template>
<script>
import moment from 'moment';
import { NModal, NCard, NDropdown, NDatePicker } from 'naive-ui';
import { CONSTANTS } from '../../assets/constants';
export default {
  props: {
    setSchedule: {
      type: Function,
    },
    toggleShow: {
      type: Function,
    },
  },
  data() {
    return {
      customTime: null,
      customScheduleFlag: false,
      options: [
        {
          label: CONSTANTS.SCHEDULE_MESSAGE,
          key: this.generateKey(CONSTANTS.SCHEDULE_MESSAGE),
          disabled: true,
        },
        {
          label: CONSTANTS.TOMORROW,
          key: this.generateKey(CONSTANTS.TOMORROW),
        },
        {
          label: CONSTANTS.NEXT_MONDAY,
          key: this.generateKey(CONSTANTS.NEXT_MONDAY),
        },
        {
          type: 'divider',
          key: this.generateKey('divider'),
        },
        {
          label: CONSTANTS.CUSTOM_TIME,
          key: this.generateKey(CONSTANTS.CUSTOM_TIME),
        },
      ],
    };
  },
  components: {
    DateAndTimePicker,
    NModal,
    NCard,
    NDropdown,
    NDatePicker,
  },
  methods: {
    handleSelect(key) {
      switch (key) {
        case this.generateKey('Tommorow'):
          this.scheduleTomorrow();
          break;
        case this.generateKey('Next Monday'):
          this.scheduleNextWeek();
          break;
        case this.generateKey('Custom time'):
          this.toggleCustomScheduleFlag();
          break;
        default:
          break;
      }
    },
    dateDisabled(ts) {
      const now = new Date(moment()).getDate();
      const selected = new Date(ts).getDate();
      return selected < now;
    },
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
    setCustomTime() {
      if (this.customTime) {
        let dateTime = moment(this.customTime);
        if (dateTime) {
          this.setSchedule(dateTime.format('YYYY-MM-DD HH:mm:ss Z'));
        }
      }
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
