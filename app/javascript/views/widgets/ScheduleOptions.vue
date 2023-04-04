<template>
  <div
    class="py-3 px-4 flex gap-4 text-lg bg-white border border-black-400 rounded-md z-50"
  >
    <font-awesome-icon
      icon="fa-solid fa-pen"
      class="text-warning hover:text-warningHover"
      @click="editSchedule"
    />
    <font-awesome-icon
      icon="fa-solid fa-paper-plane"
      class="text-success hover:text-successHover"
      @click.stop="sendMessageNow"
    />
    <font-awesome-icon
      icon="fa-solid fa-file-pen"
      class="text-info hover:text-infoHover"
      @click.stop="toggleCustomScheduleFlag"
    />
    <font-awesome-icon
      icon="fa-solid fa-trash"
      class="text-danger hover:text-dangerHover"
      @click.stop="deleteScheduled"
    />
  </div>
</template>

<script>
import DateAndTimePicker from './DateAndTimePicker.vue';
import { NModal, NCard } from 'naive-ui';
import { useMessageStore } from '../../stores/useMessagesStore';
export default {
  props: {
    payload: {
      type: Object,
    },
    toggleRecheduleFlag: {
      type: Function,
    },
  },
  components: {
    DateAndTimePicker,
    NModal,
    NCard,
  },
  setup() {
    const messageStore = useMessageStore();
    return {
      messageStore,
    };
  },
  methods: {
    sendMessageNow() {
      this.messageStore.sendMessageNow(this.payload);
    },
    deleteScheduled() {
      this.messageStore.deleteScheduledMessage(this.payload);
    },
    toggleCustomScheduleFlag() {
      this.toggleRecheduleFlag(this.payload.id);
    },
    editSchedule() {
      this.messageStore.setEditSchedule(this.payload);
    },
  },
};
</script>
