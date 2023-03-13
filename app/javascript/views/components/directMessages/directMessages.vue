<template>
  <div class="grid grid-cols-1 text-light divide-y overflow-none">
    <span class="flex justify-between">
      <div class="p-2 text-black-900 text-xl font-semibold">
        {{ $t('direct_messages.direct_messages') }}
      </div>
    </span>
    <div>
      <div class="flex flex-col px-4 border-b border-light shadow-sm h-12">
        <div v-click-outside="closeSearchModal" class="w-full">
          <div
            class="w-full flex justify-center gap-2 mt-3"
            @click="searchModalToggle = true"
          >
            <p class="text-black-400">{{ $t('request.to') }}</p>
            <input
              type="text"
              :placeholder="$t('find_direct_messages.somebody')"
              class="w-full focus:outline-none"
              v-model="search"
            />
          </div>
          <div
            v-if="searchModalToggle"
            class="w-flexible-md h-flexible-md overflow-auto bg-white mx-4 text-center rounded absolute z-10 shadow-2xl text-black-900 border border-light"
          >
            <div class="text-left">
              <div class="mt-6">
                <div
                  v-for="chat in filteredList"
                  :key="chat.id"
                  @click="goToChat(chat, `/profiles/${chat.id}`)"
                  class="hover:bg-transparent p-2 cursor-pointer"
                >
                  <div class="flex items-center">
                    <div class="mx-3">
                      <div v-if="chat.username">
                        <img :src="chat.image_url" class="w-6 h-6 rounded" />
                      </div>
                    </div>
                    <div class="flex gap-2">
                      <p class="font-semibold">
                        {{ chat.username }}
                        {{ ownProfile(chat) ? $t('chat.you') : '' }}
                      </p>
                      <span
                        style="font-size: 7px; float: left; margin-top: 6px"
                      >
                        {{
                          chat.is_active ? $t('chat.active') : $t('chat.away')
                        }}
                      </span>
                      <p>
                        {{ chat.display_name }}
                      </p>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
  <div class="text-black-900 overflow-y-auto">
    <div class="text-black-900">
      <div class="m-4">
        <div v-for="message in last_messages" :key="message.id">
          {{ setMessage(message) }}
          <div v-if="!isSameDayMessage || isFirstMessage">
            <div v-if="isToday" class="text-xs text-black-900 font-bold m-4">
              <p>{{ $t('chat.today') }}</p>
            </div>
            <div v-else class="text-xs text-black-900 font-bold m-4">
              <p>{{ new Date(message.created_at).toDateString() }}</p>
            </div>
          </div>
          <div
            @click="handleClick(message)"
            class="bg-transparent mb-1 gap-1 rounded cursor-pointer flex p-4 hover:bg-black-200"
          >
            <span class="w-12 h-12">
              <n-avatar :src="getProfileAvatar" :size="40" />
            </span>
            <div class="flex flex-col">
              <span class="flex items-center gap-2">
                <p class="font-semibold">
                  {{
                    isOwnMessage ? message.receiver_name : message.sender_name
                  }}
                </p>
                <p class="text-black-500 text-xs">
                  {{ time }}
                </p>
              </span>
              <div class="flex">
                <span class="mr-1"
                  >{{
                    isOwnMessage ? 'You' : firstName(message.sender_name)
                  }}:</span
                >
                <span v-for="block in messageBlocks" :key="block">
                  <MessageSection
                    v-if="block.type === 'section'"
                    :section="block"
                  />
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
import { NAvatar } from 'naive-ui';
import { storeToRefs } from 'pinia';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { useProfileStore } from '../../../stores/useProfileStore';
import vClickOutside from 'click-outside-vue3';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import {
  getDirectMessagesList,
  getLastDirectMessagesList,
} from '../../../api/directMessages/directMessages';
import MessageSection from '../messages/MessageSection.vue';

export default {
  components: { NAvatar, MessageSection },
  data() {
    return {
      last_messages: [],
      currMessage: {},
      prevMessage: {},
      searchModalToggle: false,
      search: '',
      filteredList: [],
      allProfiles: [],
    };
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  setup() {
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const currentProfileStore = useCurrentProfileStore();
    const profileStore = useProfileStore();
    const leftPaneStore = useLeftpaneStore();
    const messageStore = useMessageStore();
    const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
    const { currentProfile } = storeToRefs(currentProfileStore);
    const { profiles } = storeToRefs(profileStore);
    return {
      currentWorkspace,
      currentProfile,
      allProfiles: profiles,
      leftPaneStore,
      messageStore,
    };
  },
  watch: {
    search() {
      this.filteredList = this.allProfiles;
      this.filterData();
    },
    allProfiles() {
      this.allProfiles = this.allProfiles.filter(
        profile => profile.username !== null
      );
    },
  },
  async mounted() {
    this.last_messages = await getLastDirectMessagesList();
    this.filteredList = this.allProfiles;
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.currMessage;
      this.currMessage = message;
    },
    handleClick(message) {
      this.messageStore.deleteChannelName();
      this.messageStore.setSelectedChatUserName(this.getProfileName(message));
      this.$router.push(`/profiles/${message.receiver_id}/${message.id}`);
    },
    firstName(fullname) {
      return fullname.split(' ')[0];
    },
    filterData() {
      this.filteredList = this.filteredList.filter(item =>
        (item['workspace_id'] ? item['username'] : item['name'])
          .toLowerCase()
          .includes(this.search.toLowerCase())
      );
    },
    closeSearchModal() {
      this.searchModalToggle = false;
    },
    goToChat(chat, url) {
      this.messageStore.setSelectedChat(chat);
      this.$router.push(url);
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
      this.closeSearchModal();
    },
    ownProfile(profile) {
      return this.currentProfile.id === profile.id;
    },
    isMobileView() {
      return window.innerWidth < 1400;
    },
    getProfileName(message) {
      return message.sender_id === this.currentProfile.id
        ? message.receiver_name
        : message.sender_name;
    },
    messageBlock(message) {
      return JSON.parse(message);
    },
  },
  computed: {
    messageBlocks() {
      return JSON.parse(this.currMessage.content).blocks;
    },
    isToday() {
      return (
        new Date(this.currMessage.created_at).toDateString() ===
        new Date().toDateString()
      );
    },
    isOwnMessage() {
      return this.currMessage.sender_id === this.currentProfile.id;
    },
    time() {
      return moment(new Date(this.currMessage.created_at).getTime()).format(
        'h:mm A'
      );
    },
    isSameDayMessage() {
      return (
        new Date(this.currMessage?.created_at).toDateString() ===
        new Date(this.prevMessage?.created_at).toDateString()
      );
    },
    isFirstMessage() {
      return (
        this.last_messages && this.last_messages[0].id === this.currMessage.id
      );
    },
    getProfileAvatar() {
      const userId =
        this.currMessage.receiver_id === this.currentProfile.id
          ? this.currMessage.sender_id
          : this.currMessage.receiver_id;
      const user = this.allProfiles.find(profile => profile.id === userId);
      return user.image_url;
    },
  },
};
</script>
