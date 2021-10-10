<template>
  <div>
    <p>
      {{ title }}
    </p>
    <v-btn @click="clickBtn">
      Click!
    </v-btn>
    <v-btn @click="oAuthLogin('Twitter')">
      TwitterLogin
    </v-btn>
    <v-btn @click="oAuthLogin('Google')">
      GoogleLogin
    </v-btn>
  </div>
</template>

<script lang="ts">
import { defineComponent, ref } from '@vue/composition-api'
import { userStore } from '~/plugins/store-accessor'
import { $axios } from '~/utils/api'

type Providers = "Google" | "Twitter"

export default defineComponent({
  setup() {
    console.log(userStore)
    const title = ref('Test')

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

    const clickBtn = async () => {
      const response = await $axios.get('/posts')
      title.value = response.data.posts[0].name
      console.log(response)
    }
    
    return {
      title, clickBtn, oAuthLogin
    }
  }
})
</script>
