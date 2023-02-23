<template>
  <transition name="fade" appear>
    <div
      class="flex justify-center items-center z-10 left-0 right-0 top-0 bottom-0 fixed bg-opacity-25 bg-backgroundTransparent"
    >
      <div
        class="modal rounded-md w-2/5 h-2/5 shadow-md bg-white"
        role="dialog"
      >
        <div class="p-8">
          <header id="modalTitle" class="flex w-full">
            <div class="w-5/6 text-lg text-black-900">
              <h1>{{ $t('workspaces.add_new_workspace') }}</h1>
            </div>
            <button
              type="button"
              class="w-1/6 bg-none py-1 px-3 text-base float-right text-black-900 rounded"
              @click="closeModal"
            >
              {{ $t('actions.close') }}
            </button>
          </header>
          <div class="m-0 relative mt-5">
            <n-form :label-width="80" :model="formValue" :rules="rules">
              <n-form-item
                :label="$t('workspaces.new_workspace_title')"
                path="isRequired"
              >
                <n-input
                  v-model:value="formValue.workspaceName"
                  :maxlength="15"
                  :count-graphemes="countGraphemes"
                  show-count
                  :placeholder="$t('workspaces.new_name_placeholder')"
                />
              </n-form-item>
              <n-form-item
                class="mt-3"
                :label="$t('workspace.workspace_type')"
                path="isRequired"
              >
                <n-select
                  v-model:value="formValue.workspaceType"
                  :options="this.workspaceStoreOptions.workspace_type_options"
                />
              </n-form-item>
              <n-form-item
                class="mt-3"
                label="Please select organization type"
                path="isRequired"
              >
                <n-select
                  v-model:value="formValue.workspaceOrganizationType"
                  :options="workspaceStoreOptions.organization_type_options"
                />
              </n-form-item>
              <n-form-item
                class="mt-3"
                label="Please enter total workspace capacity"
                path="isRequired"
              >
                <n-input-number
                  v-model:value="formValue.workspaceCapacity"
                  clearable
                />
              </n-form-item>
              <n-form-item label="Enter URL" path="isRequired">
                <n-input
                  v-model:value="formValue.workspaceURL"
                  :maxlength="80"
                  :count-graphemes="countGraphemes"
                  show-count
                  :placeholder="$t('workspaces.new_url_placeholder')"
                />
              </n-form-item>
              <p v-if="error" class="mt-3 text-danger">{{ error }}</p>
              <n-form-item class="float-right">
                <n-button
                  @click="onSubmit"
                  class="bg-success text-white py-2 px-5 text-base float-right my-3 rounded"
                >
                  {{ $t('actions.create') }}
                </n-button>
              </n-form-item>
            </n-form>
          </div>
        </div>
      </div>
    </div>
  </transition>
</template>

<script>
import {
  NForm,
  NFormItem,
  NButton,
  NInput,
  NSwitch,
  NSpace,
  NSelect,
  NInputNumber,
} from 'naive-ui';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { CONSTANTS } from '../../../assets/constants';
import { WorkspaceStore } from '../../../stores/workspace_store';
import vClickOutside from 'click-outside-vue3';
import GraphemeSplitter from 'grapheme-splitter';

export default {
  components: {
    NForm,
    NFormItem,
    NButton,
    NInput,
    NSwitch,
    NSpace,
    NSelect,
    NInputNumber,
  },
  directives: {
    clickOutside: vClickOutside.directive,
  },
  props: ['closeModal'],
  data() {
    return {
      rules: {
        isRequired: {
          required: true,
        },
      },
      formValue: {
        workspaceName: '',
        workspaceType: '',
        workspaceOrganizationType: '',
        workspaceCapacity: '',
        workspaceURL: '',
      },
      error: '',
      status: 0,
      api_data: null,
    };
  },
  setup() {
    const workspaceStoreOptions = WorkspaceStore();
    const workspaceStore = useCurrentWorkspaceStore();
    const splitter = new GraphemeSplitter();
    return {
      workspaceStoreOptions,
      workspaceStore,
      countGraphemes: value => splitter.countGraphemes(value),
    };
  },
  methods: {
    onSubmit() {
      this.validations();
      if (!this.error) {
        this.workspaceStore
          .createWorkspace(
            this.formValue.workspaceName,
            this.formValue.workspaceType,
            this.formValue.workspaceOrganizationType,
            this.formValue.workspaceCapacity,
            this.formValue.workspaceURL
          )
          .then(response => {
            this.status = response.status;
            if (this.status === 200) {
              this.$router.push(`/join_workspace/${response.data.id}`);
            } else {
              this.error = response.data.message;
            }
          });
      }
    },
    validations() {
      const {
        workspaceName,
        workspaceType,
        workspaceOrganizationType,
        workspaceCapacity,
        workspaceURL,
      } = this.formValue;
      const requiredFields = [
        workspaceName,
        workspaceType,
        workspaceOrganizationType,
        workspaceCapacity,
        workspaceURL,
      ];
      const regex = /^[a-zA-Z0-9-_]+$/;
      const urlRegex =
        /^(http:\/\/|https:\/\/)?([a-zA-Z0-9]+\.)+[a-zA-Z]{2,}(\/\S*)?$/;

      if (requiredFields.some(field => field === '')) {
        this.error = CONSTANTS.FIELDS_REQUIRED_ERROR;
      } else if (!regex.test(workspaceName)) {
        this.error = CONSTANTS.WORKSPACE_NAME_INVALID_ERROR;
      } else if (workspaceCapacity <= 0) {
        this.error = CONSTANTS.WORKSPACE_CAPACITY_NEGATIVE_ERROR;
      } else if (!urlRegex.test(workspaceURL)) {
        this.error = CONSTANTS.WORKSPACE_WRONG_URL_ERROR;
      } else {
        this.error = '';
      }
    },
  },
};
</script>
