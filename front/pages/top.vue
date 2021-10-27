<template>
  <PopularPosts />
</template>

<script lang="ts">
import { defineComponent } from '@vue/composition-api'

import PopularPosts from '~/components/index/PopularPosts.vue'

export default defineComponent({
  components: {
    PopularPosts,
  },
  setup() {
  }
})
</script>