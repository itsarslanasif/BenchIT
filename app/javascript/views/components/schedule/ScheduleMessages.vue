<template>
  <div class="m-3">
    <n-modal v-model:show="scheduleFlag">
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
      v-if="!scheduleMessage.length"
      class="flex flex-col justify-center text-center items-center mt-10"
    >
      <font-awesome-icon
        icon="fa-solid fa-clock-rotate-left"
        class="text-2xl mb-2"
      />
      <p class="font-bold text-base text-center">
        {{ $t('schedule.title') }}
      </p>
      <p class="text-base text-center">
        {{ $t('schedule.description') }}
      </p>
    </div>
    <div v-else>
      <div
        v-for="payload in scheduleMessage"
        @mouseover="toggleOptionsFlag"
        @mouseleave="toggleOptionsFlag"
        @click="navigateToChat(payload)"
        class="w-full h-auto my-3 bg-slate-50 border border-black-400 p-3 rounded-lg hover:bg-black-200 duration-200"
      >
        <ScheduleWrapper
          :payload="payload"
          :toggleRecheduleFlag="toggleRecheduleFlag"
        />
      </div>
    </div>
  </div>
</template>
<script>
import { storeToRefs } from 'pinia';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NAvatar, NModal, NCard } from 'naive-ui';
import ScheduleWrapper from '../../widgets/ScheduleWrapper.vue';
import DateAndTimePicker from '../../widgets/DateAndTimePicker.vue';
export default {
  components: {
    NAvatar,
    NModal,
    NCard,
    ScheduleWrapper,
    DateAndTimePicker,
  },
  data() {
    return {
      scheduleFlag: false,
      payloadId: null,
    };
  },
  setup() {
    const messageStore = useMessageStore();
    const { scheduleMessage } = storeToRefs(messageStore);
    messageStore.getAllScheduleMessages();
    return {
      scheduleMessage,
      messageStore,
    };
  },
  methods: {
    navigateToChat(payload) {
      const type =
        payload.conversation_type === this.$t('conversation_type.channel')
          ? 'channel'
          : payload.conversation_type;
      this.$router.push(`/${type.toLowerCase()}s/${payload.receiver.id}`);
    },
    toggleRecheduleFlag(id) {
      this.payloadId = id;
      this.scheduleFlag = !this.scheduleFlag;
    },
    setSchedule(value) {
      this.messageStore.reScheduleMessage({
        id: this.payloadId,
        scheduled_at: value,
      });
      this.scheduleFlag = !this.scheduleFlag;
    },
  },
};
</script>
