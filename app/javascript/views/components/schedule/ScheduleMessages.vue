<template>
  <div class="m-3">
    <div v-for="payload in scheduleMessage" @mouseover="toggleOptionsFlag" @mouseleave="toggleOptionsFlag"
      @click="navigateToChat(payload)"
      class="w-full h-auto my-3 bg-slate-50 border border-black-400 p-3 rounded-lg hover:bg-black-200 duration-200">
      <ScheduleWrapper :payload="payload" />
    </div>
  </div>
</template>
<script>
import { storeToRefs } from 'pinia';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NAvatar } from 'naive-ui';
import moment from 'moment';
import ScheduleWrapper from '../../widgets/ScheduleWrapper.vue';
export default {
  components: {
    NAvatar,
    ScheduleWrapper
  },
  setup() {
    const messageStore = useMessageStore();
    const { scheduleMessage } = storeToRefs(messageStore);
    return {
      scheduleMessage,
    };
  },
  methods: {
    navigateToChat(payload) {
      let type = ''
      if (payload.conversation_type === 'BenchChannel') {
        type = 'channel'
      } else {
        type = payload.conversation_type
      }
      this.$router.push(`/${type.toLowerCase()}s/${payload.receiver.id}`)
    }
  },
};
</script>
