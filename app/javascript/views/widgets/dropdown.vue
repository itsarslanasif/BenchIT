<template>
  <div>
    <select
      v-model="option"
      class="dropDown"
      @change="emitDropDownSelection(option)"
    >
      <option value="copy_display_name">{{CONSTANTS.COPY_DISPLAY_NAME}}</option>
      <option value="View_files">{{CONSTANTS.VIEW_FILES}}</option>
      <option value="copy_member_id">{{CONSTANTS.COPY_MEMBER_ID}}</option>
    </select>
  </div>
</template>

<script>
import { CONSTANTS } from '../../assets/constants';
export default {

  components: {},
  data() {
    return {
      option: '',
      CONSTANTS: CONSTANTS,
    };
  },
  methods: {
    emitDropDownSelection() {
      this.$emit('dropDownOption', this.option);
    },
  },
};
</script>

<style scoped>
.dropDown {
  max-width: 20px;
  height: 35px;
  border-radius: 20%;
  border: solid 1px rgb(146, 146, 146);
  background-color: #252d34;
}
.dropDown:hover {
  background-color: #475569;
}
</style>
