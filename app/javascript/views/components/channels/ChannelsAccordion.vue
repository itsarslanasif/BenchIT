<template>
  <div>
    <AccordionList class="my-5 ml-3 text-base text-slate-50">
      <AccordionItem default-opened="true">
        <template #summary>{{ heading }}</template>
        <h5 v-for="item in list" :key="item.id" class="hover:bg-primaryHover">
          <div @click="goToChannelChat(`/${item.email ? 'users' : 'channels'}/${item.id}`)" class="-ml-3 pl-3 flex align-middle hover:bg-primaryHover">
            <div v-if="isUser(item)" class="mr-2">
              <font-awesome-icon icon="fa-user" />
            </div>
            <div v-if="isChannel(item)" class="mr-2">
              <div v-if="isPrivateChannel(item)">
                <font-awesome-icon icon="fa-lock" />
              </div>
              <div v-else>
                <font-awesome-icon icon="fa-hashtag" />
              </div>
            </div>
            <div class="text-base pt-0">
              {{ item.name }}
            </div>
          </div>
        </h5>
        <div class="mt-2 -ml-3 hover:bg-primaryHover" v-if="heading === $t('channels.title')" @click="modalOpen = !modalOpen">
          <h5 class="pl-3">{{ $t('channels.add_new_channel') }}</h5>
        </div>
      </AccordionItem>
    </AccordionList>
    <div v-if="modalOpen">
      <CreateChannel :close-modal="closeModal" />
    </div>
  </div>
</template>

<script>
import { AccordionList, AccordionItem } from 'vue3-rich-accordion';
import CreateChannel from './CreateChannel.vue';

export default {
  components: { AccordionList, AccordionItem, CreateChannel },
  props: ["list", "heading"],
  data() {
    return {
      // channels: [],
      modalOpen: false,
    };
  },
  methods: {
    closeModal() {
      this.modalOpen = !this.modalOpen;
    },
    goToChannelChat(chatURL) {
      window.location.href = chatURL;
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
};
</script>
