<template>
  <div>
    <button
      class="text-indigo-500 font-bold focus:outline-none z-10"
      @click="open = true"
    >
      <i class="fas fa-user-plus"></i>
    </button>

    <div
      class="inset-0 overflow-y-auto"
     
    >
      <transition
        name="modal"
        :duration="{ enter: 100, leave: 100 }"
      >
        <div
          class="relative flex flex-col w-full max-w-md mt-10 mx-auto bg-white rounded-lg shadow-lg outline-none focus:outline-none"
          v-if="open"
        >
          <div class="relative flex flex-col w-full px-6 py-4">
            <h3 class="text-2xl font-semibold text-gray-800">
              {{ title }}
            </h3>

            <multiselect
              v-model="selectedOptions"
              :options="options"
              :multiple="true"
              :taggable="true"
              :custom-label="customLabel"
              :close-on-select="false"
              :clear-on-select="false"
              :preserve-search="true"
              @search-change="searchOptions"
            >
            </multiselect>

            <div class="flex items-center justify-end mt-3">
              <button
                class="text-sm font-semibold bg-indigo-500 hover:bg-indigo-700 text-white py-2 px-4 rounded-lg focus:outline-none focus:shadow-outline"
                @click="submit"
              >
                Submit
              </button>
            </div>
          </div>
        </div>
      </transition>
    </div>
  </div>
</template>
<script>
import Multiselect from "vue-multiselect";
import { library } from "@fortawesome/fontawesome-svg-core";
import { fas } from "@fortawesome/free-solid-svg-icons";
import {getMembers} from '../../../api/members/membersApi'

library.add(fas);

export default {
  name: "Modal",
  components: {
    Multiselect,
  },
  props: {
    open: {
      type: Boolean,
      default: false,
    },
    title: {
      type: String,
      default: "Modal",
    },
  },
  data() {
    return {
      searchTerm: "",
      selectedOptions: [],
      options: [],
    };
  },
  methods: {
    customLabel(option) {
      return `${option.label}`;
    },
    async searchOptions(search) {
      this.searchTerm = search;

      const results = await getMembers(1,this.searchTerm);
      this.options = results;
    },
    removeOption(index) {
      this.selectedOptions.splice(index, 1);
    },
    submit() {
      this.$emit("submit", this.selectedOptions);
      this.open = false;
    },
  },
};
</script>
