<template>
  <n-modal v-model:show="showModal">
    <n-card
      style="width: 600px"
      preset="dialog"
      :title="$t('create_text_snippet.create_snippet')"
      :bordered="false"
      size="huge"
      role="dialog"
      aria-modal="true"
    >
      <template #header-extra>
        <font-awesome-icon
          @click="toggleCreateTextSnippetModal"
          class="cursor-pointer h-5 w-5"
          icon="fa-solid fa-xmark"
        />
      </template>
      <template #footer>
        <n-space class="flex" vertical>
          <n-form
            :label-width="80"
            :model="formValue"
            :rules="rules"
            :size="size"
          >
            <n-form-item :label="$t('create_text_snippet.title')" path="Titial">
              <n-input
                v-model:value="formValue.title"
                :maxlength="80"
                :count-graphemes="countGraphemes"
                show-count
                :placeholder="$t('create_text_snippet.title_placeholder')"
              />
            </n-form-item>
            <n-form-item
              :label="$t('create_text_snippet.content')"
              path="content"
            >
              <n-input
                v-model:value="formValue.content"
                type="textarea"
                :placeholder="$t('create_text_snippet.content_placeholder')"
              />
            </n-form-item>
            <n-checkbox
              v-model:checked="formValue.wrap"
              class="mb-5"
              size="small"
              label="Wrap"
            />
            <n-form-item label="Wrapper" path="Titial">
              <n-input
                v-model:value="formValue.message"
                type="textarea"
                :placeholder="$t('create_text_snippet.message_placeholder')"
              />
            </n-form-item>
            <n-checkbox
              v-model:checked="formValue.share"
              size="small"
              :label="$t('create_text_snippet.share_this_file')"
            />
            <n-form-item path="Titial">
              <n-select
                vertical
                v-model:value="selectedUser"
                filterable
                :placeholder="$t('create_text_snippet.share_with')"
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
            </n-form-item>
            <n-form-item class="float-right">
              <n-button
                :disabled="disableButton"
                @click="createTextFile"
                class="bg-success text-white py-2 px-5 text-base float-right my-3 rounded"
              >
                {{ $t('actions.create') }}
              </n-button>
            </n-form-item>
          </n-form>
        </n-space>
      </template>
    </n-card>
  </n-modal>
</template>

<script>
import {
  NModal,
  NInput,
  NCard,
  NSpace,
  NCheckbox,
  NButton,
  NSelect,
  NForm,
  NFormItem,
} from 'naive-ui';
import { useShortcutAndAttachmentStore } from '../../../stores/useShortcutAndAttachmentStore';
import { useMessageStore } from '../../../stores/useMessagesStore';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { getMembers } from '../../../api/members/membersApi';
import { ref } from 'vue';

export default {
  props: [
    'sendMessage',
    'isThread',
    'recieverName',
    'toggleCreateTextSnippetModal',
  ],
  components: {
    NModal,
    NInput,
    NCard,
    NSpace,
    NCheckbox,
    NButton,
    NSelect,
    NForm,
    NFormItem,
  },
  computed: {
    showModal() {
      return true;
      // return this.isThread
      //   ? this.shortcutAttachmentStore.showCreateTextSnippitModalThread
      //   : this.shortcutAttachmentStore.showCreateTextSnippitModal;
    },
  },
  data() {
    return {
      disableButton: ref(true),
      loading: false,
      options: [],
      selectedUser: null,
      formValue: {
        title: '',
        content: '',
        wrap: false,
        share: true,
        message: '',
      },
      rules: {
        content: {
          required: true,
          message: this.$t('create_text_snippet.content_error_message'),
          trigger: ['input'],
        },
      },
    };
  },
  watch: {
    formValue: {
      handler(newValue) {
        this.disableButton =
          newValue.content === '' ||
          (newValue.title !== '' && !newValue.title.includes('.txt'));
      },
      deep: true,
    },
  },
  mounted() {
    this.selectedUser = this.recieverName;
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
    closeModal() {
      this.toggleCreateTextSnippetModal();
    },
    async getMembersList(query) {
      let options = await getMembers(this.currentWorkspace.id, query);
      this.options = options.map(option => ({
        label: option.username,
        value: option.id,
        image_url: option.image_url,
      }));
    },
    resetSelectedTag() {
      this.value = '';
    },
    createTextFile() {
      const fileTitle =
        this.formValue.title !== ''
          ? this.formValue.title
          : this.$t('create_text_snippet.text_file_txt');
      const textFile = new Blob([this.formValue.content], {
        type: this.$t('create_text_snippet.text_plain'),
      });
      const files = [textFile];
      if (this.formValue.share) {
        this.sendMessage(
          {
            blocks: [
              { type: 'section', text: { type: 'mrkdwn', text: fileTitle } },
            ],
          },
          files,
          null,
          fileTitle
        );
      }
      this.closeModal();
    },
  },
  setup() {
    const shortcutAttachmentStore = useShortcutAndAttachmentStore();
    const { currentWorkspace } = useCurrentWorkspaceStore();
    const { selectedChat } = useMessageStore();
    return {
      shortcutAttachmentStore,
      selectedChat,
      currentWorkspace,
    };
  },
};
</script>
