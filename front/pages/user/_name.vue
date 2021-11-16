<template>
  <v-container class="mt-5">
    <v-row v-if="user" no-gutters>
      <PopularPosts :click-type="'USER'" />
      <v-col cols="4" style="background-color: #FFCDD2">
        <PostFormUserSlideItem :item="user" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { computed, defineComponent, onMounted, ref, useRoute  } from '@nuxtjs/composition-api'

import PopularPosts from '~/components/index/PopularPosts.vue'
import PostFormUserSlideItem from '~/components/post/PostFormUserSlideItem.vue'
import { userStore } from '~/store'
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
    const currentUser = computed(() => {
      return userStore.currentUser
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
      user
    }
  }
})
</script>