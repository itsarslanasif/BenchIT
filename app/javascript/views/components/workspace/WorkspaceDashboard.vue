<template>
  <div class="flex justify-center">
    <div class="flex flex-col m-4 content-center">
      <header class="p-4 text-center">
        <div class="left-col"></div>
        <div class="center-col">
          <a href="#" class="text-3xl font-semibold">
            {{ $t('project.title') }}
          </a>
        </div>
      </header>
      <div class="text-center text-5xl mb-4 font-semibold">
        {{ $t('workspace.sign_in_to_your_workspace') }}
      </div>
      <div v-if="alert" class="mb-8">
        <n-alert type="error">
          {{ $t('workspace.workspace_not_found') }}
        </n-alert>
      </div>
      <div v-if="showCreateWorkspace">
        <CreateWorkspace :close-modal="closeNewWorkspaceModal" />
      </div>
      <div class="flex gap-2">
        <input
          type="text"
          v-model="workspaceURL"
          class="border p-3 w-3/4 rounded"
          :placeholder="$t('placeholder.enter_workspace_url')"
        />
        <button
          class="w-1/4 bg-primary text-white rounded duration-200 hover:bg-primaryHover"
          @click="goToWorkspace"
        >
          {{ $t('actions.continue') }}
        </button>
      </div>
      <div class="text-sm py-5 flex gap-1">
        <div>
          {{ $t('workspace.new_workspace_tagline') }}
        </div>
        <div
          class="text-info cursor-pointer hover:underline hover:text-infoHover"
          @click="createWorkspace"
        >
          {{ $t('workspace.create_new_workspace') }}
        </div>
      </div>
      <div class="font-bold">
        {{ $t('workspace.launch_workspace') }}
      </div>
      <div>
        <div
          v-for="workspace in joinedWorkspaces"
          :key="workspace"
          class="my-3"
        >
          <div class="flex p-4 rounded-md justify-between bg-slate-50">
            <div>
              <div class="font-bold">
                {{ workspace.company_name }}
              </div>
              <div class="text-sm">
                {{ workspace.bench_it_url }}
              </div>
            </div>
            <div
              class="items-end self-center py-2 px-4 rounded border-primary border hover:text-white hover:bg-primary duration-200 cursor-pointer"
              @click="goToWorkspaceDashboard(workspace)"
            >
              {{ $t('actions.open') }}
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import CreateWorkspace from './CreateWorkspace.vue';
import { switchWorkspace } from '../../../api/workspaces/workspacesApi';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { useWorkspaceStore } from '../../../stores/useWorkspaceStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { encryption } from '../../../modules/crypto/crypto';
import { setActiveStatus } from '../../../api/profiles/profileStatus';
import { NAlert } from 'naive-ui';
import { storeToRefs } from 'pinia';

export default {
  data() {
    return {
      joinedWorkspaces: [],
      workspaceURL: '',
      alert: false,
      showCreateWorkspace: false,
    };
  },
  components: {
    CreateWorkspace,
    NAlert,
  },
  setup() {
    const currentWorkspace = useCurrentWorkspaceStore();
    const currentProfile = useCurrentProfileStore();
    const workspaceStore = useWorkspaceStore();
    workspaceStore.index();
    const { joinedWorkspaces } = storeToRefs(workspaceStore);
    return {
      currentWorkspace,
      currentProfile,
      workspaceStore,
      joinedWorkspaces,
    };
  },
  methods: {
    createWorkspace() {
      this.showCreateWorkspace = true;
    },
    async goToWorkspaceDashboard(workspace) {
      const { id: workspaceId } = workspace;
      let { profile } = await switchWorkspace(workspaceId);
      profile.is_active = true;
      await setActiveStatus(workspaceId, profile.id);

      encryption(sessionStorage, 'currentProfile', profile);
      encryption(sessionStorage, 'currentWorkspace', workspace);

      this.currentWorkspace.setWorkspace(workspace);
      this.currentProfile.setProfile({ profile });

      this.$router.push('/');
    },
    findWorkspace() {
      return (
        this.joinedWorkspaces.find(
          workspace => workspace.bench_it_url === this.workspaceURL
        ) || null
      );
    },
    goToWorkspace() {
      const workspace = this.findWorkspace();
      workspace ? this.goToWorkspaceDashboard(workspace) : (this.alert = true);
    },
    closeNewWorkspaceModal() {
      this.showCreateWorkspace = false;
    },
  },
};
</script>
