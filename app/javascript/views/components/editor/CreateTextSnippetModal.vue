<template>
  <div>
    <n-modal v-model:show="shortcutAttachmentStore.showCreateTextSnippitModal">
      <n-card
        style="width: 600px"
        preset="dialog"
        title="Create snippet "
        :bordered="false"
        size="huge"
        role="dialog"
        aria-modal="true"
      >
        <template #header-extra> X </template>
        <template #footer>
          <n-space class="flex" vertical>
            <p class="">Titial optional</p>
            <n-input
              v-model:value="title"
              type="text"
              placeholder="sinippet.txt"
            />
            <p>Content</p>
            <n-input
              v-model:value="content"
              type="textarea"
              placeholder="..."
            />
            <n-checkbox size="small" label="Wrap" />
            <n-input
              v-model:value="value"
              type="textarea"
              placeholder="Add a message, if you'd like."
            />
            <n-checkbox size="small" label="Share this file" />
            <n-select
              vertical
              v-model:value="selectedValues"
              filterable
              :placeholder="$t('placeholder.add_people_to_channel')"
              :options="options"
              :loading="loading"
              clearable
              remote
              :clear-filter-after-select="true"
              :show-arrow="false"
              @search="handleSearch"
              size="large"
              @change="resetSelectedTag()"
            />
            <n-button
              @click="createTextFile"
              class="float-right"
              type="success"
            >
              Create snippet
            </n-button>
          </n-space>
        </template>
      </n-card>
    </n-modal>
  </div>
</template>

<script>
import {
  NModal,
  NInput,
  NCard,
  NIcon,
  NSpace,
  NDivider,
  NCheckbox,
  NMention,
  NButton,
  NAvatar,
  NSelect,
} from 'naive-ui';
import { useShortcutAttachmentStore } from '../../../stores/useShortcut&AttachmentStore';
import { ref, h } from 'vue';
import { getMembers } from '../../../api/members/membersApi';
import { useMessageStore } from '../../../stores/useMessagesStore';
export default {
  components: {
    NModal,
    NInput,
    NCard,
    NIcon,
    NSpace,
    NDivider,
    NCheckbox,
    NMention,
    NButton,
    NAvatar,
    NSelect,
  },
  data() {
    return {
      title: '',
      content: '',
      wrap: 'true',
      message: '',
      share: '',

      loading: false,
      options: [],
      selectedValues: null,
    };
  },
  mounted() {
    this.selectedValues = this.selectedChat.username || this.selectedChat.name;
    this.getMembersList('');
  },
  methods: {
    handleSearch(query) {
      if (!query.length) {
        this.options.username = [];
        return;
      }
      this.loading = true;
      setTimeout(() => {
        this.getMembersList(query);
        this.loading = false;
      }, 1e3);
    },
    async getMembersList(query) {
      let options = await getMembers(1, query);
      this.options = options.map(option => {
        return {
          label: option.username,
          value: option.id,
          image_url: option.image_url,
        };
      });
    },
    resetSelectedTag() {
      this.value = '';
    },
    createTextFile() {
      const textFile = new Blob([this.content], { type: 'text/plain' });
      const files = [textFile];
      if (this.title !== '') {
        this.sendMessage('FILE', files, this.title);
      } else {
        this.sendMessage('FILE', files, 'textFile.txt');
      }
    },
  },
  setup() {
    const shortcutAttachmentStore = useShortcutAttachmentStore();
    const { selectedChat } = useMessageStore();
    return {
      shortcutAttachmentStore,
      selectedChat,
    };
  },
  props: ['showModal', 'sendMessage'],
};
</script>
