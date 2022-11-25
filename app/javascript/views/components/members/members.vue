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
        v-model="query"
        placeholder="Search by name"
        @keyup.enter="searchQuery()"
      />
    </div>
    <div>
      <label class="w-50 mx-8">Sort</label>
      <select v-model="sort" class="w-48 mx-6 mb-8">
        <option value="">Most recommended</option>
        <option value="asc">A to Z</option>
        <option value="desc">Z to A</option>
      </select>
    </div>
    <div class="loading" v-show="members.length == 0">
      <Spinner />
    </div>
    <div class="render-member-row">
      <div v-for="member in members" :key="member.id">
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
   this.searchQuery()
  },
  data() {
    return {
      query: '',
      members: [],
      sort: '',
      CurrentWorkspaceId: 1,
    };
  },
  methods: {
    searchQuery() {
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
        })
        .catch(error => {
          return error;
        });
    },
  },
  watch: {
    sort() {
      if (this.sort) {
        this.searchQuery()
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
  padding: 20px 35px;
}
.loading > img {
  width: 50px;
  height: 50px;
}
</style>
