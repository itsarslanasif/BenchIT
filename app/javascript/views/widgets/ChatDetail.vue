<template>
  <div v-if="selectedChat.id" class="p-4">
    <div
      @click="isProfile ? showUserProfile(selectedChat?.id) : null"
      class="flex"
      :class="isProfile && 'cursor-pointer'"
    >
      <span>
        <img
          v-if="isProfile"
          :src="selectedChat?.image_url"
          class="w-20 h-20 rounded mr-2 bg-slate-50"
        />
        <font-awesome-icon
          v-if="isChannel"
          :icon="selectedChat?.is_private ? 'fa-lock' : 'fa-hashtag'"
          class="p-3 rounded mr-2 bg-slate-50"
        />
        <div class="flex flex-row" v-if="isGroup">
          <span v-for="profile in selectedChat.profiles" :key="profile.id">
            <img
              :src="profile.image_url"
              class="w-20 h-20 rounded mr-2 bg-slate-50"
            />
          </span>
        </div>
        <div class="mt-3 flex flex-row text-black-600" v-if="isGroup">
          {{ $t('groups.group_chat_note') }}
          <div
            class="px-1"
            v-for="profile in selectedChat.profiles"
            :key="profile.id"
          >
            <a
              v-if="
                profile ===
                selectedChat.profiles[selectedChat.profiles.length - 1]
              "
              class="px-2"
            >
              and
            </a>
            <a
              @click="showUserProfile(profile.id)"
              class="text-info cursor-pointer bg-slate-50 p-1 rounded"
            >
              @{{ profile.username }}
            </a>
          </div>
        </div>
      </span>
      <span :class="isProfile && 'self-center'">
        <span>
          <div v-if="isProfile" class="flex font-semibold">
            {{ selectedChat?.username }}
            {{ isOwnChat ? $t('chat.you') : '' }}

            <span class="flex text-md mx-4 mt-1 break-words text-black-800">
              <span
                v-if="selectedChat?.is_active"
                class="bg-green-700 rounded-full border-green-700 border-2 h-3 w-3 relative"
              />
              <span
                v-else
                class="bg-white rounded-full border-black border-2 h-3 w-3 relative"
              />
            </span>
          </div>
          <p v-if="isChannel" class="font-semibold">
            {{ $t('chat.this_is_the_very_beginning') }}
            <font-awesome-icon
              v-if="isChannel"
              :icon="selectedChat?.is_private ? 'fa-lock' : 'fa-hashtag'"
              class="text-info mr-1 text-xs align-baseline"
            />
            <a class="text-info">{{ selectedChat?.name }}</a>
            {{ $t('chat.channel') }}
          </p>
        </span>
        <p v-if="isProfile">{{ selectedChat?.display_name }}</p>
        <p v-if="isChannel">
          <a
            @click="showUserProfile(selectedChat?.creator_id)"
            class="text-info cursor-pointer bg-slate-50 p-1 rounded"
          >
            @{{ selectedChat?.creator_name }}
          </a>
          {{ $t('chat.created_this_channel_on') }}
          <a> {{ formatDate(selectedChat?.created_at) }}</a>
        </p>
        <span class="flex">
          <p class="text-black-600 mr-2">
            {{ selectedChat?.description }}
          </p>
          <p
            v-if="isChannel && !selectedChat?.is_private"
            class="text-info cursor-pointer hover:underline"
          >
            {{ $t('chat.edit_description') }}
          </p>
        </span>
        <p>
          <AddPeopleToChannel
            v-if="isChannel"
            :channelName="selectedChat?.name"
            :buttonText="$t('chat.add_people')"
          />
        </p>
      </span>
    </div>
    <p v-if="isProfile && isOwnChat" class="mt-2 text-black-600">
      <b>{{ $t('chat.this_space_is_just_for_you') }}</b>
      {{ $t('chat.own_chat_description') }}
    </p>
    <p v-if="isProfile && !isOwnChat" class="mt-2 text-black-600">
      {{ $t('chat.this_conversation_is_between_two_of_you') }}
      <a
        @click="showUserProfile(selectedChat?.id)"
        class="text-info cursor-pointer bg-slate-50 rounded p-1"
        >@{{ selectedChat?.username }}</a
      >
    </p>
  </div>
</template>

<script>
import { storeToRefs } from 'pinia';
import { useMessageStore } from '../../stores/useMessagesStore';
import moment from 'moment';
import { useCurrentProfileStore } from '../../stores/useCurrentProfileStore';
import { useRightPaneStore } from '../../stores/useRightPaneStore';
import { useUserProfileStore } from '../../stores/useUserProfileStore';
import { useProfileStore } from '../../stores/useProfileStore';
import AddPeopleToChannel from '../components/channels/AddPeopleToChannel.vue';

export default {
  components: { AddPeopleToChannel },
  data() {
    return {
      conversation_type: window.location.pathname.split('/')[1],
    };
  },
  setup() {
    const messagesStore = useMessageStore();
    const currentProfileStore = useCurrentProfileStore();
    const rightPaneStore = useRightPaneStore();
    const userProfileStore = useUserProfileStore();
    const profilesStore = useProfileStore();
    const { currentProfile } = storeToRefs(currentProfileStore);
    const { selectedChat } = storeToRefs(messagesStore);
    return {
      selectedChat,
      currentProfile,
      rightPaneStore,
      userProfileStore,
      profilesStore,
    };
  },
  computed: {
    isChannel() {
      return this.conversation_type === 'channels';
    },
    isProfile() {
      return this.conversation_type === 'profiles';
    },
    isGroup() {
      return this.conversation_type === 'groups';
    },
    isOwnChat() {
      return this.currentProfile?.id === this.selectedChat?.id;
    },
  },
  methods: {
    formatDate(date) {
      return moment(date).format('MMMM Do, YYYY');
    },
    showUserProfile(profile_id) {
      this.setUserProfileForPane(profile_id);
      this.rightPaneStore.toggleUserProfileShow(true);
    },
    setUserProfileForPane(profile_id) {
      const profile = this.profilesStore.profiles.find(
        profile => profile.id === profile_id
      );
      this.userProfileStore.setUserProfile(profile);
    },
  },
};
</script>
