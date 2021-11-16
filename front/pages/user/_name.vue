<template>
  <div>
    <nuxt-child v-if="!isParentPage" />
    <v-container v-else class="mt-5">
      <v-row v-if="user" no-gutters>
        <PopularPosts :click-type="'USER'" />
        <v-col cols="4">
          <PostFormUserSlideItem :item="user" :is-show-create-btn="true" />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, onMounted, ref, useRoute  } from '@nuxtjs/composition-api'

import PopularPosts from '~/components/index/PopularPosts.vue'
import PostFormUserSlideItem from '~/components/post/PostFormUserSlideItem.vue'
import User from '~/store/user'
import { $axios } from '~/utils/api'

export default defineComponent({
  components: {
    PopularPosts,
    PostFormUserSlideItem
  },
  setup() {
    const route = useRoute()

    const user = ref<User | null>(null)
    const loading = ref(true)

    /**
     * Computed
     */
    const isParentPage =  computed(() => {
      return route.value.name === 'user-name'
    })

    onMounted(async () => {
      await getUser()
    })

    const getUser = async () => {
      try {
        const res = await $axios.get(`/users/${route.value.params.name}`)
        if (res.data) {
          user.value = res.data.user
        }
      } catch (e) {

      } finally {
        loading.value = false
      }
    }

    return {
      user,
      isParentPage
    }
  }
})
</script>