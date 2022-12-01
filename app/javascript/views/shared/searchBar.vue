<template>
  <div class="flex items-center justify-center flex-col p-2">
    <div class="flex w-1/2">
      <div class="w-full" @click="searchModalToggle = true">
        <input type="text" placeholder="Search"
          class="text-center border-2 rounded-t w-full h-8 bg-primary border-primaryHover text-white"
          v-model="search" />
      </div>
      <div class="w-1/6 text-center text-white" v-if="searchModalToggle" @click="searchModalToggle = false">
        <span class="inline-block align-middle">Close</span>
      </div>
      <div v-if="searchModalToggle"
        class="w-1/2 bg-primary text-center rounded-b absolute z-10 mt-8 shadow-2xl text-white">
        <div class="text-left p-6">
          <p class="mb-1 text-xs text-white">{{ $t('search_bar.tagline') }}</p>
          <div class="flex gap-2">
            <button class="px-3 py-1 w-auto rounded border-primaryHover border-2 hover:bg-primaryHover"
              @click="searchPeopleOnly">
              {{ $t('search_bar.people') }}
            </button>
            <button class="px-3 py-1 w-auto rounded border-primaryHover border-2 hover:bg-primaryHover"
              @click="searchChannelsOnly">
              {{ $t('search_bar.channels') }}
            </button>
          </div>
          <div class="mt-6">
            <div w-auto text-xl font-semibold class="py-1 w-auto text-xl font-semibold">
              <div v-if="usersFlag">{{ $t('search_bar.people') }}</div>
              <div v-else-if="channelsFlag">{{ $t('search_bar.channels') }}</div>
            </div>
            <div v-for="item in filteredList" :key="item.id" class="hover:bg-slate-600 p-2 rounded">
              <div class="flex">
                <div v-if="isUser(item)" class="mx-3">
                  <font-awesome-icon icon="fa-user" />
                </div>
                <div v-if="isChannel(item)" class="mx-3">
                  <div v-if="isPrivateChannel(item)">
                    <font-awesome-icon icon="fa-lock" />
                  </div>
                  <div v-else>
                    <font-awesome-icon icon="fa-hashtag" />
                  </div>
                </div>
                <div>
                  {{ item.name }}
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useProfileStore } from '../../stores/useProfileStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { storeToRefs } from 'pinia';
export default {
  name: 'SearchBar',
  data() {
    return {
      searchModalToggle: false,
      search: '',
      filteredList: [],
      allUsers: [],
      allChannels: [],
      usersFlag: false,
      channelsFlag: false,
    };
  },
  methods: {
    searchPeopleOnly() {
      this.usersFlag = true;
      this.channelsFlag = false;
      this.filteredList = this.allUsers;
    },
    searchChannelsOnly() {
      this.usersFlag = false;
      this.channelsFlag = true;
      this.filteredList = this.allChannels;
    },
    filterData() {
      this.filteredList = this.filteredList.filter(item => item.name.toLowerCase().includes(this.search.toLowerCase()));
    },
    isUser(item) {
      if (item.email) {
        return true
      } else {
        return false
      }
    },
    isChannel(item) {
      if (item.description) {
        return true
      } else {
        return false
      }
    },
    isPrivateChannel(item) {
      if (item.isPrivateChannel) {
        return true
      } else {
        return false
      }
    }
  },
  watch: {
    search() {
      if (this.search === '') {
        this.usersFlag = false
        this.channelsFlag = false
        this.filteredList = [...this.allUsers, ...this.allChannels]
      }
      if (this.usersFlag) {
        this.filteredList = this.allUsers;
      } else if (this.channelsFlag) {
        this.filteredList = this.allChannels;
      } else {
        this.filteredList = [...this.allUsers, ...this.allChannels];
      }
      this.filterData();
    },
    allUsers() {
      this.allUsers = this.allUsers.filter(user => user.name !== null);
    }
  },
  setup() {
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    profileStore.index();
    channelStore.index();
    return {
      allUsers: profiles,
      allChannels: channels,
    };
  },
};
</script>
