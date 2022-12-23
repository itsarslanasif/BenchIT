<template>
  <div
    class="z-10 w-full border text-white drop-shadow-2xl bg-primary py-3 rounded-md text-sm font-normal"
  >
    <p class="text-xs toDays py-1">
      {{ $t('messages_section.jump_to') }}
    </p>
    <div
      v-if="!this.today"
      class="toDays hover:bg-primaryHover"
      @click="setOption(1)"
    >
      {{ $t('messages_section.today') }}
    </div>
    <div class="toDays hover:bg-primaryHover" @click="setOption(2)">
      {{ $t('messages_section.yesterday') }}
    </div>
    <div class="toDays hover:bg-primaryHover" @click="setOption(3)">
      {{ $t('messages_section.last_week') }}
    </div>
    <div class="toDays hover:bg-primaryHover" @click="setOption(4)">
      {{ $t('messages_section.last_month') }}
    </div>
    <div class="toDays hover:bg-primaryHover" @click="setOption(5)">
      {{ $t('messages_section.the_very_beginning') }}
    </div>
    <hr class="border-primaryHover my-2" />
    <div class="toDays hover:bg-primaryHover" @click="setOption(6)">
      {{ $t('messages_section.jump_to_specific_date') }}
    </div>
  </div>
  <n-modal v-model:show="openCalenderModal">
    <n-card
      style="width: 600px"
      :title="$t('messages_section.jump_to_specific_date')"
      :bordered="false"
      size="huge"
      role="dialog"
      aria-modal="true"
    >
      <n-date-picker v-model:value="timestamp" />
      <n-button class="mt-2 float-right px-10" @click="goToDate">
        {{ $t('actions.go') }}
      </n-button>
    </n-card>
  </n-modal>
</template>
<script>
import { NModal, NCard, NDatePicker, NButton } from 'naive-ui';
export default {
  components: { NModal, NCard, NDatePicker, NButton },
  props: ['scrollToMessageByDate', 'today'],
  data() {
    return {
      openCalenderModal: false,
      timestamp: null,
    };
  },
  methods: {
    selectedDate(date) {
      console.log(date);
    },
    setOption(type) {
      const date = new Date();
      switch (type) {
        case 1:
          this.scrollToMessageByDate(date);
          break;
        case 2:
          const yesterday = new Date(
            date.getFullYear(),
            date.getMonth(),
            date.getDate() - 1
          );
          this.scrollToMessageByDate(yesterday);
          break;
        case 3:
          const last_week = new Date(
            date.getFullYear(),
            date.getMonth(),
            date.getDate() - 7
          );
          this.scrollToMessageByDate(last_week);
          break;
        case 4:
          const last_month = new Date(date.getFullYear(), date.getMonth() - 1);
          this.scrollToMessageByDate(last_month);
          break;
        case 5:
          this.scrollToMessageByDate('beginning_of_chat');
          break;
        case 6:
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
  },
};
</script>
<style>
.toDays {
  @apply px-5;
}
</style>
