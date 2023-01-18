<template>
  <div class="scrollable bg-gray-100 mb-1">
    <div v-for="message in messages" :key="message.id">
      {{ setMessage(message) }}
      <div v-if="!isSameDayMessage">
        <div v-if="isToday" class="text-xs text-black ml-10 font-bold m-4">
          <p>{{ $t('messages_section.today') }}</p>
        </div>
        <div v-else class="text-xs text-black ml-10 font-bold m-4">
          <p>{{ new Date(message.created_at).toDateString() }}</p>
        </div>
      </div>
      <div
        @click="handleClick(message)"
        class="ml-2 mr-2 bg-white border border-black-100 cursor-pointer flex p-4 hover:bg-gray-100"
      >
        <div class="min-w-fit ml-1">
          <div v-if="message.conversationable_type === 'Profile'">
            <img :src="getImageSrc(message)" class="w-10 rounded" />
          </div>
          <div
            class="bg-slate-100 w-10 h-10 rounded flex items-center justify-center text-base"
            v-else
          >
            <div
              v-if="
                message.conversationable_type === $t('conversation.channel')
              "
            >
              <font-awesome-icon :icon="getIcon(message)" />
            </div>
            <div v-else>
              <font-awesome-icon icon="fa-user-group" />
            </div>
          </div>
        </div>
        <div class="ml-3 leading-3">
          <div
            v-if="
              !message.is_threaded &&
              message.conversationable_type == $t('conversation.profile')
            "
          >
            {{ message.receiver_name }}
          </div>
          <div
            v-else-if="
              !message.is_threaded &&
              message.conversationable_type == $t('conversation.channel')
            "
          >
            {{ message.channel_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded &&
              message.conversationable_type == $t('conversation.channel')
            "
          >
            {{ $t('heading.thread_in') }} {{ message.channel_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded &&
              message.conversationable_type == $t('conversation.profile')
            "
          >
            {{ $t('heading.thread_in') }} {{ message.receiver_name }}
          </div>
          <div
            v-else-if="
              message.is_threaded &&
              message.conversationable_type == $t('conversation.group')
            "
          >
            {{ $t('heading.thread_in_group') }} {{ message.group_id }}
          </div>
          <div
            v-else-if="
              !message.is_threaded &&
              message.conversationable_type == $t('conversation.group')
            "
          >
            {{ $t('heading.message_in_group') }} {{ message.group_id }}
          </div>
          <br />
          <span class="text-black-600" v-html="message.content"></span>
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
import { useProfileStore } from '../../../stores/useProfileStore';
import { storeToRefs } from 'pinia';
import { useChannelStore } from '../../../stores/useChannelStore';
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
  setup() {
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    return {
      profiles,
      channels,
    };
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.message;
      this.message = message;
    },
    handleClick(message) {
      if (message.conversationable_type == 'BenchChannel') {
        this.$router.push(
          `/channels/${message.conversationable_id}/${message.id}`
        );
      } else if (message.conversationable_type == 'Profile') {
        this.$router.push(`/profiles/${message.receiver_id}/${message.id}`);
      } else if (message.conversationable_type == 'Group') {
        this.$router.push(`/groups/${message.group_id}/${message.id}`);
      }
    },
    getImageSrc(message) {
      const receiver = this.profiles.find(
        profile => profile.id === message.receiver_id
      );
      return receiver?.image_url;
    },
    getIcon(message) {
      const channelDetail = this.channels.find(
        channel => channel.id === message.conversationable_id
      );
      if (channelDetail.is_private) {
        return 'fa-lock';
      } else {
        return 'fa-hashtag';
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
