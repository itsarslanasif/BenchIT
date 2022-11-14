<template>
  <div>
    <h3 class="form-h3">{{ $t("messages.tellUs")}}</h3>
    <label>What will your team use it for?</label>
    <select
      v-model="workspaceStore.workspace.workspace_type"
      class="form-input-select"
    >
      <option
        v-for="option in workspaceStore.workspace_type_options"
        :value="option.value"
        :key="option.value"
      >
        {{ option.text }}
      </option>
    </select>
    <label>What kind of company is it?</label>
    <select
      v-model="workspaceStore.workspace.organization_type"
      class="form-input-select"
    >
      <option
        v-for="option in workspaceStore.organization_type_options"
        :value="option.value"
        :key="option.value"
      >
        {{ option.text }}
      </option>
    </select>
    <label class="form-label">How big is your company?</label>
    <input
      v-model="workspaceStore.workspace.capacity"
      class="form-input-select"
      type="number"
      required
    />
    <div v-if="workspaceStore.capacityError" class="error">{{ workspaceStore.capacityError }}</div>
    <label>What is your role there?</label>
    <select
      v-model="workspaceStore.workspace.admin_role"
      class="form-input-select"
    >
      <option
        v-for="option in workspaceStore.admin_role_options"
        :value="option.value"
        :key="option.value"
      >
        {{ option.text }}
      </option>
    </select>
    <div
      class="image-preview-wrapper"
      :style="{
        'background-image': `url(${workspaceStore.workspace.workspace_avatar})`,
      }"
      @click="selectImage"
    />
    <input
      ref="fileInput"
      type="file"
      @input="pickFile"
      class="form-input-select"
    />
  </div>
</template>

<script>
import { WorkspaceStore } from '../../stores/workspace_store';
import './style.css';

export default {
  data() {
    return {
      workspaceStore: WorkspaceStore(),
    };
  },
  methods: {
    selectImage() {
      this.$refs.fileInput.click();
    },
    pickFile() {
      let input = this.$refs.fileInput;
      let file = input.files;
      if (file && file[0]) {
        let reader = new FileReader();
        reader.onload = e => {
          this.workspaceStore.workspace.workspace_avatar = e.target.result;
        };
        reader.readAsDataURL(file[0]);
        this.$emit('input', file[0]);
      }
    },
  },
};
</script>

<style scoped>
input::file-selector-button {
  background-color: black;
  border: 0;
  color: rgb(235, 229, 229);
  margin-left: 3px;
  padding: 10px 20px;
}
</style>
