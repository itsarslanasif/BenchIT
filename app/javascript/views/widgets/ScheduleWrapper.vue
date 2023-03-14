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
          v-if="isProfileMessage"
          class="rounded align-middle w-12 h-12"
          :src="payload.receiver.image_url"
        />
        <div
          v-if="isChannelMessage"
          class="w-12 h-12 bg-secondaryHover rounded flex justify-center items-center text-xl"
        >
          <font-awesome-icon :icon="getIcon" />
        </div>
        <div
          v-if="isGroupMessage"
          class="w-12 h-12 bg-secondaryHover rounded flex justify-center items-center text-xl"
        >
          <p>G</p>
        </div>
      </div>
      <div class="align-middle ml-3">
        <div class="text-base font-semibold">
          {{ getChatName }}
        </div>
        <div>
          <div
            v-for="block in messageBlock(payload.content).blocks"
            :key="block.id"
          >
            <MessageSection v-if="block.type === 'section'" :section="block" />
          </div>
        </div>
      </div>
    </div>
    <div class="text-xs">
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
  computed: {
    getChatName() {
      if (this.isProfileMessage) {
        return this.payload.receiver.username;
      } else if (this.isChannelMessage) {
        return this.payload.receiver.name;
      } else {
        return this.payload.group_name;
      }
    },
    getIcon() {
      return `fa-${this.payload.is_private ? 'lock' : 'hashtag'}`;
    },
    isProfileMessage() {
      return this.payload.conversation_type === 'Profile';
    },
    isChannelMessage() {
      return this.payload.conversation_type === 'BenchChannel';
    },
    isGroupMessage() {
      return this.payload.conversation_type === 'Group';
    },
  },
  methods: {
    ignoreHTML(message) {
      return message.replace(/<[^>]+>/g, '');
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
