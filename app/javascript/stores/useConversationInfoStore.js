import { defineStore } from 'pinia';
import {useCurrentWorkspaceStore} from './useCurrentWorkspaceStore'
import { getChannelInfo, getDMInfo, getChannelMembers, getGroupInfo  } from '../api/channels/channels';
import { CONSTANTS } from '../assets/constants';


export const useConversationInfoStore = defineStore('conversationInfoStore ', {
  state: () => ({
    conversationInfo: [],
    conversationMembers: [],
    selectedOption: CONSTANTS.ABOUT,
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
        case 'groups':
          try {
            this.conversationInfo = await getGroupInfo(conversation_id);
          } catch (e) {
            console.error(e);
          }
          break;
        case 'profiles':
          try {
            this.conversationInfo = await getDMInfo(conversation_id, useCurrentWorkspaceStore().currentWorkspace.id);
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
