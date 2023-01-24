<template>
  <div class="m-3">
    <div
      v-for="message in scheduleMessage"
      class="w-full h-auto bg-slate-50 border border-black-400 p-3 rounded-lg hover:bg-black-200 duration-200"
    >
      <div class="flex justify-between">
        <div class="flex">
          <div>
            <n-avatar
              :size="50"
              class="rounded align-middle"
              :src="message.selectedChat.image_url"
            />
          </div>
          <div class="align-middle ml-3">
            <div class="text-base font-bold">
              {{ message.selectedChat.username }}
            </div>
            <div>
              {{ ignoreHTML(message.message) }}
            </div>
          </div>
        </div>
        <div class="">
          {{ getScheduleTime(message.schedule) }}
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
      return `Send on ${dateAndTime.format('MMMM DD, YYYY')} at ${dateAndTime.format('h:mm A')}`;;
    },
    ignoreHTML(message) {
      return message.replace(/<[^>]+>/g, '');
    },
  },
};
</script>
