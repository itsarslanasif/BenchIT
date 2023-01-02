import { defineStore } from 'pinia';

export const useUserProfileStore = defineStore('userProfileStore', {
  state: () => ({
    user_profile: {
      id: 1,
      display_name: 'Asad Tariq',
      avatar: 'http://127.0.0.1:5100/assets/images/user.png',
      title: 'Associate Software Engineer',
      isActive: true,
      status: {
        emoji: '💬',
        text: 'AFK',
      },
      localtime: '8:16 PM',
      contact_info: {
        email_address: 'alva@gmail.com',
        phone_number: '03088567481',
      },
      about_me: {
        skype: 'alva@gmail.com',
      },
    },
  }),

  actions: {
    setUserProfile(user_profile) {
      this.user_profile = user_profile;
    },
  },
});
