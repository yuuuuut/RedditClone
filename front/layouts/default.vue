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
import { userStore } from '@/plugins/store-accessor'

export default defineComponent({
  setup() {

    const setCurrentUser = () => {
      userStore.getCurrentUser()
    }

    setCurrentUser()
  }
})
</script>
