<template>
  <div>
    <TrendingToday />
    <v-row class="grey lighten-3" no-gutters>
      <v-col cols="8" style="background-color: #FFCDD2">
        column 1
      </v-col>
      <v-col cols="4" style="background-color: #FFCDD2">
        column 1
      </v-col>
    </v-row>
    <v-btn @click="oAuthLogin('Twitter')">
      TwitterLogin
    </v-btn>
    <v-btn @click="oAuthLogin('Google')">
      GoogleLogin
    </v-btn>
  </div>
</template>

<script lang="ts">
import { defineComponent } from '@vue/composition-api'
import TrendingToday from '~/components/indexes/TrendingToday.vue'

import { userStore } from '~/plugins/store-accessor'
import { Providers } from '~/store/user'

export default defineComponent({
  components: {
    TrendingToday
  },
  setup() {
    console.log(userStore)

    const oAuthLogin = (provider: Providers) => {
      switch (provider) {
        case "Google":
          location.href = 'http://127.0.0.1:3000/api/v1/auth/google_oauth2'
          break
        case "Twitter":
          location.href = 'http://127.0.0.1:3000/api/v1/auth/twitter'
          break
      }
    }
    
    return {
      oAuthLogin
    }
  }
})
</script>
