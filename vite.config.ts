import { defineConfig } from 'vite'

import RubyPlugin from 'vite-plugin-ruby'
import vue from '@vitejs/plugin-vue'
import VueI18nPlugin from "@intlify/unplugin-vue-i18n/vite";


export default defineConfig({
    plugins: [
        RubyPlugin(),
        vue(),
        VueI18nPlugin({})
    ],
    server: {
        hmr: true
    },

})
