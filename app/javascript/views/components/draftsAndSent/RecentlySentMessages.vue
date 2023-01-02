<template>
  <div class="scrollable bg-gray-100 mb-1">
    <div v-for="message in messages" :key="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
        <div
          v-if="isToday"
          class="text-xs text-black ml-10 text-xs font-bold m-4"
        >
          <p>Today</p>
        </div>
        <div v-else class="text-xs text-black ml-10 text-xs font-bold m-4">
          <p>{{ new Date(message.created_at).toDateString() }}</p>
        </div>
      </div>
      <div
        @click="handleClick(message)"
        class="ml-2 mr-2 bg-white border border-black-100 cursor-pointer flex p-4 hover:bg-gray-100 flex"
      >
        <div class="min-w-fit ml-1">
          <n-avatar
            class="mr-1 self-baseline"
            size="large"
            src="../../../assets/images/user.png"
          />
        </div>
        <div class="ml-3 leading-3">
          <div
            v-if="
              !message.is_threaded && message.conversationable_type == 'Profile'
            "
          >
            {{ message.receiver_name }}
          </div>
          <div
            v-else-if="
              !message.is_threaded &&
              message.conversationable_type == 'BenchChannel'
            "
          >
            {{ message.channel_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded &&
              message.conversationable_type == 'BenchChannel'
            "
          >
            Thread in {{ message.channel_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded && message.conversationable_type == 'Profile'
            "
          >
            Thread in {{ message.receiver_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded && message.conversationable_type == 'Group'
            "
          >
            Thread in Group {{ message.group_id }}
          </div>
          <div
            v-else-if="
              !message.is_threaded && message.conversationable_type == 'Group'
            "
          >
            Message in Group {{ message.group_id }}
          </div>
          <br />
          <span class="text-black-600">{{ message.content }}</span>
        </div>
        <div class="margin-left text-black-600">
          {{ time }}
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { getMessages } from '../../../api/recentlySent/recentlySentMessages';
import moment from 'moment';
import { NAvatar, NDivider } from 'naive-ui';
export default {
  components: {
    NAvatar,
    NDivider,
  },
  data() {
    return {
      messages: [],
      message: null,
      prevMessage: null,
    };
  },
  beforeUnmount() {
    this.messages = this.message = this.prevMessage = null;
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.message;
      this.message = message;
    },
    handleClick(message) {
      if (message.conversationable_type == 'BenchChannel') {
        this.$router.push(
          `/channels/${message.bench_conversation}/${message.id}`
        );
      } else if (message.conversationable_type == 'Profile') {
        this.$router.push(`/profiles/${message.receiver_id}/${message.id}`);
      } else if (message.conversationable_type == 'Group') {
        this.$router.push(`/groups/${message.group_id}/${message.id}`);
      }
    },
  },
  async mounted() {
    try {
      this.messages = await getMessages();
    } catch (e) {
      console.error(e);
    }
  },
  computed: {
    isToday() {
      return (
        new Date(this.message.created_at).toDateString() ===
        new Date().toDateString()
      );
    },
    time() {
      return moment(new Date(this.message.created_at).getTime()).format(
        'h:mm A'
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.message?.created_at).toDateString() ===
        new Date(this.prevMessage?.created_at).toDateString()
      );
    },
  },
};
</script>

<style scoped>
.scrollable {
  overflow-y: scroll;
  height: 85vh;
}
.margin-left {
  margin-left: auto;
}
</style>
