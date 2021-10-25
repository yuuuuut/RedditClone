<template>
  <v-app>
    <Header />
    <v-main class="main">
      <v-container>
        <TrendingToday />
        <v-row no-gutters>
          <v-col cols="12">
            <div class="popular-title">Popular posts</div>
          </v-col>
          <Nuxt />
          <TopCommunities />
        </v-row>
      </v-container>
    </v-main>
  </v-app>
</template>

<script lang="ts">
import { defineComponent} from '@nuxtjs/composition-api'

import TopCommunities from '~/components/index/TopCommunities.vue'
import TrendingToday from '~/components/index/TrendingToday.vue'
import Header from '~/components/layout/Header.vue'

export default defineComponent({
  components: {
    TrendingToday,
    TopCommunities,
    Header
  },
})
</script>


<style lang="scss" scoped>
a {
  text-decoration: none;
  color: #000 !important;
}

.main {
  background-color: #dae0e6;
}

.popular-title {
  margin-bottom: 10px;
  font-size: 15px;
}

@media (min-width: 1264px) {
  .container {
    max-width: 1000px;
  }
}
</style>