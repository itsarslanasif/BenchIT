<template>
  <div class="flex flex-col h-full w-full">
    <div class=" w-full flex flex-col border-b border-slate-100 header-style">
      <div class="flex justify-between items-center px-5 py-2 border-b border-slate-100">
        <div class="text-xl font-bold">
          {{ $t('channels.all_channels') }}
        </div>
        <div>
          <div @click="closeModal">
            <n-button type="success">{{ $t('channels.add_new_channel') }}</n-button>
          </div>
        </div>
      </div>
      <div class="px-5 py-2">
        <n-space vertical>
          <form @submit.prevent="handleSubmit">
            <n-input type="text" size="large" v-model:value="term" @keyup.enter="handleSubmit"
              :placeholder="$t('channels.search_by_name_or_desc')">
              <template #prefix>
                <n-icon :component="SearchOutline" />
              </template>
            </n-input>
          </form>
        </n-space>
        <div class="flex items-center py-1 justify-between">
          <div class="text-small text-gray-900 font-thin">
            {{ pageInfo.count }} {{ $t('channels.result') }}
          </div>
          <div class="flex gap-4 items-center">
            <div> <n-popselect v-model:value="sortValue" :options="options">
                <n-button>{{ $t('filters.sort_label') }} {{ selectedLabel }}</n-button>
              </n-popselect></div>
            <div @click="toggleFilters">
              Filter
            </div>
            <div v-if="filterState" @click="toggleFilters">
              close
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="flex flex-col items-end" v-if="filterState" >
      <div class="flex"> <ChannelFilter /> </div>
    </div>
    <div class="px-5 body-style overflow-y-auto flex flex-col">
      <CreateChannel :closeModal="closeModal" v-if="modalOpen" />
      <div v-for="channel in searchedChannels" :key="channel.id">
        <ChannelList :channelName="channel.name" :channelDescription="channel.description"
          :channelParticipants="channel.profiles" :isPrivate="channel.is_private" :channelId="channel.id" />
      </div>
      <div class="flex justify-center p-3">
        <n-pagination v-model:page="currentPage" :page-count="pageInfo.pages"
          :on-update:page="changePage" />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onBeforeUnmount, watch } from 'vue';
import { NInput, NSpace, NIcon, NButton, NPopselect, NPagination } from 'naive-ui';
import { useChannelStore } from '../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import ChannelList from '../containers/ChannelList.vue'
import { SearchOutline } from "@vicons/ionicons5";
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
    NPagination
  },
  setup() {
    const term = ref('');
    const modalOpen = ref(false)
    const channelStore = useChannelStore()
    const sortValue = ref('newest')
    const filterState = ref(false)
    channelStore.index(term.value, sortValue.value)
    const { channels, currentPage, pageInfo, filterChannelsValue } = storeToRefs(channelStore)
    const searchedChannels = computed(() => channels.value)

    const handleSubmit = async () => {
      channelStore.index(term.value, sortValue.value)
    };

    const changePage = (page) => {
      channelStore.index(term.value, sortValue.value, page)
    }

    const closeModal = () => {
      modalOpen.value = !modalOpen.value;
    }

    const toggleFilters = () => {
      filterState.value = !filterState.value;
    }

    const selectedLabel = computed(() => {
      switch (sortValue.value) {
        case 'newest':
          return CONSTANTS.NEWEST_CHANNELS
        case 'oldest':
          return CONSTANTS.OLDEST_CHANNELS
        case 'most_participants':
          return CONSTANTS.MOST_MEMBERS
        case 'fewest_participants':
          return CONSTANTS.FEWEST_MEMBERS
        case 'a_to_z':
          return CONSTANTS.A_TO_Z
        case 'z_to_a':
          return CONSTANTS.Z_TO_A
      }
    })

    watch(sortValue, async (newValue) => {
      channelStore.index(term.value, newValue)
    })

    watch(filterChannelsValue, async () => {
      channelStore.index(term.value, sortValue.value)
    })


    onBeforeUnmount(() => {
      searchedChannels.value = [];
      channels.value = [];
    });

    return {
      term,
      searchedChannels,
      modalOpen,
      SearchOutline,
      handleSubmit,
      closeModal,
      changePage,
      sortValue,
      currentPage,
      pageInfo,
      selectedLabel,
      filterState,
      toggleFilters,
      options: [
        {
          label: CONSTANTS.NEWEST_CHANNELS,
          value: "newest"
        },
        {
          label: CONSTANTS.OLDEST_CHANNELS,
          value: "oldest"
        },
        {
          label: CONSTANTS.MOST_MEMBERS,
          value: "most_participants",
        },
        {
          label: CONSTANTS.FEWEST_MEMBERS,
          value: "fewest_participants"
        },
        {
          label: CONSTANTS.A_TO_Z,
          value: "a_to_z"
        },
        {
          label: CONSTANTS.Z_TO_A,
          value: "z_to_a"
        },
      ]
    };
  },
};
</script>
<style scoped>
.header-style {
  flex: 0.1;
}

.body-style {
  flex: 0.9;
}
</style>
