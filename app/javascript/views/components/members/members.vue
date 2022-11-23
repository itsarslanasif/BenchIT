<template>
  <div>
    <div class="search_bar">
      <input
        class="
          searchbar
          shadow
          bg-neutral-900
          appearance-none
          border
          rounded
          w-full
          py-2
          px-3
          text-gray-700
          leading-tight
          focus:outline-none focus:shadow-outline
        "
        type="text"
        v-model="searchQuery"
        placeholder="Search by name"
      />
    </div>
    <div>
      <label class="w-40 mx-8">Account Type</label>
      <select v-model="account_type" class="w-40 mx-6 mb-8">
        <option value="all_types">All types</option>
        <option value="owners">Owners</option>
        <option value="admins">Admins</option>
        <option value="full_members">Full Members</option>
        <option value="guests">Guests</option>
        <option value="deactivated_accounts">Deactivated accounts</option>
        <option value="not_on_slack">Not on slack</option>
      </select>
    </div>
    <div class="loading" v-show="members.length == 0">
      <Spinner />
    </div>
    <div class="render-member-row">
      <div v-for="member in filterMember" :key="member.id">
        <member
          :name="member.username"
          :description="member.description"
          :img-url="member.image_url"
        />
      </div>
    </div>
  </div>
</template>

<script>
import member from './member.vue';
import axios from '../../../modules/axios';
import Spinner from '../../shared/spinner.vue';
export default {
  components: {
    member,
    Spinner,
  },
  mounted() {
    axios
      .get(`workspaces/${this.CurrentWorkspaceId}/profiles`, {
        params: {
          workspace: this.workspace,
          account_type: this.account_type,
        },
      })
      .then(response => {
        this.members = response.data.profiles;
      })
      .catch(error => {
        return error;
      });
  },
  watch: {
    account_type() {
      if (this.account_type) {
        axios
          .get(`workspaces/${this.CurrentWorkspaceId}/profiles`, {
            params: {
              workspace: this.workspace,
              account_type: this.account_type,
            },
          })
          .then(response => {
            this.members = response.data.profiles;
          })
          .catch(error => {
            return error;
          });
      }
    },
  },
  data() {
    return {
      searchQuery: '',
      members: [],
      search: '',
      CurrentWorkspaceId: 1,
      account_type: 'all_types',
    };
  },
  methods: {},
  computed: {
    filterMember: function () {
      return this.members.filter(m => {
        return (
          m.username.toLowerCase().match(this.searchQuery.toLowerCase()) ||
          m.description.toLowerCase().match(this.searchQuery.toLowerCase())
        );
      });
    },
  },
};
</script>

<style scoped>
.render-member-row {
  display: flex;
  justify-content: space-around;
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
  padding: 20px 35px;
}
.loading > img {
  width: 50px;
  height: 50px;
}
</style>
