<template>
  <div>
    <TrendingToday />
    <v-row no-gutters>
      <v-col cols="12">
        <div class="popular-title">Popular posts</div>
      </v-col>
      <PopularPosts />
      <TopCommunities />
    </v-row>
  </div>
</template>

<script lang="ts">
import { defineComponent } from '@vue/composition-api'
import TopCommunities from '~/components/index/TopCommunities.vue'
import TrendingToday from '~/components/index/TrendingToday.vue'
import PopularPosts from '~/components/index/PopularPosts.vue'

export default defineComponent({
  components: {
    TrendingToday,
    PopularPosts,
    TopCommunities
  },
  setup() {
  }
})
</script>

<style lang="scss" scoped>
.popular-title {
  margin-bottom: 10px;
  font-size: 15px;
}
</style>