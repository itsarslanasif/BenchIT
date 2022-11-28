<template>
  <div>
    <select
      v-model="option"
      class="dropDown"
      @change="emitDropDownSelection(option)"
    >
      <option value="copy_display_name">Copy display name</option>
      <option value="View_files">View Files</option>
      <option value="copy_member_id">Copy member ID</option>
    </select>
  </div>
</template>

<script>
export default {
  components: {},
  data() {
    return {
      option: '',
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
