<template>
  <v-app>
    <v-main>
      <v-container>
        <Nuxt />
      </v-container>
    </v-main>
  </v-app>
</template>

<script lang="ts">
import { defineComponent } from '@nuxtjs/composition-api'
import { userStore } from '../plugins/store-accessor'
import { $axios } from '../utils/api'

export default defineComponent({
  setup() {

    const setCurrentUser = () => {
      $axios.get('/account/me').then(response => {
        if (response.status !== 200) throw new Error('error')
        const currentUser = response.data.current_user
        userStore.setUser(currentUser)
      }).catch((e) => {
        console.error(e)
      })
    }

    setCurrentUser()
  }
})
</script>
