<template>
  <div
    class="max-w-lg text-white border-solid border border-slate-200 w-auto h-auto bg-slate-1000"
  >
    <div
      class="px-5 border-solid border border-slate-200 justify-items-start flex items-center"
    >
      <p class="text-base font-bold text-white">{{ CONSTANTS.PRPFILE }}</p>
      <p
        class="font-bold ml-auto flex text-white cursor-pointer"
        @click="exitClicked"
      >
        X
      </p>
    </div>
    <div
      class="card min-w-sm text-gray-50 transition-shadow shadow-xl hover:shadow-xl min-w-max"
    >
      <div
        class="w-full card__media flex flex-col-reverse content-end justify-center items-center"
      >
        <img
          src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
          class="h-45 w-40 rounded-lg"
        />
      </div>
      <div class="mt-5">
        <p id="username" class="text-base font-bold text-white">
          {{ username }}
        </p>
        <p class="text-sm font-light text-white">{{ description }}</p>
      </div>
      <div class="mt-5 justify-items-start flex items-center">
        <div
          class="h-2 w-2 border-white border border-solid rounded-md bg-green-700 items-center"
        ></div>
        <p class="text-xs ml-3 font-light text-white">Active</p>
      </div>
      <div class="justify-items-start flex items-center">
        <p class="text-xs font-light">&#128338;</p>
        <p class="text-xs ml-2 font-light text-white">6:10 AM</p>
        <p class="text-xs ml-1 font-light text-white">Local Time</p>
      </div>

      <div class="justify-items-start mt-3 flex items-center">
        <button
          class="button hover:bg-slate-800 border-slate-200 border border-solid mr-1"
        >
          &#x2709; {{ CONSTANTS.MESSAGE }}
        </button>
        <button
          class="button hover:bg-slate-800 border-slate-200 border border-solid mr-1"
        >
          &#x1F3A7; {{ CONSTANTS.HUDDLE }}
        </button>
        <dropdownVue @dropDownOption="dropDownOptionSelected" />
      </div>
      <div class="bg-slate-200 h-px w-full mt-5"></div>

      <div class="font-bold mt-2">{{ CONSTANTS.CONTACT_INFORMATION }}</div>
      <div class="mt-5 hover-trigger justify-items-start flex items-center">
        <div
          class="bg-gray-600 rounded h-8 w-8 flex flex-col-reverse mr-5 content-end justify-center items-center"
        >
          &#x2709;
        </div>
        <div class="text-xs font-light">
          <div>{{ CONSTANTS.EMAIL_ADDRESS }}</div>
          <div id="email" class="blue_text">asad@gmail.com</div>
        </div>
        <div
          @click="copyEmail"
          class="bg-gray-600 rounded h-8 w-8 flex flex-col-reverse ml-10 hover-target ml-auto flex content-end justify-center items-center"
        >
          &#x2398;
        </div>
      </div>

      <div class="mt-5 hover-trigger justify-items-start flex items-center">
        <div
          class="bg-gray-600 rounded h-8 w-8 flex flex-col-reverse mr-5 content-end justify-center items-center"
        >
          &phone;
        </div>
        <div class="text-xs group font-light">
          <div>{{ CONSTANTS.PHONE }}</div>
          <div id="phoneNo" class="blue_text">03315687779</div>
        </div>
        <div
          @click="copyPhoneNo"
          class="bg-gray-600 rounded h-8 w-8 flex flex-col-reverse ml-10 hover-target ml-auto flex content-end justify-center items-center"
        >
          &#x2398;
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import dropdownVue from './dropdown.vue';
import { CONSTANTS } from '../../assets/constants';
export default {
  components: { dropdownVue },
  props: ['username', 'description', 'img-url', 'userId'],
  data() {
    return {
      CONSTANTS: CONSTANTS,
    };
  },
  methods: {
    exitClicked() {
      this.$emit('exitProfileView', false);
    },
    dropDownOptionSelected(value) {
      switch (value) {
        case 'copy_display_name':
          let element = document.getElementById('username');
          this.copyTextClipBoard(element.textContent);
          break;
        case 'copy_member_id':
          this.copyTextClipBoard(this['userId']);
          break;
        default:
      }
    },
    copyEmail() {
      let element = document.getElementById('email');
      this.copyTextClipBoard(element.textContent);
    },
    copyPhoneNo() {
      let element = document.getElementById('phoneNo');
      this.copyTextClipBoard(element.textContent);
    },
    copyTextClipBoard(text) {
      navigator.clipboard.writeText(text).then(function (x) {
        alert('Copied to clipboard: ' + text);
      });
    },
  },
};
</script>

<style scoped>
.button {
  width: 300px;
  height: 35px;
}
.blue_text {
  color: rgb(122, 122, 252);
}
.hover-trigger .hover-target {
  display: none;
}
.hover-trigger:hover .hover-target {
  display: flex;
  cursor: pointer;
}
</style>
