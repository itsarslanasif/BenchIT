<template>
  <div
    v-if="!leftPaneStore.getLeftpaneFlag"
    @click="leftPaneStore.openLeftPane"
    class="text-xl items-center text-white hover:bg-slate-600 rounded cursor-pointer"
  >
    <font-awesome-icon class="p-2" icon="fa-solid fa-bars" />
  </div>

  <div
    class="flex items-center justify-center p-2 border-b border-slate-400 bg-secondary h-full"
  >
    <div v-click-outside="closeSearchModal" class="flex w-1/2">
      <div class="w-full" @click="searchModalToggle = true">
        <input
          type="text"
          @keydown.enter="goToSearches"
          :placeholder="getPlaceholder()"
          class="text-center border-2 rounded-t w-full bg-primary border-primaryHover text-white"
          v-model="search"
        />
      </div>
      <div
        class="w-1/6 text-center text-white"
        v-if="searchModalToggle"
        @click="closeSearchModal()"
      >
        <span class="inline-block align-middle">{{ $t('actions.close') }}</span>
      </div>
      <div
        v-if="searchModalToggle"
        class="w-1/2 bg-primary h-64 overflow-y-auto text-center rounded-b absolute z-10 mt-8 shadow-2xl text-white"
      >
        <div class="text-left p-6">
          <div v-if="!search">
            <p class="mb-1 text-xs text-white">
              {{ $t('search_bar.tagline') }}
            </p>
            <div class="flex gap-2">
              <button
                class="px-3 py-1 w-auto rounded border-primaryHover border-2 hover:bg-primaryHover text-white"
                @click="searchMessagesOnly"
              >
                {{ $t('search_bar.messages') }}
              </button>
              <button
                class="px-3 py-1 w-auto rounded border-primaryHover border-2 hover:bg-primaryHover text-white"
                @click="searchChannelsOnly"
              >
                {{ $t('search_bar.channels') }}
              </button>
              <button
                class="px-3 py-1 w-auto rounded border-primaryHover border-2 hover:bg-primaryHover text-white"
                @click="searchPeopleOnly"
              >
                {{ $t('search_bar.people') }}
              </button>
            </div>
          </div>
          <div v-if="search" class="pb-2 border-b border-primaryHover">
            <div class="px-5 py-2 rounded hover:bg-primaryHover">
              <font-awesome-icon icon="fa-magnifying-glass" class="pr-3" />
              {{ search }}
            </div>
          </div>
          <div class="mt-2">
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
            <div v-if="filter.value" class="px-5 font-bold text-base pb-2">
              {{ filter.attr }}
            </div>
            <Searches
              :searches="searches.profiles"
              :closeSearchModal="closeSearchModal"
            />
            <Searches
              :searches="searches.channels"
              :closeSearchModal="closeSearchModal"
            />
            <Searches
              :searches="searches.messages"
              :closeSearchModal="closeSearchModal"
            />
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
</template>
<script>
import { useProfileStore } from '../../stores/useProfileStore';
import { useChannelStore } from '../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import ProfileDropdown from '../widgets/profileDropdown.vue';
import Searches from '../widgets/searches.vue';
import vClickOutside from 'click-outside-vue3';
import benchitAlert from '../widgets/benchitAlert.vue';
import { useApiResponseStatusStore } from '../../stores/useApiResponseStatusStore';
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
import { useCurrentWorkspaceStore } from '../../stores/useCurrentWorkspaceStore';
import { useSearchStore } from '../../stores/useSearchStore';
export default {
  name: 'SearchBar',
  components: { ProfileDropdown, benchitAlert, Searches },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  data() {
    return {
      searchModalToggle: false,
      filter: {
        attr: '',
        value: null,
      },
      search: '',
    };
  },
  mounted() {
    this.intervalId = setInterval(() => {
      const token = localStorage.getItem('token');
      if (!token) {
        clearInterval(this.intervalId);
        sessionStorage.removeItem('currentWorkspace');
        sessionStorage.removeItem('currentProfile');
        this.$router.push('/sign_in');
      }
    }, 5000);
  },
  methods: {
    searchPeopleOnly() {
      this.filter.attr = this.$t('search_bar.people');
      this.filter.value = this.$t('search_bar.profile_attr');
    },
    searchChannelsOnly() {
      this.filter.attr = this.$t('search_bar.channels');
      this.filter.value = this.$t('search_bar.channel_attr');
    },
    searchMessagesOnly() {
      this.filter.attr = this.$t('search_bar.messages');
      this.filter.value = this.$t('search_bar.message_attr');
    },
    closeSearchModal() {
      this.search = this.filter.attr = '';
      this.filter.value = null;
      this.searchModalToggle = false;
    },
    getPlaceholder() {
      return `${this.$t('actions.search')} ${
        this.currentWorkspace.company_name
      }`;
    },
    goToSearches() {
      this.searchStore.setSearch(this.search);
      this.closeSearchModal();
      this.$router.push('/search');
    },
  },
  watch: {
    search() {
      if (this.search !== '') {
        this.searchStore.index(this.search, this.filter.value);
      } else {
        this.searchStore.clearSearches();
        this.filter.value = null;
      }
    },
  },
  setup() {
    const profileStore = useProfileStore();
    const channelStore = useChannelStore();
    const searchStore = useSearchStore();
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    const ApiResponseStatusStore = useApiResponseStatusStore();
    const { searches, searched } = storeToRefs(searchStore);
    const currentWorkspace = currentWorkspaceStore.getCurrentWorkspace;
    const leftPaneStore = useLeftpaneStore();
    profileStore.index();
    channelStore.index();
    channelStore.fetchJoinedChannels();

    return {
      ApiResponseStatusStore,
      leftPaneStore,
      currentWorkspace,
      searchStore,
      searches,
      searched,
    };
  },
};
</script>
