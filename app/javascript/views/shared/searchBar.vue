<template>
  <div>
    <div
      class="flex items-center justify-center flex-col p-2 border-b border-slate-400 bg-secondary h-12"
    >
      <div v-click-outside="closeSearchModal" class="flex w-1/2">
        <div class="w-full" @click="searchModalToggle = true">
          <input
            type="text"
            :placeholder="$t('actions.search')"
            class="text-center border-2 rounded-t w-full bg-primary border-primaryHover text-white"
            v-model="search"
          />
        </div>
        <div
          class="w-1/6 text-center text-white"
          v-if="searchModalToggle"
          @click="closeSearchModal()"
        >
          <span class="inline-block align-middle">{{
            $t('actions.close')
          }}</span>
        </div>
        <div
          v-if="searchModalToggle"
          class="w-1/2 bg-primary text-center rounded-b absolute z-10 mt-8 shadow-2xl text-white"
        >
          <div class="text-left p-6">
            <p class="mb-1 text-xs text-white">
              {{ $t('search_bar.tagline') }}
            </p>
            <div class="flex gap-2">
              <button
                class="px-3 py-1 w-auto rounded border-primaryHover border-2 hover:bg-primaryHover"
                @click="searchPeopleOnly"
              >
                {{ $t('search_bar.people') }}
              </button>
              <button
                class="px-3 py-1 w-auto rounded border-primaryHover border-2 hover:bg-primaryHover"
                @click="searchChannelsOnly"
              >
                {{ $t('search_bar.channels') }}
              </button>
            </div>
            <div class="mt-6">
              <div
                w-auto
                text-xl
                font-semibold
                class="py-1 w-auto text-xl font-semibold"
              >
                <div v-if="usersFlag">{{ $t('search_bar.people') }}</div>
                <div v-else-if="channelsFlag">
                  {{ $t('search_bar.channels') }}
                </div>
              </div>
              <div
                v-for="item in filteredList"
                :key="item.id"
                class="hover:bg-slate-600 p-2 rounded"
              >
                <div class="flex">
                  <div v-if="!item.creator_id" class="mx-3">
                    <font-awesome-icon icon="fa-user" />
                  </div>
                  <div v-if="item.creator_id" class="mx-3">
                    <div v-if="item.is_private">
                      <font-awesome-icon icon="fa-lock" />
                    </div>
                    <div v-else>
                      <font-awesome-icon icon="fa-hashtag" />
                    </div>
                  </div>
                  <div>
                    {{ item.creator_id ? item.name : item.username }}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <ProfileDropdown />
    <div>
      <benchitAlert
        v-if="ApiResponseStatusStore.responseStatus"
        :v-bind="ApiResponseStatusStore.responseStatus?.message"
        :successMessage="$t('channels.channel_created_success')"
        :success="!ApiResponseStatusStore.responseStatus?.errors"
        :errorMessage="$t('channels.channel_created_failure')"
        :setApiResponseStatusNull="
          ApiResponseStatusStore.setApiResponseStatusNull
        "
      />
    </div>
  </div>
</template>
<script>
import { useProfileStore } from '../../stores/useProfileStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { storeToRefs } from 'pinia';
import ProfileDropdown from '../widgets/profileDropdown.vue';
import vClickOutside from 'click-outside-vue3';
import benchitAlert from '../widgets/benchitAlert.vue';
import { useApiResponseStatusStore } from '../../stores/useApiResponseStatusStore';
import { useMessage } from 'naive-ui';
export default {
  name: 'SearchBar',
  components: { ProfileDropdown, benchitAlert },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  data() {
    return {
      searchModalToggle: false,
      search: '',
      filteredList: [],
      allProfiles: [],
      allChannels: [],
      usersFlag: false,
      channelsFlag: false,
    };
  },
  methods: {
    searchPeopleOnly() {
      this.usersFlag = true;
      this.channelsFlag = false;
      this.filteredList = this.allProfiles;
    },
    searchChannelsOnly() {
      this.usersFlag = false;
      this.channelsFlag = true;
      this.filteredList = this.allChannels;
    },
    closeSearchModal() {
      this.searchModalToggle = false;
    },
    filterData() {
      this.filteredList = this.filteredList.filter(item =>
        item.name.toLowerCase().includes(this.search.toLowerCase())
      );
    },
  },
  watch: {
    search() {
      if (this.search === '') {
        this.usersFlag = false;
        this.channelsFlag = false;
        this.filteredList = [...this.allProfiles, ...this.allChannels];
      }
      if (this.usersFlag) {
        this.filteredList = this.allProfiles;
      } else if (this.channelsFlag) {
        this.filteredList = this.allChannels;
      } else {
        this.filteredList = [...this.allProfiles, ...this.allChannels];
      }
      this.filterData();
    },
    allProfiles() {
      this.allProfiles = this.allProfiles.filter(
        profile => profile.username !== null
      );
    },
  },
  setup() {
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const ApiResponseStatusStore = useApiResponseStatusStore();
    const { profiles } = storeToRefs(profileStore);
    const { channels } = storeToRefs(channelStore);
    profileStore.index();
    channelStore.index();
    return {
      ApiResponseStatusStore,
      allProfiles: profiles,
      allChannels: channels,
    };
  },
};
</script>
