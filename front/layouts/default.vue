<template>
  <v-app>
    <Header />
    <v-main v-if="a" class="main">
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
    <v-main v-else class="main">
      <Nuxt />
    </v-main>
  </v-app>
</template>

<script lang="ts">
import { computed, defineComponent, useRoute} from '@nuxtjs/composition-api'

import TopCommunities from '~/components/index/TopCommunities.vue'
import TrendingToday from '~/components/index/TrendingToday.vue'
import Header from '~/components/layout/Header.vue'

export default defineComponent({
  components: {
    TopCommunities,
    TrendingToday,
    Header
  },
  setup() {
    const route = useRoute()

    const a = computed(() => {
      const r = route.value.path
      if (r === '/' ||
          r === '/new' ||
          r === '/hot' ||
          r === '/top'
      ) return true
      return false
    })

    return {
      a
    }
  }
})
</script>


<style lang="scss">
.v-menu__content {
  box-shadow: initial !important;
  border: 1px solid #dae0e6;
}

.v-overlay {
  transition: initial !important;
}

.v-menu {
  opacity: initial !important;
}

.v-menu-transition-enter-active {
  transition: initial !important;
}

.v-menu-transition-leave-active {
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