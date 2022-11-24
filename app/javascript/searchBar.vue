<template>
  <div class="flex items-center justify-center flex-col p-2">
    <div class="flex w-1/2">
      <div class="w-full" @click="searchModalToggle = true">
        <input
          v-model="search"
          type="text"
          placeholder="Search"
          class="text-center border-2 rounded-t w-full h-8 bg-primary border-primaryHover text-white"
        />
      </div>
      <div
        v-if="searchModalToggle"
        class="w-1/6 text-center text-white"
        @click="searchModalToggle = false"
      >
        <span class="inline-block align-middle">Close</span>
      </div>
      <div
        v-if="searchModalToggle"
        class="w-1/2 bg-primaryHover text-center rounded-b absolute z-10 mt-8 shadow-2xl text-white"
      >
        <div class="text-left p-6">
          <p class="mb-1 text-xs">I'm looking for:</p>
          <div class="flex gap-2">
            <button
              class="bg-slate-500 px-3 py-1 w-auto"
              @click="searchPeopleOnly"
            >
              People
            </button>
            <button
              class="bg-slate-500 px-3 py-1 w-auto"
              @click="searchChannelsOnly"
            >
              Channels
            </button>
          </div>
          <div class="mt-6">
            <div v-if="usersFlag">
              <span class="py-1 w-auto text-xl font-semibold">People</span>
              <div
                v-for="item in filteredList"
                :key="item.id"
                class="hover:bg-slate-600 p-2 rounded"
              >
                <strong>{{ item.username }}</strong>
                <span class="text-sm">{{ item.description }}</span>
              </div>
            </div>
            <div v-if="channelsFlag">
              <span class="py-1 w-auto text-xl font-semibold">Channels</span>
              <div
                v-for="item in filteredList"
                :key="item.id"
                class="hover:bg-slate-600 p-2 rounded"
              >
                {{ item.name }}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import { useUserStore } from './stores/useUserStore';
import { useChannelStore } from './stores/useChannelStore';
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
  watch: {
    search() {
      if (this.usersFlag) {
        this.filteredList = this.allUsers;
      } else if (this.channelsFlag) {
        this.filteredList = this.allChannels;
      } else {
        this.filteredList = [...this.allUsers, ...this.allChannels];
      }
      this.filterData();
    },
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
      if (this.usersFlag) {
        this.filteredList = this.filteredList.filter(item =>
          item.username.toLowerCase().includes(this.search.toLowerCase())
        );
      } else if (this.channelsFlag) {
        this.filteredList = this.filteredList.filter(item =>
          item.name.toLowerCase().includes(this.search.toLowerCase())
        );
      }
    },
  },
  setup() {
    const userStore = useUserStore();
    const channelStore = useChannelStore();
    return {
      allUsers: Object.values(userStore.getUsers),
      allChannels: Object.values(channelStore.getChannels),
    };
  },
};
</script>
