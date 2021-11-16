<template>
  <v-container>
    <TrendingToday />
    <v-row no-gutters>
      <PopularPosts :click-type="'ROOT'" />
      <TopCommunities />
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent } from '@vue/composition-api'

import PopularPosts from '~/components/index/PopularPosts.vue'
import TrendingToday from '~/components/index/TrendingToday.vue'
import TopCommunities from '~/components/index/TopCommunities.vue'

export default defineComponent({
  components: {
    PopularPosts,
    TrendingToday,
    TopCommunities
  },
  setup() {
  }
})
</script>