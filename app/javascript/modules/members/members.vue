<template>
  <div>
    <div class="search_bar">
      <input
        class="searchbar"
        type="text"
        v-model="searchQuery"
        placeholder="Search by name"
      />
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
import axios from './axios';
import Spinner from '../../views/shared/spinner.vue';
export default {
  components: {
    member,
    Spinner,
  },
  mounted() {
    axios
      .get(`workspaces/${this.CurrentWorkspaceId}/profiles`, this.workspace)
      .then(response => {
        this.members = response.data.profiles;
      })
      .catch(error => {
        return error;
      });
  },
  data() {
    return {
      searchQuery: '',
      members: [],
      search: '',
      CurrentWorkspaceId: 1,
    };
  },
  methods: {},
  computed: {
    filterMember: function () {
      return this.members.filter(m => {
        return m.username.toLowerCase().match(this.searchQuery.toLowerCase());
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
  padding: 0px 35px;
}
.loading > img {
  width: 50px;
  height: 50px;
}
</style>
