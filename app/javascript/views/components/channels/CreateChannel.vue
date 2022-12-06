<template>
  <transition name="modal-fade">
    <div
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent">
      <div class="modal rounded-md shadow-md bg-slate-50" role="dialog">
        <div class="p-8">
          <header id="modalTitle" class="flex w-full">
            <div class="w-5/6 text-lg">
              <h1>{{ $t('channels.create_channel') }}</h1>
            </div>
            <button type="button" class="w-1/6 bg-none py-1 px-3 text-base float-right rounded"
              @click="closeModal">
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
                <Field v-model="channelName" class="form-control w-full p-2 rounded bg-none" type="text"
                  :placeholder="$t('channels.new_channel_name_placeholder')" :rules="validateName" />
                <ErrorMessage name="Name" class="text-danger text-sm" />
              </div>
              <div>
                <label> {{ $t('channels.new_channel_description') }} </label>
              </div>
              <div class="mb-3">
                <Field class="form-control w-full p-2 rounded bg-none" type="text"
                  :placeholder="$t('channels.new_channel_desc_placeholder')" />
              </div>
            </section>

            <footer class="mb-4">
              <button type="submit" :disabled="!channelName"
                class="bg-success text-white py-2 px-5 text-base float-right my-3 rounded">
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
import { Form, Field, ErrorMessage } from 'vee-validate';

export default {
  name: 'CreateChannel',
  components: {
    Form,
    Field,
    ErrorMessage,
  },
  props: ['closeModal'],
  data() {
    return {
      form: {
        channelName: '',
        Description: '',
      },
    };
  },

  methods: {
    onSubmit(values) {
      this.closeModal();
    },

    validateName(value) {
      if (!value) {
        return 'Don’t forget to name your channel.';
      }
      const regex = /^[a-zA-Z0-9-_]+$/;

      if (!regex.test(value)) {
        return 'Channel names can’t contain spaces, periods, or most punctuation. Try again?';
      }

      return true;
    },
  },
};
</script>
