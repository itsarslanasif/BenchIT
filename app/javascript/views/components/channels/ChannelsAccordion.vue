<template>
  <div class="hover-trigger">
    <font-awesome-icon
      @click="goToChannels"
      icon="fa-plus"
      class="hover-target px-2 p-2 float-right -ml-12 mr-2 text-xs cursor-pointer text-center text-white rounded-md hover:bg-slate-600"
    />
    <AccordionList class="mt-5 ml-4 text-base text-slate-50" @click="toggleList">
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
          <div
            @click="toggleModal"
            class="flex hover:bg-primaryHover cursor-pointer py-1 pl-2"
          >
            <font-awesome-icon
              icon="fa-plus"
              class="self-center mr-2 text-xs cursor-pointer text-white rounded-md p-2 bg-slate-600"
            />
            <p class="text-sm self-center text-white truncate">
              {{ $t('channels.add_new_channel') }}
            </p>
          </div>
        </div>
        <div v-if="modalOpen">
          <CreateChannel :close-modal="toggleModal" />
        </div>
      </AccordionItem>
    </AccordionList>
  </div>
  <div v-if="!listOpen && this.checkSetChannel()" class="-ml-4">
    <h5 class="hover:bg-primaryHover ml-4 text-base cursor-pointer text-white bg-slate-600">
      <ChannelItem :channel="selectedChannel" :goTo="goToChannelChat" :toggleShow="toggleChannelOptionShow"
        :isShowOptions="showChannelOptions" />
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
export default {
  components: { AccordionList, AccordionItem, CreateChannel, ChannelItem },
  data() {
    return {
      channels: [],
      modalOpen: false,
      showChannelOptions: false,
      listOpen: true,
      selectedChannel: {},
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
    };
  },
  methods: {
    toggleModal() {
      this.modalOpen = !this.modalOpen;
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
    goToChannels() {
      this.$router.push('/browse-channels');
    },
    toggleList() {
      this.listOpen = !this.listOpen;
      this.setChannel(this.messagesStore.selectedChat);
    },
    setChannel(channel) {
      this.selectedChannel = this.joinedChannels.find(obj => obj.id === Number(channel.id)) || this.channelStore.starChannels.find(obj => obj.id === Number(channel.id));
    },
    checkSetChannel() {
      if (this.selectedChannel.id === this.messagesStore.selectedChat.id && this.selectedChannel.favourite_id === null) {
        return true;
      }
      else {
        return false;
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
