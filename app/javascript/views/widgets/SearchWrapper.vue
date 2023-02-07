<template lang="">
  <div class="p-3">
    <div v-if="list.length" v-for="item in list" class="my-4">
      <div
        class="flex gap-3 bg-slate-50 border border-black-300 rounded p-2"
        v-if="listType === $t('search_bar.messages')"
        @click="
          goToMessage(
            item.conversationable_type,
            item.conversationable_id,
            item.id
          )
        "
      >
        <div class="align-baseline">
          <n-avatar :src="item.sender_avatar" class="w-12 h-12 align-middle" />
        </div>
        <div>
          <div class="font-bold">
            {{ item.sender_name }}
          </div>
          <div>
            {{ item.content }}
          </div>
        </div>
      </div>
      <div
        class="flex gap-3 bg-slate-50 border border-black-300 rounded p-2"
        v-if="listType === $t('search_bar.profiles')"
        @click="goToChat(`/profiles/${item.id}`)"
      >
        <div class="align-baseline">
          <n-avatar :src="item.image_url" class="w-12 h-12 align-middle" />
        </div>
        <div>
          <div class="font-bold capitalize">
            {{ item.username }}
          </div>
          <div>
            {{ item.description }}
          </div>
        </div>
      </div>
      <div
        class="flex gap-3 bg-slate-50 border border-black-300 rounded p-2"
        v-if="listType === $t('search_bar.channels')"
        @click="goToChat(`/channels/${item.id}`)"
      >
        <div
          class="bg-slate-100 w-12 h-12 rounded flex items-center justify-center text-xl"
        >
          <font-awesome-icon :icon="getIcon(item)" />
        </div>
        <div>
          <div class="font-bold capitalize">
            {{ item.name }}
          </div>
          <div>
            {{ item.description }}
          </div>
        </div>
      </div>
    </div>
    <div v-else class="text-center text-base flex flex-col my-5">
      <div class="text-4xl">
        <font-awesome-icon icon="fa-magnifying-glass" />
      </div>
      <div>
        {{ $t('search.no_result') }}
      </div>
    </div>
  </div>
</template>
<script>
import { NAvatar } from 'naive-ui';
import { useLeftpaneStore } from '../../stores/useLeftpaneStore';
export default {
  components: {
    NAvatar,
  },
  props: {
    list: {
      type: Array,
    },
    listType: {
      type: String,
    },
  },
  setup() {
    const leftPaneStore = useLeftpaneStore();
    return {
      leftPaneStore,
    };
  },
  methods: {
    getIcon(item) {
      return `fa-${item.is_private ? 'lock' : 'hashtag'}`;
    },

    goToChat(url) {
      this.$router.push(url);

      if (this.isMobileView()) {
        this.leftPaneStore.closeLeftPane();
      }
    },

    goToMessage(type, conversation_id, message_id) {
      this.$router.push(
        `/${this.getConversationType(type)}/${conversation_id}/${message_id}`
      );
    },

    getConversationType(type) {
      if (this.$t('conversation.channel') === type) {
        return this.$t('search_bar.channels').toLowerCase()
      } else if (this.$t('conversation.profile') === type) {
        return this.$t('search_bar.profiles').toLowerCase()
      } else {
        return this.$t('search_bar.groups').toLowerCase();
      }
    },

    isMobileView() {
      return window.innerWidth < 1400;
    },
  },
};
</script>
