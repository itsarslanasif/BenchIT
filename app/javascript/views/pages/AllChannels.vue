<template>
  <div class="flex flex-col h-full w-full">
    <div class="w-full flex flex-col border-b border-light header-style">
      <div
        class="flex justify-between items-center px-5 py-2 border-b border-light"
      >
        <div class="text-xl font-bold">
          {{ $t('channels.all_channels') }}
        </div>
        <div>
          <div @click="closeModal">
            <n-button type="success">{{
              $t('channels.add_new_channel')
            }}</n-button>
          </div>
        </div>
      </div>
      <div class="px-5 py-2">
        <n-space class="mb-4" vertical>
          <form @submit.prevent="handleSubmit">
            <n-input
              type="text"
              size="large"
              v-model:value="term"
              @keyup.enter="handleSubmit"
              :placeholder="$t('channels.search_by_name_or_desc')"
            >
              <template #prefix>
                <n-icon :component="SearchOutline" />
              </template>
            </n-input>
          </form>
        </n-space>
        <div
          class="flex items-center py-1 justify-between font-light text-small"
        >
          <div class="text-gray-700">
            {{ totalResults }}
          </div>
          <div class="flex gap-1 items-center">
            <div class="px-2 py-1 rounded hover:bg-transparent cursor-pointer">
              <i class="fas fa-sort mr-1" />
              <n-popselect v-model:value="sortValue" :options="options">
                {{ $t('filters.sort_label') + selectedLabel }}
              </n-popselect>
            </div>
            <div
              @click="toggleFilters"
              class="px-2 py-1 rounded hover:bg-transparent cursor-pointer"
            >
              <i class="fas fa-sliders-h" />
              {{ $t('filters.filter') }}
            </div>
            <div
              @click="resetFilters"
              v-if="isFiltered()"
              class="cursor-pointer text-primary hover:underline"
            >
              {{ $t('filters.reset') }}
            </div>
            <div
              v-show="filterState"
              @click="toggleFilters"
              class="px-1 rounded hover:bg-transparent cursor-pointer"
            >
              <i class="fas fa-xmark self-center" />
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex body-style overflow-auto">
      <div class="px-4 h-full w-full flex flex-col overflow-y-auto">
        <CreateChannel :closeModal="closeModal" v-if="modalOpen" />
        <div v-for="channel in searchedChannels" :key="channel.id">
          <ChannelList
            :channelName="channel.name"
            :channelDescription="channel.description"
            :channelParticipants="channel.profiles"
            :isPrivate="channel.is_private"
            :channelId="channel.id"
          />
        </div>
        <div class="flex justify-center p-3">
          <n-pagination
            :page-count="pageInfo.pages"
            :on-update:page="changePage"
          />
        </div>
      </div>
      <div class="flex flex-col p-5 w-1/4" v-show="filterState">
        <ChannelFilter />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onBeforeUnmount, watch } from 'vue';
import {
  NInput,
  NSpace,
  NIcon,
  NButton,
  NPopselect,
  NPagination,
} from 'naive-ui';
import { useChannelStore } from '../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import ChannelList from '../containers/ChannelList.vue';
import { SearchOutline } from '@vicons/ionicons5';
import CreateChannel from '../components/channels/CreateChannel.vue';
import ChannelFilter from '../containers/ChannelFilter.vue';
import { CONSTANTS } from '../../assets/constants';

export default {
  components: {
    ChannelList,
    ChannelFilter,
    CreateChannel,
    NInput,
    NSpace,
    NIcon,
    NButton,
    NPopselect,
    NPagination,
  },
  setup() {
    const term = ref('');
    const modalOpen = ref(false);
    const channelStore = useChannelStore();
    const sortValue = ref('newest');
    const filterState = ref(false);
    const { filterChannelsValue, hideMyChannels } = storeToRefs(channelStore);
    channelStore.index(
      term.value,
      sortValue.value,
      filterChannelsValue.value,
      hideMyChannels.value
    );
    const { channels, pageInfo } = storeToRefs(channelStore);
    const searchedChannels = computed(() => channels.value);

    const totalResults = computed(() => {
      return `${pageInfo.value.count ? pageInfo.value.count : 0}  ${
        CONSTANTS.RESULTS
      }`;
    });

    const handleSubmit = async () => {
      channelStore.index(
        term.value,
        sortValue.value,
        filterChannelsValue.value,
        hideMyChannels.value
      );
    };

    const changePage = page => {
      channelStore.index(
        term.value,
        sortValue.value,
        filterChannelsValue.value,
        hideMyChannels.value,
        page
      );
    };

    const closeModal = () => {
      modalOpen.value = !modalOpen.value;
    };

    const toggleFilters = () => {
      filterState.value = !filterState.value;
    };

    const selectedLabel = computed(() => {
      switch (sortValue.value) {
        case 'newest':
          return CONSTANTS.NEWEST_CHANNELS;
        case 'oldest':
          return CONSTANTS.OLDEST_CHANNELS;
        case 'most_participants':
          return CONSTANTS.MOST_MEMBERS;
        case 'fewest_participants':
          return CONSTANTS.FEWEST_MEMBERS;
        case 'a_to_z':
          return CONSTANTS.A_TO_Z;
        case 'z_to_a':
          return CONSTANTS.Z_TO_A;
      }
    });

    const resetFilters = () => {
      filterChannelsValue.value = '';
      hideMyChannels.value = false;
    };

    const isFiltered = () => {
      return filterChannelsValue.value != '' || hideMyChannels.value;
    };

    watch(sortValue, async newValue => {
      channelStore.index(
        term.value,
        newValue,
        filterChannelsValue.value,
        hideMyChannels.value
      );
    });

    watch(filterChannelsValue, async newValue => {
      channelStore.index(
        term.value,
        sortValue.value,
        newValue,
        hideMyChannels.value
      );
    });

    watch(hideMyChannels, async newValue => {
      channelStore.index(
        term.value,
        sortValue.value,
        filterChannelsValue.value,
        newValue
      );
    });

    onBeforeUnmount(() => {
      searchedChannels.value = [];
      channels.value = [];
    });

    return {
      term,
      searchedChannels,
      modalOpen,
      totalResults,
      SearchOutline,
      handleSubmit,
      closeModal,
      changePage,
      sortValue,
      pageInfo,
      selectedLabel,
      filterState,
      toggleFilters,
      resetFilters,
      isFiltered,
      options: [
        {
          label: CONSTANTS.NEWEST_CHANNELS,
          value: 'newest',
        },
        {
          label: CONSTANTS.OLDEST_CHANNELS,
          value: 'oldest',
        },
        {
          label: CONSTANTS.MOST_MEMBERS,
          value: 'most_participants',
        },
        {
          label: CONSTANTS.FEWEST_MEMBERS,
          value: 'fewest_participants',
        },
        {
          label: CONSTANTS.A_TO_Z,
          value: 'a_to_z',
        },
        {
          label: CONSTANTS.Z_TO_A,
          value: 'z_to_a',
        },
      ],
    };
  },
};
</script>
<style scoped>
.header-style {
  flex: 0.1;
}

.body-style {
  flex: 1;
}
</style>
