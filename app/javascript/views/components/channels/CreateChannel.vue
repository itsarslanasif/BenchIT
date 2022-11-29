<template>
  <transition name="modal-fade">
    <div
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent">
      <div class="modal rounded-md shadow-md bg-slate-50" role="dialog" aria-labelledby="Channel Name"
        aria-describedby="Channel Description">
        <div class="p-8">
          <header id="modalTitle" class="flex w-full">
            <div class="w-5/6 text-lg">
              <h1>Create a channel</h1>
            </div>
            <button type="button" class="w-1/6 bg-none py-1 px-3 text-base float-right rounded" aria-label="Close modal" @click="closeModal">
              Close
            </button>
          </header>

          <Form @submit="onSubmit">
            <section id="modalDescription" class="m-0 relative mt-3">
              <div class="mb-1">
                <p>
                  Channels are where your team communicates. They’re best when
                  organized around a topic — #marketing, for example.
                </p>
              </div>
              <div class="text-base">
                <label> Name </label>
              </div>
              <div class="mb-3">
                <Field v-model="channelName" class="form-control w-full p-2 rounded bg-none" type="text" name="Name"
                  placeholder="e.g. plan-budget" :rules="validateName" />
                <ErrorMessage name="Name" class="text-danger text-sm" />
              </div>
              <div>
                <label> Description </label>
              </div>
              <div class="mb-3">
                <Field class="form-control w-full p-2 rounded bg-none" type="text" name="Description"
                  placeholder="Description is optional" />
              </div>
            </section>

            <footer class="mb-4">
              <button type="submit" :disabled="!channelName" class="bg-success text-white py-2 px-5 text-base float-right my-3 rounded">Create</button>
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
      console.log(values, null, 2);
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
