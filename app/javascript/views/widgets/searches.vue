<template>
  <div
  v-for="item in searches"
  :key="item.id"
  @click="goToChat(item)"
  class="hover:bg-slate-600 p-2 rounded"
  >
    <div class="flex items-center">
      <div v-if="item.sender_avatar" class="ml-3">
        <div v-if="item.sender_avatar" class="flex">
          <img :src="item.sender_avatar" class="w-6 rounded" />
        </div>
      </div>
      <div v-if="!item.creator_id" class="mx-3">
        <div v-if="item.username">
          <img :src="item.image_url" class="w-6 rounded" />
        </div>
      </div>
      <div v-if="item.creator_id" class="mx-3">
        <div v-if="item.is_private">
          <font-awesome-icon icon="fa-lock" />
        </div>
        <div v-else>
          <font-awesome-icon icon="fa-hashtag" />
        </div>
      </div>
      <div class="flex" v-if="!item.sender_avatar">
        <span> {{ item.creator_id ? item.name : item.display_name }}</span>
        <div class="flex" v-if="!item.creator_id">
          <div class="flex h-3 w-3 mt-2 ml-2">
            <div
              v-if="item.is_active"
              class="bg-green-700 text-black-800 inactivePosition h-2 w-2 rounded-xl"
            />
            <div
              v-else
              class="bg-black-800 text-black-800 inactivePosition h-2 w-2 border-2 border-white rounded-xl"
            />
          </div>
          <span class="ml-2">{{ item.username }}</span>
        </div>
      </div>
      <div v-else>
        <div class="-ml-3 flex">
          <div class="mr-2 text-black-300">
            {{ `${$t('search_bar.from')} ${item.sender_name}` }}
          </div>
          <div>
            <div v-for="block in messageBlock(item.content).blocks">
              <MessageSection
                v-if="block.type === 'section'"
                :section="block"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>
<script>
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
import MessageSection from '../components/messages/MessageSection.vue';

export default {
  components: {
    MessageSection
  },
  props: ['searches', 'closeSearchModal'],
  setup() {
    const leftPaneStore = useLeftpaneStore();
    return {
      leftPaneStore,
    };
  },
  methods: {
    messageBlock(message) {
      return JSON.parse(message)
    },
    goToChat(item) {
      let conversationType

      if (item['workspace_id']) {
        conversationType = 'profiles'
      } else if (item['creator_id']) {
        conversationType = 'channels'
      } else {
        conversationType = 'groups'
      }

      this.$router.push(`/${conversationType}/${item.id}`);

      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }

      this.closeSearchModal();
    },
    
    isMobileView() {
      return window.innerWidth < 1400;
    },
  },
};
</script>
