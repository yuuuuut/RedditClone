<template>
  <v-app>
    <Header />
    <v-main class="main">
      <Nuxt />
    </v-main>
  </v-app>
</template>

<script lang="ts">
import { defineComponent} from '@nuxtjs/composition-api'

import Header from '~/components/layout/Header.vue'

export default defineComponent({
  components: {
    Header
  },
})
</script>


<style lang="scss">
.v-overlay {
  transition: initial !important;
}

a {
  text-decoration: none;
  color: #000 !important;
}
</style>

<style lang="scss" scoped>
.main {
  background-color: #dae0e6;
}
</style>