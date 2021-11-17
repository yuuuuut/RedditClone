<template>
  <v-container>
    <TrendingToday />
    <v-row no-gutters>
      <v-col ref="root" cols="8">
        <div style="width: 97%;">
          <PostHeader :current-select="currentSelect" :click-func="pushRouter" />
          <div v-for="post in posts" :key="post.id" class="mb-3">
            <Post :post="post" />
          </div>
        </div>
      </v-col>
      <TopCommunities />
    </v-row>
  </v-container>
</template>

<script lang="ts">
import { defineComponent, onMounted, onUnmounted, ref, useRoute } from '@nuxtjs/composition-api'

import { AxiosResponse } from 'axios'

import TopCommunities from '~/components/index/TopCommunities.vue'
import TrendingToday from '~/components/index/TrendingToday.vue'
import PostHeader from '~/components/post/PostHeader.vue'

import { Pagination } from '~/types/pagination'
import { Paths, PostData } from '~/types/post'
import { $axios } from '~/utils/api'

export default defineComponent({
  components: {
    PostHeader,
    TrendingToday,
    TopCommunities
  },
  setup() {
    const root = ref<HTMLElement | null>(null)
    const route = useRoute()

    const posts = ref<PostData[]>([])
    const currentSelect = ref<Paths>('root')
    const pagination = ref<Pagination>({
      currentPage: 1,
      limitValue: null,
      nextPage: null,
      prevPage: null,
      totalCount: null,
      totalPages: 1
    })

    onMounted(async () => {
      window.addEventListener("scroll", handleScroll)

      if (route.value.path === '/new') {
        currentSelect.value = 'new'
        await getPosts('new')
      } else if (route.value.path === '/top') {
        currentSelect.value = 'top'
        await getPosts('top')
      } else if (route.value.path === '/hot') {
        currentSelect.value = 'hot'
        await getPosts('hot')
      } else {
        currentSelect.value = 'hot'
        await getPosts(undefined)
      }
    })
    onUnmounted(() => {
      window.removeEventListener("scroll", handleScroll)
    })

    const resetPagination = () => {
      pagination.value = {
        currentPage: 1,
        limitValue: null,
        nextPage: null,
        prevPage: null,
        totalCount: null,
        totalPages: 1
      }
    }

    const pushRouter = async (path: Paths) => {
      resetPagination()

      let res: AxiosResponse<any>

      posts.value = []
      if (path === 'root') {
        history.pushState({}, '', '/')
        currentSelect.value = 'hot'
        res = await $axios.get(`/posts`)
      } else {
        history.pushState({}, '', `/${path}`)
        currentSelect.value = path
        res = await $axios.get(`/posts?sort=${path}`)
      }
      if (res.data) {
        posts.value.push(...res.data.posts)
        pagination.value = res.data.pagination
      }
    }

    const handleScroll = async () => {
      if (!pagination.value.nextPage && pagination.value.currentPage !== 1) return

      const elm = root.value as HTMLElement
      if (elm.getBoundingClientRect().bottom < window.innerHeight) {
        pagination.value.currentPage += 1
        const response = await $axios.get(`/posts?sort=${currentSelect.value}`, { params: { page: pagination.value.currentPage }})
        posts.value.push(...response.data.posts)
        pagination.value = response.data.pagination
      }
    }

    const getPosts = async (query: string | undefined) => {
      try {
        if (query) {
          posts.value = []
          const res = await $axios.get(`/posts?sort=${query}`)
          if (res.data) {
            posts.value.push(...res.data.posts)
            pagination.value = res.data.pagination
          }
        } else {
          const res = await $axios.get(`/posts`)
          if (res.data) {
            posts.value.push(...res.data.posts)
            pagination.value = res.data.pagination
          }
        }
      } catch (e) {
      }
    }

    return {
      root,
      posts,
      currentSelect,
      getPosts,
      pushRouter
    }
  }
})
</script>