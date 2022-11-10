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
      <img src="./loading.gif"/>
    </div>
    <div class="row">
      <div v-for="member in filterMember" :key="member.id" class="col">
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
export default {
  components: {
    member,
  },
  mounted() {
    axios
      .get('profiles', this.workspace)
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
    };
  },
  methods: {},
  computed: {
    filterMember: function() {
      return this.members.filter(m => {
        return m.username.toLowerCase().match(this.searchQuery.toLowerCase());
      });
    },
  },
};
</script>

<style scoped>
.col {
  float: left;
  width: 20%;
  margin-top: 50px;
  margin-left: 50px;
}

/* Clear floats after the columns */
.row:after {
  content: '';
  display: table;
  clear: both;
}
.loading {
  width: 100%;
  display: flex;
  justify-content: center;
}
.search_bar{
  padding: 50px;
}
</style>
