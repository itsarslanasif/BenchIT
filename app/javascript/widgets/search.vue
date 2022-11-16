<template>
    <div class="flex items-center justify-center flex-col">
        <div class="w-1/2 flex">
            <div class="w-full" @click="searchModalToggle = true">
                <input type="text" placeholder="Search" class="text-center border-2 border-slate-800 rounded-t"
                    v-model="search" />
            </div>
            <div class="w-1/6 text-center" v-if="searchModalToggle" @click="searchModalToggle = false">
                <span class="inline-block align-middle pt-2">Close</span>
            </div>
        </div>
        <div v-if="searchModalToggle" class="w-1/2 bg-slate-900 text-center rounded-b">
            <div class="text-left p-6">
                <p class="mb-1 text-xs">I'm looking for:</p>
                <div class=" flex gap-2">
                    <button class="bg-slate-500 px-3 py-1 w-auto" @click="searchPeopleOnly">People</button>
                    <button class="bg-slate-500 px-3 py-1 w-auto" @click="searchChannelsOnly">Channels</button>
                </div>
                <div class="mt-6">
                    <div v-if="usersFlag">
                        <span class="py-1 w-auto text-xl font-semibold">People</span>
                    </div>
                    <div v-if="channelsFlag">
                        <span class="py-1 w-auto text-xl font-semibold">Channels</span>
                    </div>
                    <div v-for="item in filteredList" :key="item.id" class="hover:bg-slate-600 p-2 rounded">
                        <strong>{{ item.username }}</strong> <span class="text-sm">{{item.description}}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import { UserStore } from '../stores/users';
import { ChannelStore } from '../stores/channels';

export default {
    name: "SearchWidget",
    data() {
        return {
            searchModalToggle: false,
            search: '',
            filteredList: [],
            allUsers: [],
            allChannels: [],
            usersFlag: false,
            channelsFlag: false
        }
    },
    methods: {
        searchPeopleOnly() {
            this.usersFlag = true
            this.channelsFlag = false
            this.filteredList = this.allUsers
        },
        searchChannelsOnly() {
            this.usersFlag = false
            this.channelsFlag = true
            this.filteredList = this.allChannels
        },
        filterData() {
            this.filteredList = this.filteredList.filter((item) => item.name.toLowerCase().includes(this.search.toLowerCase()))
        }
    },
    watch: {
        search() {
            if (this.usersFlag) {
                this.filteredList = this.allUsers
            } else if (this.channelsFlag) {
                this.filteredList = this.allChannels
            } else {
                this.filteredList = [...this.allUsers, ...this.allChannels]
            }
            this.filterData()
        }
    },
    setup() {
        const users = UserStore()
        const channels = ChannelStore()
        return {
            allUsers: Object.values(users.getUsers),
            allChannels: Object.values(channels.getChannels),
        }
    }
}
</script>

<style scoped src="../entrypoints/application.scss">

</style>