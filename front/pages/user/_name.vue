<template>
  <div>
    <nuxt-child v-if="!isParentPage" />
    <v-container v-else class="mt-5">
      <v-row no-gutters>
        <v-col ref="root" cols="8">
          <div style="width: 97%;">
            <PostHeader :current-select="currentSelect" :click-func="pushRouter" />
            <div v-for="post in userPosts" :key="post.id" class="mb-3">
              <Post :post="post" />
            </div>
          </div>
        </v-col>
        <v-col v-if="user" cols="4">
          <PostFormUserSlideItem :item="user" :is-show-create-btn="true" />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script lang="ts">
import { computed, defineComponent, onMounted, onUnmounted, ref, useRoute  } from '@nuxtjs/composition-api'

import PostHeader from '~/components/post/PostHeader.vue'
import PostFormUserSlideItem from '~/components/post/PostFormUserSlideItem.vue'
import User from '~/store/user'
import { Paths, PostData } from '~/types/post'
import { $axios } from '~/utils/api'
import { Pagination } from '~/types/pagination'

export default defineComponent({
  components: {
    PostHeader,
    PostFormUserSlideItem
  },
  setup() {
    const root = ref<HTMLElement | null>(null)
    const route = useRoute()

    const user = ref<User | null>(null)
    const userPosts = ref<PostData[]>([])
    const currentSelect = ref<Paths>('root')
    const pagination = ref<Pagination>({
      currentPage: 1,
      limitValue: null,
      nextPage: null,
      prevPage: null,
      totalCount: null,
      totalPages: 1
    })

    /**
     * Computed
     */
    const isParentPage =  computed(() => {
      return route.value.name === 'user-name'
    })

    const pushRouter = async (path: Paths) => {
      pagination.value = {
        currentPage: 1,
        limitValue: null,
        nextPage: null,
        prevPage: null,
        totalCount: null,
        totalPages: 1
      }
      history.pushState({}, '', route.value.path + `?sort=${path}`)
      currentSelect.value = path
      userPosts.value = []
      const res = await $axios.get(`/account/users/${route.value.params.name}?sort=${path}`)
      if (res.data) {
        userPosts.value.push(...res.data.user.posts)
        pagination.value = res.data.pagination
      }
    }

    onMounted(async () => {
      window.addEventListener("scroll", handleScroll)

      if (route.value.query.sort) {
        if (route.value.query.sort === 'new') {
          currentSelect.value = 'new'
          await getUser('new')
        } else if (route.value.query.sort === 'top') {
          currentSelect.value = 'top'
          await getUser('top')
        } else {
          currentSelect.value = 'hot'
          await getUser('hot')
        }
      } else {
        currentSelect.value = 'hot'
        await getUser(undefined)
      }
    })
    onUnmounted(() => {
      window.removeEventListener("scroll", handleScroll)
    })

    const handleScroll = async () => {
      if (!pagination.value.nextPage && pagination.value.currentPage !== 1) return

      const elm = root.value as HTMLElement
      if (elm.getBoundingClientRect().bottom < window.innerHeight) {
        pagination.value.currentPage += 1
        const response = await $axios.get(`/account/users/${route.value.params.name}?sort=${currentSelect.value}`, { params: { page: pagination.value.currentPage }})
        userPosts.value.push(...response.data.user.posts)
        pagination.value = response.data.pagination
      }
    }

    const getUser = async (query: string | undefined) => {
      try {
        if (query) {
          userPosts.value = []
          const res = await $axios.get(`/account/users/${route.value.params.name}?sort=${query}`)
          if (res.data) {
            user.value = res.data.user
            userPosts.value.push(...res.data.user.posts)
            pagination.value = res.data.pagination
          }
        } else {
          const res = await $axios.get(`/account/users/${route.value.params.name}`)
          if (res.data) {
            user.value = res.data.user
            userPosts.value.push(...res.data.user.posts)
            pagination.value = res.data.pagination
          }
        }
      } catch (e) {
      }
    }

    return {
      root,
      user,
      userPosts,
      isParentPage,
      currentSelect,
      getUser,
      pushRouter
    }
  }
})
</script>