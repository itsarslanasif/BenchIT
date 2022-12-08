<template>
  <div>
    <h3>{{ $t('workspaces.title') }}</h3>
    <label>{{ $t('workspaces.usage') }}</label>
    <select
      v-model="workspaceStore.workspace.workspace_type"
      class="border"
    >
      <option
        v-for="option in workspaceStore.workspace_type_options"
        :key="option.value"
        :value="option.value"
      >
        {{ option.text }}
      </option>
    </select>
    <label>{{ $t('workspaces.company_type_info') }}</label>
    <select
      v-model="workspaceStore.workspace.organization_type"
      class="border"
    >
      <option
        v-for="option in workspaceStore.organization_type_options"
        :key="option.value"
        :value="option.value"
      >
        {{ option.text }}
      </option>
    </select>
    <label>{{ $t('workspaces.company_size_info') }}</label>
    <input
      v-model="workspaceStore.workspace.capacity"
      class="border"
      type="number"
      required
    />
    <div v-if="workspaceStore.capacityError" class="text-danger text-sm font-bold mt-2">
      {{ workspaceStore.capacityError }}
    </div>
    <label>{{ $t('workspaces.admin_role_type') }}</label>
    <select
      v-model="workspaceStore.workspace.admin_role"
      class="border"
    >
      <option
        v-for="option in workspaceStore.admin_role_options"
        :key="option.value"
        :value="option.value"
      >
        {{ option.text }}
      </option>
    </select>
    <div
      class="bg-no-repeat rounded-md border cursor-pointer block h-48 my-8 mx-auto w-full bg-contain bg-center"
      :style="{
        'background-image': `url(${workspaceStore.workspace.workspace_avatar})`,
      }"
      @click="selectImage"
    />
    <input
      ref="fileInput"
      type="file"
      class="border"
      @input="pickFile"
    />
  </div>
</template>

<script>
import { WorkspaceStore } from '../../../stores/workspace_store';

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
