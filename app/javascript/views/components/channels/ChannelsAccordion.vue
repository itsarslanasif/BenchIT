<template>
  <div class="hover-trigger">
    <ChannelsDropDown :handleSelect="handleSelect" :onlyIcon="true" />
    <AccordionList
      class="mt-5 ml-4 text-base text-slate-50"
      @click="toggleList"
    >
      <AccordionItem :default-opened="listOpen">
        <template class="flex justify-between items-center" #summary>
          <span class="ml-2 cursor-pointer">
            {{ $t('channels.title') }}
          </span>
        </template>
        <div class="-ml-4">
          <h5
            v-for="channel in joinedChannels"
            :key="channel.id"
            class="hover:bg-primaryHover"
          >
            <ChannelItem
              :channel="channel"
              :goTo="goToChannelChat"
              :toggleShow="toggleChannelOptionShow"
              :isShowOptions="showChannelOptions"
            />
          </h5>
          <ChannelsDropDown :handleSelect="handleSelect" :onlyIcon="false" />
        </div>
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
import CreateChannel from './CreateChannel.vue';
import ChannelItem from './ChannelItem.vue';
import { useChannelStore } from '../../../stores/useChannelStore';
import { storeToRefs } from 'pinia';
import { useLeftpaneStore } from '../../../stores/useLeftpaneStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import ChannelsDropDown from '../../widgets/channelsDropDown.vue';
export default {
  components: {
    AccordionList,
    AccordionItem,
    CreateChannel,
    ChannelItem,
    ChannelsDropDown,
  },
  data() {
    return {
      channels: [],
      showChannelOptions: false,
      listOpen: true,
      selectedChannel: {},
      showCreateChannelModal: false,
    };
  },
  unmounted() {
    this.channels = null;
  },
  setup() {
    const leftPaneStore = useLeftpaneStore();
    const channelStore = useChannelStore();
    const { joinedChannels } = storeToRefs(channelStore);
    const messagesStore = useMessageStore();
    return {
      joinedChannels,
      leftPaneStore,
      messagesStore,
      channelStore,
    };
  },
  methods: {
    toggleModal() {
      this.showCreateChannelModal = !this.showCreateChannelModal;
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
        this.joinedChannels.find(obj => obj.id === Number(channel.id)) ||
        this.channelStore.starChannels.find(
          obj => obj.id === Number(channel.id)
        );
    },
    checkSetChannel() {
      return (
        this.selectedChannel.id === this.messagesStore.selectedChat.id &&
        !this.selectedChannel.favourite_id
      );
    },
    handleSelect(key) {
      switch (key) {
        case 'create-a-channel':
          this.toggleModal();
          break;
        case 'browse-channels':
          this.$router.push('/browse-channels');
          break;
      }
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
