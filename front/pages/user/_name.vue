<template>
  <v-container>
    <v-row no-gutters>
      <PopularPosts />
      <TopCommunities />
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent } from '@vue/composition-api'

import PopularPosts from '~/components/index/PopularPosts.vue'
import TopCommunities from '~/components/index/TopCommunities.vue'

export default defineComponent({
  components: {
    PopularPosts,
    TopCommunities
  },
  setup() {
  }
})
</script>