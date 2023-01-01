<template>
  <div>
    <div class="py-5 px-8">
      <input
        class="searchbar shadow bg-neutral-900 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        type="text"
        v-model="query"
        :placeholder="$t('members.search_by_name')"
        @keyup.enter="searchQuery()"
      />
    </div>
    <filters v-if="!showProfile" @sort_filter="getSortFilter"></filters>

    <div class="justify-center flex h-full w-full" v-if="showSpinner">
      <Spinner />
    </div>
    <div class="justify-items-start flex align-top" v-if="members.length > 0">
      <div
        class="render-member-row items-start flex-wrap flex"
        style="min-width: 725px"
      >
        <div v-for="member in members" :key="member.id">
          <member
            :name="member.username"
            :description="member.description"
            :img-url="member.image_url"
            @click="toggleUserProfileShow(true)"
          />
        </div>
      </div>
    </div>
    <div class="flex justify-center" v-if="members.length == 0">
      <p>{{ CONSTANTS.NO_RESULT_FOUND }}</p>
    </div>
    <div v-if="members.length == 0 && query == ''">
      {{ searchQuery() }}
    </div>
  </div>
</template>

<script>
import member from './member.vue';
import Spinner from '../../shared/spinner.vue';
import filters from '../../widgets/filters.vue';
import profile from '../../widgets/profile.vue';
import {useRightPaneStore} from '../../../stores/useRightPaneStore'
import { mapActions } from 'pinia';
import { CONSTANTS } from '../../../assets/constants';
import { getMembers } from '../../../api/members/membersApi';
export default {
  props: ['filterComponentData'],
  components: {
    member,
    Spinner,
    filters,
    profile,
  },
  mounted() {
    this.searchQuery();
  },
  data() {
    return {
      query: '',
      members: [],
      sort: '',
      CurrentWorkspaceId: 1,
      users: [],
      showProfile: false,
      selectedMember: '',
      showSpinner: true,
      CONSTANTS: CONSTANTS,
    };
  },
  beforeUnmount() {
    this.members =
      this.query =
      this.sort =
      this.users =
      this.selectedMember =
        null;
  },
  methods: {
    async searchQuery() {
      try {
        this.members = await getMembers(
          this.CurrentWorkspaceId,
          this.query,
          this.sort
        );
        this.showSpinner = false;
      } catch (e) {
        console.error(e);
      }
    },
    getSortFilter(value) {
      this.sort = value;
    },
    ...mapActions(useRightPaneStore,['toggleUserProfileShow'])
  },
  watch: {
    sort() {
      if (this.sort) {
        this.searchQuery();
      }
    },
  },
};
</script>
