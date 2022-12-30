<template>
  <transition name="modal-fade">
    <div
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent"
    >
      <div class="modal rounded-md shadow-md bg-slate-50" role="dialog">
        <div class="p-8">
          <header id="modalTitle" class="flex w-full">
            <div class="w-5/6 text-lg text-black-900">
              <h1>{{ $t('channels.create_channel') }}</h1>
            </div>
            <button
              type="button"
              class="w-1/6 bg-none py-1 px-3 text-base float-right rounded"
              @click="closeModal"
            >
              {{ $t('actions.close') }}
            </button>
          </header>

          <Form @submit="onSubmit">
            <section id="modalDescription" class="m-0 relative mt-3">
              <div class="mb-1">
                <p>
                  {{ $t('channels.add_channel_dialog') }}
                </p>
              </div>
              <div class="text-base">
                <label> {{ $t('channels.new_channel_name') }} </label>
              </div>
              <div class="mb-3">
                <Field
                  v-model="channelName"
                  class="form-control w-full p-2 rounded bg-none"
                  type="text"
                  :placeholder="$t('channels.new_channel_name_placeholder')"
                  :rules="validateName"
                />
                <ErrorMessage name="Name" class="text-danger text-sm" />
              </div>
              <div>
                <label> {{ $t('channels.new_channel_description') }} </label>
              </div>
              <div class="mb-3">
                <Field
                  class="form-control w-full p-2 rounded bg-none"
                  type="text"
                  :placeholder="$t('channels.new_channel_desc_placeholder')"
                />
              </div>
            </section>

            <footer class="mb-4">
              <button
                type="submit"
                :disabled="!channelName"
                class="bg-success text-white py-2 px-5 text-base float-right my-3 rounded"
              >
                {{ $t('actions.create') }}
              </button>
            </footer>
          </Form>
        </div>
      </div>
    </div>
  </transition>
</template>
<script>
import { NForm, NFormItem, NButton, NInput, NSwitch, NSpace } from 'naive-ui';
import { useChannelStore } from '../../../stores/useChannelStore';
import { CONSTANTS } from '../../../assets/constants';
export default {
  components: {
    NForm,
    NFormItem,
    NButton,
    NInput,
    NSwitch,
    NSpace,
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
        Description: {
          required: true,
          message: CONSTANTS.CHANNEL_DISCRIPTION_ERROR,
          trigger: ['input'],
        },
      },
      formValue: {
        channelName: '',
        Description: '',
        isPrivate: false,
      },
      error: '',
    };
  },
  setup() {
    const channelStore = useChannelStore();
    return {
      channelStore,
    };
  },

  beforeUnmount() {
    this.form.channelName = null;
    this.form.Description = null;
  },

  methods: {
    onSubmit() {
      this.validations();
      if (!this.error) {
        this.channelStore.createChannel(
          this.formValue.channelName,
          this.formValue.Description,
          this.formValue.isPrivate
        );
        this.closeModal();
      }
    },
    validations() {
      const regex = /^[a-zA-Z0-9-_]+$/;
      if (
        this.formValue.channelName == '' ||
        this.formValue.Description == ''
      ) {
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
