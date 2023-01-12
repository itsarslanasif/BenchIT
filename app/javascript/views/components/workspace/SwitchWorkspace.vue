<template>
  <div class="h-full">
    <div v-if="isError">
      <benchit-alert
        :errorMessage="$t('errors.something_went_wrong')"
        :success="false"
      />
    </div>
    <div class="flex flex-col mt-4 justify-center items-center">
      <span v-for="workspace in joinedWorkspacesArray" :key="workspace.id">
        <n-tooltip placement="right" trigger="hover">
          <template #trigger>
            <n-avatar
              @click="switchWorkspace(workspace.id)"
              class="my-1 cursor-pointer"
              :class="{
                'p-1 bg-info': isCurrentWorkspace(workspace.id),
              }"
              src="../../../assets/images/user.png"
            />
          </template>
          <span> {{ workspace.company_name }} </span>
        </n-tooltip>
      </span>
      <n-tooltip placement="right" trigger="hover">
        <template #trigger>
          <font-awesome-icon
            icon="fa-plus"
            class="cursor-pointer mt-2 p-3 text-white rounded hover:bg-slate-600 focus:outline-none"
          />
        </template>
        <span> {{ $t('workspaces.add_new_workspace') }} </span>
      </n-tooltip>
    </div>
  </div>
</template>

<script>
import { NAvatar, NTooltip } from 'naive-ui';
import { joinedWorkspaces } from '../../../api/workspaces/workspacesApi';
import { switchWorkspace } from '../../../api/switchWorkspace/switchWorkspace';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import benchitAlert from '../../widgets/benchitAlert.vue';

export default {
  components: { NAvatar, NTooltip, benchitAlert },
  data() {
    return {
      joinedWorkspacesArray: null,
      isError: false,
    };
  },
  setup() {
    const currentProfileStore = useCurrentProfileStore();
    const currentWorkspaceStore = useCurrentWorkspaceStore();
    return { currentProfileStore, currentWorkspaceStore };
  },
  async mounted() {
    this.joinedWorkspacesArray = await joinedWorkspaces();
  },
  methods: {
    isCurrentWorkspace(workspace_id) {
      const currentWorkspace = JSON.parse(
        sessionStorage.getItem('currentWorkspace')
      );
      return currentWorkspace?.id === workspace_id;
    },

    async switchWorkspace(workspace_id) {
      this.currentWorkspaceStore.switchingWorkspace = true;
      const response = await switchWorkspace(workspace_id);
      if (response) {
        sessionStorage.setItem(
          'currentWorkspace',
          JSON.stringify(response.workspace)
        );
        sessionStorage.setItem(
          'currentProfile',
          JSON.stringify(response.profile)
        );
        this.currentWorkspaceStore.setWorkspace(response.workspace);
        this.currentProfileStore.setProfile(response.profile);
        this.currentWorkspaceStore.switchingWorkspace = false;
      } else {
        this.isError = true;
      }
    },
  },
};
</script>
