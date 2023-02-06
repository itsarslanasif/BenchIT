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
        <template #header-extra>
          <font-awesome-icon
            @click="shortcutAttachmentStore.toggleShowCreateTextSnippitModal"
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
              <n-form-item label="Titial (optional)" path="Titial">
                <n-input
                  v-model:value="formValue.title"
                  :maxlength="80"
                  :count-graphemes="countGraphemes"
                  show-count
                  placeholder="sinippet.txt"
                />
              </n-form-item>

              <n-form-item label="Content" path="content">
                <n-input
                  v-model:value="formValue.content"
                  type="textarea"
                  placeholder="Add content here."
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
                  placeholder="Add a message, if you'd like."
                />
              </n-form-item>
              <n-checkbox
                v-model:checked="formValue.share"
                size="small"
                label="Share this file"
              />
              <n-form-item path="Titial">
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
  NForm,
  NFormItem,
  NSwitch,
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
    NForm,
    NFormItem,
    NSwitch,
  },
  data() {
    return {
      rules: {
        content: {
          required: true,
          message: "content can't be empty",
          trigger: ['input'],
        },
      },
      disableButton: ref(true),
      formValue: {
        title: '',
        content: '',
        wrap: false,
        share: true,
        message: '',
      },
      error: '',
      share: 'true',
      lable: 'lable',

      loading: false,
      options: [],
      selectedValues: null,
    };
  },
  watch: {
    formValue: {
      handler(newValue) {
        if (newValue.content != '') {
          this.disableButton = false;
        } else {
          this.disableButton = true;
        }
      },
      deep: true,
    },
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
      const textFile = new Blob([this.formValue.content], {
        type: 'text/plain',
      });
      const files = [textFile];
      if (this.formValue.share) {
        if (this.formValue.title !== '') {
          this.sendMessage('FILE', files, this.formValue.title);
        } else {
          this.sendMessage('FILE', files, 'textFile.txt');
        }
      }
      this.shortcutAttachmentStore.toggleShowCreateTextSnippitModal();
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
