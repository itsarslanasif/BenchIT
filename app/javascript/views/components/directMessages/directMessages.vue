<template>
  <div
    class="relative bg-secondary text-white border border-slate-600 h-screen -mb-12"
  >
    <div class="grid text-slate-600 grid-cols-1 divide-y">
      <span class="flex justify-between">
        <div class="p-2 text-white text-xl">
          {{ $t('direct_messages.direct_messages') }}
        </div>
      </span>
      <div>
        <div
          class="flex flex-col px-4 border-b border-slate-400 bg-secondary h-12"
        >
          <div v-click-outside="closeSearchModal" class="w-full">
            <div
              class="w-full flex justify-center gap-2 mt-3"
              @click="searchModalToggle = true"
            >
              <p class="text-slate-200">{{ $t('request.to') }}</p>
              <input
                type="text"
                :placeholder="$t('find_direct_messages.somebody')"
                class="bg-secondary w-full focus:outline-none border-primaryHover text-white"
                v-model="search"
              />
            </div>
            <div
              v-if="searchModalToggle"
              class="w-flexible-2xl h-flexible-md overflow-auto bg-slate-600 mx-4 text-center rounded absolute z-10 shadow-2xl text-white"
            >
              <div class="text-left">
                <div class="mt-6">
                  <div
                    v-for="chat in filteredList"
                    :key="chat.id"
                    @click="goToChat(`/profiles/${chat.id}`)"
                    class="hover:bg-slate-800 p-2 cursor-pointer"
                  >
                    <div class="flex items-center">
                      <div class="mx-3">
                        <div v-if="chat.username">
                          <img :src="chat.image_url" class="w-6 rounded" />
                        </div>
                      </div>
                      <div class="flex gap-2">
                        <p class="font-semibold">
                          {{ chat.username }}
                          {{ ownProfile(item) ? '(you)' : '' }}
                        </p>
                        <span
                          style="font-size: 7px; float: left; margin-top: 6px"
                        >
                          {{ chat.isActive ? '🟢' : ' ⚫' }}
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
        <hr />
      </div>
    </div>
    <div
      class="scrollable bg-slate-700 rounded text-white h-screen overflow-hidden"
    >
      <div class="m-4">
        <div v-for="message in sortedMessages" :key="message.id">
          {{ setMessage(message) }}
          <div v-if="!isSameDayMessage || isFirstMessage">
            <div v-if="isToday" class="text-xs text-white font-bold m-4">
              <p>{{ $t('messages_section.today') }}</p>
            </div>
            <div v-else class="text-xs text-white font-bold m-4">
              <p>{{ new Date(message.created_at).toDateString() }}</p>
            </div>
          </div>

          <div
            @click="handleClick(message)"
            class="bg-primary mb-1 rounded items-center cursor-pointer flex p-4 hover:bg-slate-800"
          >
            <n-avatar :src="getProfileAvatar" :size="40" />
            <div class="ml-3 leading-3">
              <div class="font-bold">
                {{ isOwnMessage ? message.receiver_name : message.sender_name }}
              </div>
              <br />
              <div class="flex">
                <span class="mr-1"
                  >{{
                    isOwnMessage ? 'You' : firstName(message.sender_name)
                  }}:</span
                >
                <span class="" v-html="message.content"></span>
              </div>
            </div>
            <div class="ml-auto text-black-200">
              {{ time }}
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
import { useProfileStore } from '../../../stores/useProfileStore';
import vClickOutside from 'click-outside-vue3';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import {
  getDirectMessagesList,
  getLastDirectMessagesList,
} from '../../../api/directMessages/directMessages';

export default {
  components: { NAvatar },
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
    const { currentWorkspace } = storeToRefs(currentWorkspaceStore);
    const { currentProfile } = storeToRefs(currentProfileStore);
    const { profiles } = storeToRefs(profileStore);
    return {
      currentWorkspace,
      currentProfile,
      allProfiles: profiles,
      leftPaneStore,
    };
  },
  watch: {
    search() {
      if (this.search === '') {
        this.usersFlag = false;
        this.channelsFlag = false;
        this.filteredList = this.allProfiles;
      }
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
    const dmList = await getDirectMessagesList(this.currentWorkspace.id);
    const dmIDs = dmList.map(dm => dm.id);
    this.last_messages = await getLastDirectMessagesList(dmIDs);
    this.filteredList = this.allProfiles;
  },
  methods: {
    setMessage(message) {
      this.prevMessage = this.currMessage;
      this.currMessage = message;
    },
    handleClick(message) {
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
    goToChat(url) {
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
  },
  computed: {
    sortedMessages() {
      return this.last_messages.sort((a, b) => {
        return new Date(b.created_at) - new Date(a.created_at);
      });
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
      if (this.last_messages) {
        return this.last_messages[0].id === this.currMessage.id;
      }
    },
    getProfileAvatar() {
      let user = {};
      if (this.currMessage.receiver_id === this.currentProfile.id) {
        user = this.allProfiles.find(
          profile => profile.id === this.currMessage.sender_id
        );
      } else {
        user = this.allProfiles.find(
          profile => profile.id === this.currMessage.receiver_id
        );
      }
      return user.image_url;
    },
  },
};
</script>
