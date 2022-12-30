<template>
  <div>
    <select
      v-model="option"
      class="dropDown"
      @change="emitDropDownSelection(option)"
    >
      <option value="copy_display_name">
        {{ $t('actions.copy_display_name') }}
      </option>
      <option value="View_files">{{ $t('actions.view_files') }}</option>
      <option value="copy_member_id">{{ $t('actions.copy_member_id') }}</option>
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
  beforeUnmount() {
    this.option = null;
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
