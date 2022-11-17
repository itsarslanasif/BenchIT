<template>
  <section class="container">
    <div>
      <h3 @click="showModal = !showModal">Modal</h3>
      <div v-if="showModal" :style="modalStyle">
        <Modal :modalArray="modalArray" />
      </div>
    </div>
    <h1>{{ $t('pages.title') }}</h1>

    <p>
      <a href="/dead-link">{{ $t('pages.server_404') }}</a>
    </p>
    <p>
      <router-link to="/dead-link">{{ $t('pages.client_404') }}</router-link>
    </p>
    <p>
      <a @click.prevent="unauthorized" href="#">{{ $t('pages.server_401') }}</a>
    </p>
    <p>
      <a @click.prevent="crash" href="#">{{ $t('pages.server_500') }}</a>
    </p>
    <br />
    <p>
      <a href="/admin">{{ $t('pages.admin_link') }}</a>
    </p>
  </section>
</template>

<script>
import Modal from '../../widgets/modal.vue'

import { SampleStore } from '@/stores/sample_store'
import { UserStore } from '../../stores/users'
import { ChannelStore } from '../../stores/channels'
import { onMounted } from 'vue'

export default {
  components: {
    Modal
  },

  data() {
    return {
      showModal: false,
      modalArray: [
        {
          title: 'Invite People to Workspace',
          func: this.invitePeople
        },
        {
          title: 'Create a channel',
          func: this.createChannel
        },
        {
          title: 'Sign Out of Workspace',
          func: this.signOut
        }
      ],
      modalStyle: {
        marginBottom: 40,
      }
    }
  },

  setup() {
    SampleStore()
    const usersStore = UserStore()
    ChannelStore()
    onMounted(() => {
      usersStore.index()
    })
  },

  methods: {
    unauthorized() {
      this.$api.call(this.store.show('this-will-trigger-a-401'))
    },
    crash() {
      this.$api.call(this.store.show('this-will-trigger-a-500'))
    },
    signOut() {
      console.log('Signed Out')
    },
    createChannel() {
      console.log('Create Channel')
    },
    invitePeople() {
      console.log('Invite People')
    },
  }

}
</script>
