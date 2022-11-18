<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
      <div
        class="modal roundbox boxshadow"
        role="dialog"
        aria-labelledby="Channel Name"
        aria-describedby="Channel Description"
      >
        <div class="modal-style">
          <header id="modalTitle" class="modal-header">
            <h1 name="header">Create a channel</h1>
            <button
              type="button"
              class="btn-close"
              aria-label="Close modal"
              @click="closeModal"
            >
              x
            </button>
          </header>

          <Form @submit="onSubmit">
            <section id="modalDescription" class="modal-body">
              <p>
                Channels are where your team communicates. They’re best when
                organized around a topic — #marketing, for example.
              </p>
              <label> Name </label>
              <ErrorMessage name="Name" class="danger" />
              <Field
                v-model="channelName"
                class="form-control"
                type="text"
                name="Name"
                placeholder="e.g. plan-budget"
                :rules="validateName"
              />
              <br />
              <label> Description </label>
              <Field
                class="form-control"
                type="text"
                name="Description"
                placeholder="Description is optional"
              />
            </section>

            <footer class="modal-footer">
              <button type="submit" :disabled="!channelName">Create</button>
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
<style>
* {
  padding: 0;
  box-sizing: border-box;
  box-shadow: #000;
}
.modal-backdrop {
  position: fixed;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;
  background-color: rgba(0, 0, 0, 0.3);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 1;
}

.modal {
  background: #ffffff;
  box-shadow: 2px 2px 20px 1px;
  overflow-x: auto;
  width: 30%;
}

.modal-header {
  padding: 15px;
  display: flex !important;
}

.modal-header {
  max-height: 100px;
  align-items: center !important;
  color: #000;
  justify-content: space-between !important;
}
.modal-header p {
  color: #000;
  margin-top: 1.6rem !important;
  font-size: 20px;
  font-weight: 600;
}

.modal-header h1 {
  color: #000;
  font-size: 35px;
  font-weight: 900;
  margin-top: 3.3rem !important;
}
.modal-footer {
  flex-direction: column;
}
.modal-footer button {
  width: 120px;
  height: 60px;
  text-transform: none;
  margin: auto;
  background-color: green;
}

button:disabled,
button[disabled] {
  border: 1px solid #999999;
  background-color: #cccccc;
  color: #666666;
}

.modal-body {
  position: relative;
  padding: 10px 10px;
  margin: 0;
}

.btn-close {
  border: none;
  font-size: 30px;
  cursor: pointer;
  width: 50px;
  margin: 0px;
  padding: 0px;
  background: transparent;
  color: rgb(59, 58, 58);
}

.btn-green {
  color: white;
  background: #4aae9b;
  border: 1px solid #4aae9b;
  border-radius: 2px;
}
.modal label {
  color: #000;
  font-weight: bold;
}
.modal input {
  background-color: #ffffff;
  color: #4d4d4d;
  box-sizing: border-box;
}
.modal-fade-enter,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.5s ease;
}

.danger {
  color: #dd6600;
  font-size: medium;
}

.modal-style {
  padding-right: 30px;
  padding-left: 30px;
}

.modal-body p {
  font-size: 17px;
  color: rgba(0, 0, 0, 0.534);
}
.boxshadow {
  -moz-box-shadow: 3px 3px 5px #535353;
  -webkit-box-shadow: 3px 3px 5px #535353;
  box-shadow: 3px 3px 5px #535353;
}
.roundbox {
  -moz-border-radius: 6px 6px 6px 6px;
  -webkit-border-radius: 6px;
  border-radius: 6px 6px 6px 6px;
}
</style>
