<template>
  <div>
    <div class="search_bar">
      <input
        class="searchbar shadow bg-neutral-900 appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
        type="text"
        v-model="query"
        placeholder="Search by name or role"
        @keyup.enter="searchQuery()"
      />
    </div>
    <filters
      v-if="!showProfile"
      @account_type="getAccountType"
      @sort_filter="getSortFilter"
    ></filters>

    <div class="loading" v-show="showSpinner">
      <Spinner />
    </div>

    <div
      class="justify-items-start aline_item_horizontally"
      v-show="members.length > 0"
    >
      <div class="render-member-row" style="min-width: 725px">
        <div v-for="member in members" :key="member.id">
          <member
            :name="member.username"
            :description="member.description"
            :img-url="member.image_url"
            @click="profileClickListener(member)"
          />
        </div>
      </div>
      <div class="ml-10" v-if="showProfile">
        <profile
          @exitProfileView="exitProfile"
          :username="this.selectedMember.username"
          :description="this.selectedMember.description"
          :img-url="this.selectedMember.image_url"
          :userId="this.selectedMember.user_id"
        ></profile>
      </div>
    </div>
    <div class="flex justify-center" v-show="members.length == 0">
      <p>No results</p>
    </div>
  </div>
</template>

<script>
import member from './member.vue';
import axios from '../../../modules/axios';
import Spinner from '../../shared/spinner.vue';
import filters from '../../widgets/filters.vue';
import profile from '../../widgets/profile.vue';
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
    };
  },
  methods: {
    searchQuery() {
      this.showSpinner = true;
      // this.users = UserStore().getUsers;
      console.log(this.users);
      axios
        .get(`workspaces/${this.CurrentWorkspaceId}/profiles`, {
          params: {
            workspace: this.workspace,
            query: this.query,
            sort: this.sort,
          },
        })
        .then(response => {
          this.members = response.data.profiles;
          this.showSpinner = false;
        })
        .catch(error => {
          return error;
        });
    },
    getAccountType(value) {
      console.log(value);
    },
    getSortFilter(value) {
      this.sort = value;
    },
    profileClickListener(member) {
      this.showProfile = true;
      this.selectedMember = member;
      console.log(this.selectedMember);
    },
    exitProfile(value) {
      this.showProfile = value;
      clipboard.writeText('Text to get copied');
    },
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

<style scoped>
.render-member-row {
  display: flex;
  flex-wrap: wrap;
  align-items: flex-start;
}
.loading {
  width: 100%;
  height: 100%;
  display: flex;
  justify-content: center;
}
.search_bar {
  padding: 0px 35px;
}
.loading > img {
  width: 50px;
  height: 50px;
}
.aline_item_horizontally {
  display: flex;
  align-items: top;
}
</style>
