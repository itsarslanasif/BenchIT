<template>
  <div class="flex flex-col h-full w-full">
    <div class=" w-full flex flex-col header-style">
      <div class="px-5 py-2 text-xl font-bold border-b border-gray-200">
        {{ $t('channels.all_channels') }}
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
          <p class="text-small text-gray-900 py-1 font-thin border-b border-gray-200">
            {{ searchedChannels?.length }} {{ $t('channels.result') }}
          </p>
        </n-space>
      </div>
    </div>
    <div class="px-5 body-style overflow-y-auto flex flex-col border-gray-200">
      <div v-for="channel in searchedChannels" :key="channel.id">
        <ChannelList :channelName="channel.name" :channelDescription="channel.description"
          :channelParticipants="channel.profiles" :isPrivate="channel.is_private" :channelId="channel.id" />
      </div>
    </div>
  </div>
</template>

<script>
import { ref, computed, onBeforeUnmount } from 'vue';
import { NInput, NSpace, NIcon } from 'naive-ui';
import { useChannelStore } from '../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import ChannelList from '../containers/ChannelList.vue'
import { SearchOutline } from "@vicons/ionicons5";


export default {
  name: 'AllChannels',

  components: {
    ChannelList,
    NInput,
    NSpace,
    NIcon,
  },

  setup() {
    const term = ref('');
    const channelStore = useChannelStore();
    channelStore.index(term.value)
    const { channels } = storeToRefs(channelStore);
    const searchedChannels = computed(() => channels.value)

    const handleSubmit = async () => {
      searchedChannels.value = await channelStore.searchChannels(term.value)
    };

    onBeforeUnmount(() => {
      term.value = null;
      searchedChannels.value = null;
    });

    return {
      term,
      searchedChannels,
      SearchOutline,
      handleSubmit,
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