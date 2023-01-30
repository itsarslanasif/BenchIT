<template>
  <div class="flex justify-between relative" @mouseover="toggleOptionsOn" @mouseleave="toggleOptionsOff">
    <div v-if="optionsFlag" class="right-0 absolute">
      <ScheduleOptions :payload="payload" />
    </div>
    <div class="flex">
      <div>
        <n-avatar v-if="payload.conversation_type === 'Profile'" class="rounded align-middle w-12 h-12"
          :src="payload.receiver.image_url" />
        <div v-if="payload.conversation_type === 'BenchChannel'"
          class="w-12 h-12 bg-slate-100 rounded flex justify-center items-center text-xl">
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

</template>

<script>
import moment from 'moment';
import ScheduleOptions from './ScheduleOptions.vue'
import { NAvatar } from 'naive-ui';
export default {
  components: {
    NAvatar,
    ScheduleOptions
  },
  data() {
    return {
      optionsFlag: false
    }
  },
  props: ['payload'],
  methods: {
    ignoreHTML(message) {
      return message.replace(/<[^>]+>/g, '');
    },
    getChatName(payload) {
      return payload.profile_id ? payload.username : payload.name;
    },
    getIcon(payload) {
      return `fa-${payload.is_private ? 'lock' : 'hashtag'}`
    },
    getScheduleTime(time) {
      const dateAndTime = moment(time);
      return `Send on ${dateAndTime.format(
        'MMMM DD, YYYY'
      )} at ${dateAndTime.format('h:mm A')}`;
    },
    toggleOptionsOn() {
      this.optionsFlag = true
    },
    toggleOptionsOff() {
      this.optionsFlag = false
    }
  }
}
</script>
