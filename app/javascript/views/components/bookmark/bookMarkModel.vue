<template>
  <transition name="modal-fade">
    <div
      class="flex justify-center text-black-800 items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent"
    >
      <div
        class="modal rounded-md w-2/5 h-2/5 shadow-md bg-white"
        role="dialog"
      >
        <div class="p-8">
          <header id="modalTitle" class="flex w-full">
            <div class="w-5/6 text-lg">
              <h1>{{ title }}</h1>
            </div>
            <button
              type="button"
              class="w-1/6 bg-none py-1 px-3 text-base float-right rounded"
              @click="toggleModel"
            >
              {{ $t('actions.close') }}
            </button>
          </header>
          <div class="m-0 relative mt-5">
            <div class="mb-6">
              <p>
                {{ $t('bookmark.add_bookmark_note') }}
              </p>
            </div>
            <n-form
              :label-width="80"
              :model="formValue"
              :rules="rules"
              :size="size"
            >
              <n-form-item :label="$t('bookmark.title')" path="bookMarkTitle">
                <n-input
                  v-model:value="formValue.bookMarkTitle"
                  :placeholder="$t('bookmark.name_placeholder')"
                />
              </n-form-item>
              <n-form-item
                class="mt-3"
                :label="$t('bookmark.link')"
                path="bookMarkLink"
              >
                <n-input
                  v-model:value="formValue.bookMarkLink"
                  :placeholder="$t('bookmark.url_placeholder')"
                />
              </n-form-item>
              <p v-if="error" class="mt-3 text-danger">{{ error }}</p>
              <n-form-item v-if="newBookMark" class="float-right">
                <n-button
                  @click="handleCreate"
                  class="bg-success text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
                >
                  {{ $t('actions.create') }}
                </n-button>
              </n-form-item>
              <n-form-item v-if="!newBookMark" class="float-right">
                <n-button
                  @click="handleUpdate"
                  class="bg-slate-600 text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
                >
                  {{ $t('actions.update') }}
                </n-button>
              </n-form-item>
              <n-form-item v-if="!newBookMark" class="float-right">
                <n-button
                  @click="handleDelete"
                  class="bg-danger text-white py-2 ml-2 px-5 text-base float-right my-3 rounded"
                >
                  {{ $t('actions.delete') }}
                </n-button>
              </n-form-item>
            </n-form>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import { NForm, NFormItem, NButton, NInput } from 'naive-ui';
import { useBookmarkStore } from '../../../stores/useBookmarkStore';
import { CONSTANTS } from '../../../assets/constants';
export default {
  name: 'CreateChannel',
  components: {
    NForm,
    NFormItem,
    NButton,
    NInput,
  },

  data() {
    return {
      formValue: {
        bookMarkTitle: '',
        bookMarkLink: '',
      },
      error: '',
    };
  },
  props: [
    'title',
    'bookMarkObject',
    'newBookMark',
    'toggleModel',
    'channelId',
    'bookmarkable_type',
    'bookmarkable_id',
  ],
  mounted() {
    if (!this.newBookMark) {
      this.setBookmarkObject(this.bookMarkObject);
    }
  },
  setup() {
    const bookmarkStore = useBookmarkStore();
    return {
      rules: {
        bookMarkTitle: {
          required: true,
          message: CONSTANTS.DONNT_FORGET_TO_ADD_BOOKMARK_TITLE,
          trigger: ['input'],
        },
        bookMarkLink: {
          required: true,
          message: CONSTANTS.DONNT_FORGET_TO_ADD_BOOKMARK_LINK,
          trigger: ['input'],
        },
      },
      bookmarkStore,
    };
  },
  methods: {
    setBookmarkObject(bookmark) {
      this.formValue.bookMarkTitle = bookmark.name;
      this.formValue.bookMarkLink = bookmark.bookmark_URL;
    },

    handleCreate() {
      this.validations();
      if (!this.error) {
        this.toggleModel();
        this.bookmarkStore.create_bookmark(
          this.formValue.bookMarkTitle,
          this.formValue.bookMarkLink,
          this.bookmarkable_type,
          this.bookmarkable_id
        );
      }
    },
    handleDelete() {
      this.validations();
      if (!this.error) {
        this.toggleModel();
      }
    },
    handleUpdate() {
      this.validations();
      if (!this.error) {
        this.toggleModel();
      }
    },

    validations() {
      if (this.formValue.bookMarkTitle == '') {
        this.error = CONSTANTS.YOU_FORGET_TO_ADD_BOOKMARK_TITLE;
      } else if (this.formValue.bookMarkLink == '') {
        this.error = CONSTANTS.YOU_FORGET_TO_ADD_BOOKMARK_LINK;
      } else {
        this.error = '';
      }
    },
  },
};
</script>
