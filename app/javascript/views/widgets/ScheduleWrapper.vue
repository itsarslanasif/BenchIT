<template>
  <div
    class="flex justify-between relative"
    @mouseover="toggleOptionsOn"
    @mouseleave="toggleOptionsOff"
  >
    <div v-if="optionsFlag" class="right-0 absolute">
      <ScheduleOptions
        :payload="payload"
        :toggleRecheduleFlag="toggleRecheduleFlag"
      />
    </div>
    <div class="flex">
      <div>
        <n-avatar
          v-if="payload.conversation_type === $t('conversation_type.profile')"
          class="rounded align-middle w-12 h-12"
          :src="payload.receiver.image_url"
        />
        <div
          v-if="payload.conversation_type === $t('conversation_type.channel')"
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
          <div v-for="block in messageBlock(payload.content).blocks">
            <MessageSection v-if="block.type === 'section'" :section="block" />
          </div>
        </div>
      </div>
    </div>
    <div class="">
      {{ getScheduleTime(payload.scheduled_at) }}
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import ScheduleOptions from './ScheduleOptions.vue';
import MessageSection from '../components/messages/MessageSection.vue';
import { NAvatar, NModal, NCard } from 'naive-ui';
export default {
  components: {
    NAvatar,
    ScheduleOptions,
    NModal,
    NCard,
    MessageSection,
  },
  data() {
    return {
      optionsFlag: false,
    };
  },
  props: {
    payload: {
      type: Object,
    },
    toggleRecheduleFlag: {
      type: Function,
    },
  },
  methods: {
    ignoreHTML(message) {
      return message.replace(/<[^>]+>/g, '');
    },
    getChatName(payload) {
      return payload.user_id ? payload.username : payload.name;
    },
    getIcon(payload) {
      return `fa-${payload.is_private ? 'lock' : 'hashtag'}`;
    },
    getScheduleTime(time) {
      const dateAndTime = moment(time);
      return `Send on ${dateAndTime.format(
        'MMMM DD, YYYY'
      )} at ${dateAndTime.format('h:mm A')}`;
    },
    toggleOptionsOn() {
      this.optionsFlag = true;
    },
    toggleOptionsOff() {
      this.optionsFlag = false;
    },
    messageBlock(message) {
      return JSON.parse(message);
    },
  },
};
</script>
