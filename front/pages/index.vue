<template>
  <div>
    <TrendingToday />
    <v-row class="grey lighten-3" no-gutters>
      <PopularPosts />
      <TopCommunities />
    </v-row>
  </div>
</template>

<script lang="ts">
import { defineComponent } from '@vue/composition-api'
import TopCommunities from '~/components/indexes/TopCommunities.vue'
import TrendingToday from '~/components/indexes/TrendingToday.vue'
import PopularPosts from '~/components/indexes/PopularPosts.vue'

import { userStore } from '~/plugins/store-accessor'

export default defineComponent({
  components: {
    TrendingToday,
    PopularPosts,
    TopCommunities
  },
  setup() {
    console.log(userStore)
  }
})
</script>