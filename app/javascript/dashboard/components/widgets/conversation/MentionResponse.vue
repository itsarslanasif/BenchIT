<template>
  <mention-box :items="items" @mention-select="handleMentionClick" />
</template>

<script>
import { mapGetters } from 'vuex';
import MentionBox from '../mentions/MentionBox.vue';

export default {
  components: { MentionBox },
  props: {
    searchKey: {
      type: String,
      default: '',
    },
  },
  computed: {
    ...mapGetters({
      contacts: 'contacts/getContacts',
    }),
    items() {
      return this.contacts.map(contact => ({
        label: contact.name,
        key: contact.id,
        image: contact.thumbnail,
      }));
    },
  },
  watch: {
    searchKey() {
      this.fetchContacts();
    },
  },
  mounted() {
    this.fetchContacts();
  },
  methods: {
    fetchContacts() {
      this.$store.dispatch('contacts/getContacts', {
        searchKey: this.searchKey,
      });
    },
    handleMentionClick(item = {}) {
      this.$emit('click', item.label);
    },
  },
};
</script>
