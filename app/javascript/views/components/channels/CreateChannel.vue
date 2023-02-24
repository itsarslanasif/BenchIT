<template>
  <transition name="fade" appear>
    <div
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent">
      <div v-click-outside="closeModal" class="modal rounded-md w-2/5 h-2/5 shadow-md bg-white" role="dialog">
        <div class="p-8">
          <header id="modalTitle" class="flex w-full">
            <div class="w-5/6 text-lg text-black-900">
              <h1>{{ $t('channels.create_channel') }}</h1>
            </div>
            <button type="button" class="w-1/6 bg-none py-1 px-3 text-base float-right text-black-900 rounded"
              @click="closeModal">
              {{ $t('actions.close') }}
            </button>
          </header>
          <div class="m-0 relative mt-5">
            <div class="mb-6 text-black-500">
              <p>
                {{ $t('channels.add_channel_dialog') }}
              </p>
            </div>
            <n-form :label-width="80" :model="formValue" :rules="rules">
              <n-form-item :label="$t('channels.new_channel_name')" path="channelName">
                <n-input v-model:value="formValue.channelName" :maxlength="80" :count-graphemes="countGraphemes"
                  show-count :placeholder="$t('channels.new_channel_name_placeholder')" />
              </n-form-item>
              <n-form-item class="mt-3" :label="$t('channels.new_channel_description')" path="Description">
                <n-input v-model:value="formValue.Description" :maxlength="500" :count-graphemes="countGraphemes"
                  show-count :placeholder="$t('channels.new_channel_desc_placeholder')" />
              </n-form-item>
              <p v-if="error" class="mt-3 text-danger">{{ error }}</p>
              <n-form-item class="float-right">
                <n-button @click="onSubmit" class="bg-success text-white py-2 px-5 text-base float-right my-3 rounded">
                  {{ $t('actions.create') }}
                </n-button>
              </n-form-item>
            </n-form>
            <n-space class="text-black-900"><n-switch v-model:value="formValue.isPrivate" />
              {{ $t('channels.set_channel_private') }}</n-space>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import { NForm, NFormItem, NButton, NInput, NSwitch, NSpace } from 'naive-ui';
import { useChannelStore } from '../../../stores/useChannelStore';
import { CONSTANTS } from '../../../assets/constants';
import vClickOutside from 'click-outside-vue3';
import GraphemeSplitter from 'grapheme-splitter';
export default {
  components: {
    NForm,
    NFormItem,
    NButton,
    NInput,
    NSwitch,
    NSpace,
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  props: ['closeModal'],
  data() {
    return {
      rules: {
        channelName: {
          required: true,
          message: CONSTANTS.CHANNEL_NAME_ERROR,
          trigger: ['input'],
        },
      },
      formValue: {
        channelName: '',
        Description: '',
        isPrivate: false,
      },
      error: '',
      status: 0,
    };
  },
  setup() {
    const channelStore = useChannelStore();
    const splitter = new GraphemeSplitter();
    return {
      channelStore,
      countGraphemes: value => splitter.countGraphemes(value),
    };
  },
  methods: {
    onSubmit() {
      this.validations();
      if (!this.error) {
        this.channelStore
          .createChannel(
            this.formValue.channelName,
            this.formValue.Description,
            this.formValue.isPrivate
          )
          .then(response => {
            this.status = response.status;
            if (this.status === 200) {
              this.closeModal();
            }
            else {
              this.error = response.data.message;
            }
          })
      }
    },
    validations() {
      const regex = /^[a-zA-Z0-9-_]+$/;
      if (this.formValue.channelName == '') {
        this.error = CONSTANTS.FIELDS_REQUIRED_ERROR;
      } else if (!regex.test(this.formValue.channelName)) {
        this.error = CONSTANTS.CHANNEL_NAME_INVALID_ERROR;
      } else {
        this.error = '';
      }
    },
  },
};
</script>
