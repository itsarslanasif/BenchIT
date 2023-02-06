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
              v-model:value="value"
              type="text"
              placeholder="sinippet.txt"
            />
            <p>Content</p>
            <n-input v-model:value="value" type="textarea" placeholder="..." />
            <n-checkbox size="small" label="Wrap" />
            <n-input
              v-model:value="value"
              type="textarea"
              placeholder="Add a message, if you'd like."
            />
            <n-checkbox size="small" label="Share this file" />
            <n-mention
              :options="options"
              default-value="@"
              :loading="loading"
              @search="handleSearch"
              :render-label="renderLabel"
            />
            <n-button class="float-right" type="success">
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
} from 'naive-ui';
import { useShortcutAttachmentStore } from '../../../stores/useShortcut&AttachmentStore';
import { ref, h } from 'vue';
import { getMembers } from '../../../api/members/membersApi';
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
  },
  data() {
    return {
      title: '',
      content: '',
      wrap: 'true',
      message: '',
      share: '',
    };
  },
  setup() {
    const shortcutAttachmentStore = useShortcutAttachmentStore();
    let optionsRef = ref([]);
    let loadingRef = ref(false);
    let searchTimerId = null;
    let members = null;
    return {
      options: optionsRef,
      loading: loadingRef,
      shortcutAttachmentStore,
      handleSearch(pattern, prefix) {
        if (searchTimerId !== null) clearTimeout(searchTimerId);
        console.log(pattern);
        loadingRef.value = true;
        searchTimerId = window.setTimeout(() => {
          getMembers(1, pattern, '').then(response => {
            optionsRef.value = response;
            console.log('rrrr', optionsRef.value);
          });
          loadingRef.value = false;
        }, 1000);
      },
      renderLabel: option =>
        h('div', { style: 'display: flex; align-items: center;' }, [
          h(NAvatar, {
            style: 'margin-right: 8px;',
            size: 24,
            round: true,
            src: option.image_url,
          }),
          option.username,
        ]),
    };
  },
  props: ['showModal'],
};
</script>
