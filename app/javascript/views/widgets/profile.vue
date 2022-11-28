<template>
  <div class="profile_container">
    <div class="px-5 header justify-items-start aline_item_horizontally">
      <p class="font-bold text-white ">{{CONSTANTS.PRPFILE}}</p>
      <p class="font-bold right text-white  cursor-pointer" @click="exitClicked">X</p>
    </div>
    <div
      class="card min-w-sm text-gray-50 transition-shadow shadow-xl hover:shadow-xl min-w-max"
    >
      <div class="w-full card__media flex">
        <img
          src="https://i.pinimg.com/736x/55/0f/49/550f49a459548599a5a4ea1c67fc0244.jpg"
          class="h-45 w-40 rounded-lg"
        />
      </div>
      <div class="mt-5">
        <p id="username" class="font-bold text-white  ">{{ username }}</p>
        <p class="text-sm font-light text-white ">{{ description }}</p>
      </div>
      <div class="mt-5 justify-items-start aline_item_horizontally">
        <div class="active_tag items-center"></div>
        <p class="mt_8px ml-3 font-light text-white ">Active</p>
      </div>
      <div class="justify-items-start aline_item_horizontally">
        <p class="mt_8px font-light">&#128338;</p>
        <p class="mt_8px ml-2 font-light text-white ">6:10 AM</p>
        <p class="mt_8px ml-1 font-light text-white ">{{CONSTANTS.LOCAL_TIME}}</p>
      </div>

      <div class="justify-items-start mt-3 aline_item_horizontally">
        <button class="button mr-1">&#x2709; {{CONSTANTS.MESSAGE}}</button>
        <button class="button mr-1">&#x1F3A7; {{CONSTANTS.HUDDLE}}</button>
        <dropdownVue @dropDownOption="dropDownOptionSelected" />
      </div>
      <div class="separator mt-5"></div>

      <div class="font-bold mt-2">{{CONSTANTS.CONTACT_INFORMATION}}</div>
      <div
        class="mt-5 hover-trigger justify-items-start aline_item_horizontally"
      >
        <div class="icon_card flex mr-5">&#x2709;</div>
        <div class="mt_8px font-light">
          <div>{{CONSTANTS.EMAIL_ADDRESS}}</div>
          <div id="email" class="blue_text">asad@gmail.com</div>
        </div>
        <div @click="copyEmail" class="icon_card flex ml-10 hover-target right">
          &#x2398;
        </div>
      </div>

      <div
        class="mt-5 hover-trigger justify-items-start aline_item_horizontally"
      >
        <div class="icon_card flex mr-5">&phone;</div>
        <div class="mt_8px group font-light">
          <div>{{CONSTANTS.PHONE}}</div>
          <div id="phoneNo" class="blue_text">03315687779</div>
        </div>
        <div
          @click="copyPhoneNo"
          class="icon_card flex ml-10 hover-target right"
        >
          &#x2398;
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import dropdownVue from './dropdown.vue';
import {CONSTANTS} from '../../assets/constants'
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
.profile_container {
  width: auto;
  height: auto;
  max-width: 500px;
  background-color: #252d34;
  border: solid 0.1px rgb(146, 146, 146);
  color: white;
}
.flex {
  display: flex;
  flex-direction: column-reverse;
  align-content: flex-end;
  justify-content: center;
  align-items: center;
}
.aline_item_horizontally {
  display: flex;
  align-items: center;
}
.mt_8px {
  font-size: smaller;
}
.active_tag {
  width: 10px;
  height: 10px;
  background-color: rgb(0, 129, 22);
  border-radius: 50%;
  border: solid 1px white;
}
.button {
  width: 300px;
  height: 35px;
  border: solid 1px rgb(146, 146, 146);
}
.menuButton {
  width: 50px;
  height: 35px;
  border: solid 1px rgb(146, 146, 146);
}
.button:hover {
  background-color: #475569;
}
.menuButton:hover {
  background-color: #475569;
}
.separator {
  width: 100%;
  height: 1px;
  background-color: rgb(146, 146, 146);
}
.icon_card {
  height: 30px;
  width: 30px;
  border-radius: 10%;
  background-color: #475569;
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

.right {
  display: flex;
  margin-left: auto;
}
.header {
  border: solid 0.1px rgb(146, 146, 146);
}
</style>
