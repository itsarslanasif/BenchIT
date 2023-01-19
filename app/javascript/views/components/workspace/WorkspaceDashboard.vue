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
      <div class="flex gap-2">
        <input
          type="text"
          v-model="workspaceURL"
          class="border p-3 w-3/4 rounded"
          :placeholder="$t('placeholder.enter_workspace_url')"
        />
        <button
          class="w-1/4 bg-primary text-white rounded duration-200 hover:bg-primaryHover"
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
import { joinedWorkspaces } from '../../../api/workspaces/workspacesApi';
import { switchWorkspace } from '../../../api/switchWorkspace/switchWorkspace';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { useCurrentProfileStore } from '../../../stores/useCurrentProfileStore';
import { encryption } from '../../../modules/crypto/crypto';
export default {
  data() {
    return {
      joinedWorkspaces: [],
      workspaceURL: '',
    };
  },
  async mounted() {
    try {
      this.joinedWorkspaces = await joinedWorkspaces();
    } catch (e) {
      console.error(e);
    }
  },
  setup() {
    const currentWorkspace = useCurrentWorkspaceStore();
    const currentProfile = useCurrentProfileStore();
    return {
      currentWorkspace,
      currentProfile,
    };
  },
  methods: {
    createWorkspace() {
      this.$router.push('/new_workspace');
    },
    async goToWorkspaceDashboard(workspace) {
      let currentProfile = await switchWorkspace(workspace.id);
      encryption(sessionStorage, 'currentProfile', currentProfile.profile)
      encryption(sessionStorage, 'currentWorkspace', workspace)
      this.currentWorkspace.setWorkspace(workspace);
      this.currentProfile.setProfile(currentProfile);
      this.$router.push('/');
    },
  },
};
</script>
