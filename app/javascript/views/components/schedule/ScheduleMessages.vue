<template>
  <div class="m-3">
    <div
      v-for="payload in scheduleMessage"
      @click="navigateToChat(payload)"
      class="w-full h-auto my-3 bg-slate-50 border border-black-400 p-3 rounded-lg hover:bg-black-200 duration-200"
    >
      <div class="flex justify-between">
        <div class="flex">
          <div>
            <n-avatar
              v-if="payload.conversation_type === 'Profile'"
              class="rounded align-middle w-12 h-12"
              :src="payload.receiver.image_url"
            />
            <div
              v-if="payload.conversation_type === 'BenchChannel'"
              class="w-12 h-12 bg-slate-100 rounded flex justify-center items-center text-xl"
            >
              <font-awesome-icon :icon="getIcon(payload.receiver)" />
            </div>
          </div>
          <div class="align-middle ml-3">
            <div class="text-base font-bold">
              {{ getChatName(payload.receiver) }}
            </div>
            <div>
              {{ ignoreHTML(payload.content) }}
            </div>
          </div>
        </div>
        <div class="">
          {{ getScheduleTime(payload.scheduled_at) }}
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { storeToRefs } from 'pinia';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NAvatar } from 'naive-ui';
import moment from 'moment';
export default {
  components: {
    NAvatar,
  },
  setup() {
    const messageStore = useMessageStore();
    const { scheduleMessage } = storeToRefs(messageStore);
    return {
      scheduleMessage,
    };
  },
  methods: {
    getScheduleTime(time) {
      const dateAndTime = moment(time);
      return `Send on ${dateAndTime.format(
        'MMMM DD, YYYY'
      )} at ${dateAndTime.format('h:mm A')}`;
    },
    ignoreHTML(message) {
      return message.replace(/<[^>]+>/g, '');
    },
    getChatName(payload) {
      return payload.user_id ? payload.username : payload.name;
    },
    getIcon(payload) {
      return `fa-${payload.is_private ? 'lock' : 'hashtag'}`
    },
    navigateToChat(payload) {
      let type = ''
      if (payload.conversation_type === 'BenchChannel'){
        type = 'channel'
      } else {
        type = payload.conversation_type
      }
      this.$router.push(`/${type.toLowerCase()}s/${payload.receiver.id}`)
    }
  },
};
</script>
