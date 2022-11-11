<template>
  <transition name="modal-fade">
    <div class="modal-backdrop">
      <div
        class="modal"
        role="dialog"
        aria-labelledby="Channel Name"
        aria-describedby="Channel Description"
      >
        <header class="modal-header" id="modalTitle">
          <h1 name="header"> Create New Channel </h1>
          <button
            type="button"
            class="btn-close"
            @click="closeModal"
            aria-label="Close modal"
          >
            x
          </button>
        </header>

        <form @submit="onSubmit">
          <section class="modal-body" id="modalDescription">
            <label name="body"> Channel Name </label>
            <input
              class="form-control"
              type="text"
              v-model="form.channelName"
              required
            />
            <br />
            <label name="footer"> Channel Description </label>
            <input
              class="form-control"
              type="text"
              v-model="form.channelDesc"
            />
          </section>

          <footer class="modal-footer">
            <button type="submit"  class="btn btn-primary" :disabled="form.channelName === ''" @click="closeModal">Create</button>
          </footer>
        </form>
      </div>
    </div>
  </transition>
</template>
<script>
export default {
  name: "CreateChannel",
  data() {
    return {
      form: {
        channelName: "",
        channelDesc: "",
      },
    };
  },
  props: [
    "closeModal"
  ],
  methods: {
    onSubmit(event) {
      event.preventDefault();
      console.log(JSON.stringify(this.form));
    },
    close() {
      this.$emit("input", !this.value);
    },
  },
};
</script>
<style>
*{
  padding: 0;
  box-sizing: border-box;
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
}  

.modal {
  background: #ffffff;
  box-shadow: 2px 2px 20px 1px;
  overflow-x: auto;
  width: 30%;
}

.modal-header{
  padding: 15px;
  display: flex !important;;
}

.modal-header {
  max-height: 100px;
  border-bottom: 1px solid #eeeeee;
  align-items: center !important;;
  color:#000;
  justify-content: space-between !important;;
}
.modal-header p{
  color: #000;
  margin-top: 1.6rem !important;
  font-size: 20px;
  font-weight: 600;
}

.modal-header h1
{
  color: #000;
  font-size: 30px;
  margin-top: 3.3rem !important;

}
.modal-footer {
  border-top: 1px solid #eeeeee;
  flex-direction: column;
}
.modal-footer button{
  width: 200px;
  text-transform: none;
  margin:auto;
}
.modal-body {
  position: relative;
  padding: 10px 10px;
  margin:0;
}

.btn-close {
  border: none;
  font-size: 30px;
  cursor: pointer;
  font-weight: bold;
  color: #4aae9b;
  width: 40px;
  margin: 0px;
  padding: 0px;
  background: transparent;
}

.btn-green {
  color: white;
  background: #4aae9b;
  border: 1px solid #4aae9b;
  border-radius: 2px;
}
.modal label{
  color:#000;
  font-weight:400;
}
.modal input{
  background-color: #ffffff;
  color:#4d4d4d;
}
.modal-fade-enter,
.modal-fade-leave-to {
  opacity: 0;
}

.modal-fade-enter-active,
.modal-fade-leave-active {
  transition: opacity 0.5s ease;
}
</style>
