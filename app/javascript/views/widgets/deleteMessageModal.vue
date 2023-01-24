<template>
  <n-modal
    v-model:show="showDeleteModal"
    class="custom-card rounded-lg w-160"
    preset="card"
    :bordered="false"
    size="huge"
    content-style="overflow-y: auto; overflow-x: hiddden; max-height: 440px"
  >
    <template #header>
      <span class="text-2xl font-bold">
        {{ $t('deleteMessageModal.title') }}
      </span>
    </template>
    <div>
      <span>{{ $t('deleteMessageModal.confirmation') }}</span>
    </div>
    <div class="flex border-black-300 border p-3 rounded-md mt-4">
      <div @click="handleClick">
        <n-avatar
          class="mr-1 cursor-pointer"
          size="small"
          :src="message.sender_avatar"
        />
      </div>
      <div>
        <div class="ml-1">
          <span class="items-center flex text-black-800 text-lg m-0">
            <p class="mr-1 text-sm hover:underline cursor-pointer">
              <b @click="handleClick">{{ message.sender_name }}</b>
            </p>
            <p
              class="text-xs ml-2 mr-3 text-black-500 hover:underline cursor-pointer"
            >
              {{ new Date(message.created_at).toDateString() }} at {{ time }}
            </p>
          </span>
          <span
            class="text-black-800 text-sm flex-wrap"
            v-html="message.content"
          />
          <div v-if="message.attachments">
            <n-collapse arrow-placement="right" :default-expanded-names="['1']">
              <n-collapse-item name="1">
                <template #header>
                  <span class="text-black-600 text-xs">{{
                    getTitle(message)
                  }}</span>
                </template>
                <div
                  v-for="attachment in message.attachments"
                  :key="attachment.id"
                  class="w-64"
                >
                  <div>
                    <n-popover
                      class="rounded-md border-black-300 border text-black-600"
                      placement="top-end"
                      trigger="hover"
                      :show-arrow="false"
                      :overlap="overlap"
                      style="margin-right: 10px; margin-top: 4px"
                    >
                      <template #trigger>
                        <img
                          :src="attachment.attachment_link"
                          class="rounded border border-black-400 mb-2"
                        />
                      </template>
                      <a :href="attachment.attachment_download_link" download>
                        <span class="mr-3" @click="downloadFile(attachment)">
                          <font-awesome-icon
                            icon="fa-solid fa-cloud-arrow-down"
                          />
                        </span>
                      </a>
                      <downloadsModal
                        icon="fa-solid fa-share"
                        :actionText="$t('downloadsModal.share_file')"
                      />
                      <downloadsModal
                        icon="fa-solid fa-ellipsis-vertical"
                        :actionText="$t('emojiModalButton.more_actions')"
                        :action="setFileOptionsModal"
                      />
                    </n-popover>
                  </div>
                </div>
              </n-collapse-item>
            </n-collapse>
          </div>
        </div>
      </div>
    </div>
    <div class="flex float-right mt-6">
      <button
        class="font-semibold text-black border px-4 h-9 rounded-md border-black-400 mr-2 hover:bg-black-100"
        @click="setDeleteModal"
      >
        {{ $t('actions.cancel') }}
      </button>
      <button
        class="font-semibold bg-red-700 text-white border px-4 h-9 rounded-md"
        @click="deleteMessage"
      >
        {{ $t('actions.delete') }}
      </button>
    </div>
  </n-modal>
</template>

<script>
import { useUserProfileStore } from '../../stores/useUserProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import { deleteMessage } from '../../api/messages';
import downloadsModal from '../widgets/downloadsModal/downloadsModal.vue';
import { NModal, NAvatar, NCollapse, NCollapseItem, NPopover } from 'naive-ui';
import { fileDownload } from '../../api/downloads/downloads.js';
import { useDownloadsStore } from '../../stores/useDownloadsStore';
import { ref } from 'vue';
import moment from 'moment';

export default {
  setup() {
    const rightPaneStore = useRightPaneStore();
    const userProfileStore = useUserProfileStore();
    const profilesStore = useProfileStore();
    const downloadsStore = useDownloadsStore();
    return {
      overlap: ref(true),
      rightPaneStore,
      userProfileStore,
      profilesStore,
      downloadsStore,
    };
  },
  props: ['message', 'setDeleteModal'],
  components: {
    NModal,
    NAvatar,
    NCollapse,
    NCollapseItem,
    NPopover,
    downloadsModal,
  },
  data() {
    return {
      showFileOptions: false,
    };
  },
  computed: {
    time() {
      return moment(new Date(this.message.created_at).getTime()).format(
        'h:mm A'
      );
    },
  },
  methods: {
    showUserProfile() {
      this.setUserProfileForPane();
      this.rightPaneStore.toggleUserProfileShow(true);
    },

    setUserProfileForPane() {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === this.message.sender_id
      );
      this.userProfileStore.setUserProfile(profile);
    },

    handleClick() {
      this.setDeleteModal();
      this.showUserProfile();
    },

    deleteMessage() {
      deleteMessage(this.message.id);
      this.setDeleteModal();
    },

    getTitle(message) {
      if (message.attachments.length > 1) {
        return `${message.attachments.length} files`;
      } else if (message.attachments.length === 1) {
        return message.attachments[0].attachment.filename;
      }
    },

    downloadFile(attachment) {
      try {
        fileDownload(attachment).then(response => {
          this.downloadsStore.downloads.unshift(response.data);
          this.downloadsStore.response = response;
          this.downloadsStore.downloadAlert = true;
        });
        this.downloadsStore.downloadAlert = false;
      } catch (error) {
        this.downloadsStore.downloadAlert = true;
      }
    },

    setFileOptionsModal() {
      this.showFileOptions = !this.showFileOptions;
    },
  },
};
</script>
