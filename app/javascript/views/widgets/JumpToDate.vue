<template>
  <div>
    <n-dropdown
      class="rounded-md border border-slate-100 w-100"
      placement="bottom-start"
      size="medium"
      :show="toggleShow"
      :options="options"
      @select="handleSelect($event)"
      :on-clickoutside="openCalenderModal ? null : toggleShow"
    >
      <p />
    </n-dropdown>
    <n-modal v-model:show="openCalenderModal">
      <n-card
        class="flex justify-center items-center w-100"
        :title="$t('messages_section.jump_to_specific_date')"
        role="dialog"
        aria-modal="true"
      >
        <n-date-picker panel type="date" v-model:value="timestamp" />
        <n-button class="mt-2 px-10 focus:outline-none" @click="goToDate">
          {{ $t('actions.go') }}
        </n-button>
      </n-card>
    </n-modal>
  </div>
</template>
<script>
import { NModal, NCard, NDatePicker, NButton, NDropdown } from 'naive-ui';
import { CONSTANTS } from '../../assets/constants';
export default {
  components: { NModal, NCard, NDatePicker, NButton, NDropdown },
  props: ['scrollToMessageByDate', 'today', 'toggleShow'],
  data() {
    return {
      openCalenderModal: false,
      timestamp: null,
      options: [
        {
          label: CONSTANTS.JUMP_TO,
          key: this.generateKey(CONSTANTS.JUMP_TO),
          disabled: true,
        },
        {
          label: CONSTANTS.TODAY,
          key: this.generateKey(CONSTANTS.TODAY),
          show: !this.today,
        },
        {
          label: CONSTANTS.YESTERDAY,
          key: this.generateKey(CONSTANTS.YESTERDAY),
        },
        {
          label: CONSTANTS.LAST_WEEK,
          key: this.generateKey(CONSTANTS.LAST_WEEK),
        },
        {
          label: CONSTANTS.LAST_MONTH,
          key: this.generateKey(CONSTANTS.LAST_MONTH),
        },
        {
          label: CONSTANTS.THE_VERY_BEGINNING,
          key: this.generateKey(CONSTANTS.THE_VERY_BEGINNING),
        },
        {
          label: CONSTANTS.JUMP_TO_SPECIFIC_DATE,
          key: this.generateKey(CONSTANTS.JUMP_TO_SPECIFIC_DATE),
        },
      ],
    };
  },
  beforeUnmount() {
    this.timestamp = null;
    this.openCalenderModal = false;
  },
  methods: {
    handleSelect(key) {
      const date = new Date();
      switch (key) {
        case this.generateKey(CONSTANTS.TODAY):
          this.scrollToMessageByDate(date);
          break;
        case this.generateKey(CONSTANTS.YESTERDAY):
          const yesterday = new Date(
            date.getFullYear(),
            date.getMonth(),
            date.getDate() - 1
          );
          this.scrollToMessageByDate(yesterday);
          break;
        case this.generateKey(CONSTANTS.LAST_WEEK):
          const last_week = new Date(
            date.getFullYear(),
            date.getMonth(),
            date.getDate() - 7
          );
          this.scrollToMessageByDate(last_week);
          break;
        case this.generateKey(CONSTANTS.LAST_MONTH):
          const last_month = new Date(date.getFullYear(), date.getMonth() - 1);
          console.log(last_month)
          this.scrollToMessageByDate(last_month);
          break;
        case this.generateKey(CONSTANTS.THE_VERY_BEGINNING):
          this.scrollToMessageByDate('beginning_of_chat');
          break;
        case this.generateKey(CONSTANTS.JUMP_TO_SPECIFIC_DATE):
          this.openCalenderModal = !this.openCalenderModal;
          break;
        default:
          break;
      }
    },
    goToDate() {
      const date = new Date(this.timestamp);
      this.scrollToMessageByDate(date);
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
