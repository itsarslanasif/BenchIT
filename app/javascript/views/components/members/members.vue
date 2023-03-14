<template>
  <div>
    <ProfileSortFilter :handleSubmit="searchQuery" :members="members" />
    <div class="justify-center flex h-full w-full" v-if="showSpinner">
      <Spinner />
    </div>
    <div class="justify-items-start flex align-top" v-if="members.length > 0">
      <div class="mx-4 items-start flex-wrap flex">
        <div v-for="member in members" :key="member.id">
          <member :profile="member" @click="showUserProfile(member.id)" />
        </div>
      </div>
    </div>
    <div class="flex justify-center" v-if="members.length == 0">
      <p>{{ $t('filters.no_results_found') }}</p>
    </div>
  </div>
</template>

<script>
import member from './member.vue';
import Spinner from '../../shared/spinner.vue';
import filters from '../../widgets/filters.vue';
import profile from '../../widgets/profile.vue';
import { useUserProfileStore } from '../../../stores/useUserProfileStore';
import { useRightPaneStore } from '../../../stores/useRightPaneStore';
import { mapActions } from 'pinia';
import { CONSTANTS } from '../../../assets/constants';
import { getMembers } from '../../../api/members/membersApi';
import { useProfileStore } from '../../../stores/useProfileStore';
import ProfileSortFilter from '../../widgets/profileSort&filter.vue';
import { useCurrentWorkspaceStore } from '../../../stores/useCurrentWorkspaceStore';
import { ref } from 'vue';
import { errorHandler } from '../../widgets/messageProvider';

export default {
  props: ['filterComponentData'],
  components: {
    member,
    Spinner,
    filters,
    profile,
    ProfileSortFilter,
  },
  setup() {
    const profilesStore = useProfileStore();
    const { currentWorkspace } = useCurrentWorkspaceStore();
    return {
      profilesStore,
      currentWorkspace,
    };
  },
  mounted() {
    this.searchQuery();
  },
  data() {
    return {
      query: '',
      members: ref([]),
      sort: '',
      showProfile: false,
      selectedMember: '',
      showSpinner: true,
      CONSTANTS: CONSTANTS,
    };
  },
  beforeUnmount() {
    this.members = this.query = this.sort = this.selectedMember = null;
  },
  methods: {
    async searchQuery(query, sort) {
      try {
        this.members = await getMembers(this.currentWorkspace.id, query, sort);
        this.showSpinner = false;
      } catch (e) {
        errorHandler(e.response.data.message)(e);
      }
    },
    setUserProfileForPane() {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === this.currMessage.sender_id
      );
      this.userProfileStore.setUserProfile(profile);
    },
    async showUserProfile(member_id) {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === member_id
      );
      this.setUserProfile(profile);
      this.toggleUserProfileShow(true);
    },

    ...mapActions(useRightPaneStore, ['toggleUserProfileShow']),

    ...mapActions(useUserProfileStore, ['setUserProfile']),
  },
};
</script>
