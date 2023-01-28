<template>
  <div v-if="starChannels.length > 0" class="hover-trigger">
    <n-dropdown
      :show="dropdown"
      :on-clickoutside="openDropdown"
      class="rounded-md"
      placement="bottom-end"
      size="medium"
      :options="options"
      @select="handleSelect"
    >
      <font-awesome-icon
        @click="openDropdown"
        icon="fa-plus"
        class="hover-target px-2 p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
      />
    </n-dropdown>
    <AccordionList
      class="mt-5 ml-4 text-base text-slate-50"
      @click="toggleList"
    >
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="cursor-pointer ml-2">
            {{ $t('channels.starred') }}
          </span>
        </template>
        <h5
          v-for="channel in starChannels"
          :key="channel.id"
          class="hover:bg-primaryHover"
        >
          <div class="-ml-4">
            <ChannelItem
              :channel="channel"
              :goTo="goToChannelChat"
              :toggleShow="toggleChannelOptionShow"
              :isShowOptions="showChannelOptions"
            />
          </div>
        </h5>
        <div v-if="showCreateChannelModal">
          <CreateChannel :close-modal="toggleModal" />
        </div>
      </AccordionItem>
    </AccordionList>
  </div>
  <div v-if="!listOpen && this.checkSetChannel()" class="-ml-4">
    <h5
      class="hover:bg-primaryHover ml-4 text-base cursor-pointer text-white bg-slate-600"
    >
      <ChannelItem
        :channel="selectedChannel"
        :goTo="goToChannelChat"
        :toggleShow="toggleChannelOptionShow"
        :isShowOptions="showChannelOptions"
      />
    </h5>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import ChannelItem from './ChannelItem.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { NDropdown } from 'naive-ui';
import CreateChannel from './CreateChannel.vue';
import { CONSTANTS } from '../../../assets/constants';

export default {
  components: {
    CreateChannel,
    NDropdown,
    AccordionList,
    AccordionItem,
    ChannelItem,
  },
  data() {
    return {
      channels: [],
      showChannelOptions: false,
      listOpen: true,
      dropdown: false,
      showCreateChannelModal: false,
      selectedChannel: {},
      options: [
        {
          label: CONSTANTS.CREATE_CHANNEL,
          key: this.generateKey(CONSTANTS.CREATE_CHANNEL),
        },
        {
          label: CONSTANTS.BROWSE_CHANNELS,
          key: this.generateKey(CONSTANTS.BROWSE_CHANNELS),
        },
      ],
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const leftPaneStore = useLeftpaneStore();
    const channelStore = useChannelStore();
    const { starChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    return {
      starChannels,
      leftPaneStore,
      messagesStore,
      channelStore,
    };
  },
  methods: {
    toggleModal() {
      this.showCreateChannelModal = !this.showCreateChannelModal;
    },
    openDropdown() {
      this.dropdown = !this.dropdown;
    },
    goToChannelChat(chatURL, channel) {
      this.messagesStore.setSelectedChat(channel);
      this.$router.push(chatURL);
      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
      this.listOpen = false;
      this.setChannel(this.messagesStore.selectedChat);
    },
    isMobileView() {
      return window.innerWidth < 1400;
    },
    toggleChannelOptionShow() {
      this.showChannelOptions = !this.showChannelOptions;
    },
    toggleList() {
      this.listOpen = !this.listOpen;
      this.setChannel(this.messagesStore.selectedChat);
    },
    setChannel(channel) {
      this.selectedChannel =
        this.channelStore.joinedChannels.find(
          obj => obj.id === Number(channel.id)
        ) || this.starChannels.find(obj => obj.id === Number(channel.id));
    },
    checkSetChannel() {
      if (
        this.selectedChannel.id === this.messagesStore.selectedChat.id &&
        this.selectedChannel.favourite_id
      ) {
        return true;
      } else {
        return false;
      }
    },
    handleSelect(key) {
      switch (key) {
        case 'create-a-channel':
          this.toggleModal();
          break;
        case 'browse-channels':
          this.openDropdown();
          this.$router.push('/browse-channels');
          break;
      }
    },
    generateKey(label) {
      return label.toLowerCase().replace(/ /g, '-');
    },
  },
};
</script>
<style scoped>
.hover-trigger .hover-target {
  display: none;
}

.hover-trigger:hover .hover-target {
  display: inline;
  cursor: pointer;
}
</style>
