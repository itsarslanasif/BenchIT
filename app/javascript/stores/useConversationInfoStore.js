import { defineStore } from 'pinia';
import { getChannelInfo } from '../api/channels/channels';
import { getChannelMembers } from '../api/channels/channels';
import { CONSTANTS } from '../assets/constants';


export const useConversationInfoStore = defineStore('conversationInfoStore ', {
  state: () => ({
    conversationInfo: [],
    conversationMembers: [],
    selectedOption: 'about',
  }),

  getters: {
   getConversationInfo: state => state.conversationInfo,
  },

  actions: {
    async index(conversation_type, conversation_id) {
      switch (conversation_type) {
        case 'channels':
          try {
            this.conversationInfo = await getChannelInfo(conversation_id);
          } catch (e) {
            console.error(e);
          }
          break;
        case 'group':
          try {
            this.conversationInfo = await getGroupInfo(conversation_id);
          } catch (e) {
            console.error(e);
          }
          break;
        case 'direct-messages':
          try {
            this.conversationInfo = await getDMInfo(conversation_id);
          } catch (e) {
            console.error(e);
          }
          break;
        default:
          break;
      }
    },

    isAbout() {
      return this.selectedOption ===  CONSTANTS.ABOUT;
    },

    isIntegrations() {
      return this.selectedOption === CONSTANTS.INTEGRATIONS;
    },

    isMembers() {
      return this.selectedOption === CONSTANTS.MEMBERS;
    },

    isSettings() {
      return this.selectedOption === CONSTANTS.SETTINGS;
    },

    setSlectedOption(selectedOption) {
      return this.selectedOption = selectedOption;
    },

    async getConversationMembers(query) {
      try {
        this.conversationMembers = await getChannelMembers(query, this.conversationInfo.id);
      } catch(e){
        console.error(e)
      }
    }
 
  },
});
