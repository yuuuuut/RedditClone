<template>
  <v-col ref="root" cols="8">
    <div class="popular-title">Popular posts</div>
    <div class="main">
      <v-card class="filter-card" outlined>
        <div class="filter-card__items">
          <div class="filter-card__item" @click="pushRouter('/hot')">
            <v-icon
              :class="{'filter-card__current-item': currentPagePath === '/' || currentPagePath === '/hot'}"
              class="mr-1"
            >
              mdi-fire
            </v-icon>
            <div :class="{'filter-card__current-item': currentPagePath === '/' || currentPagePath === '/hot'}">Hot</div>
          </div>
          <div class="filter-card__item" @click="pushRouter('/new')">
            <v-icon
              :class="{'filter-card__current-item': currentPagePath === '/new'}"
              class="mr-1"
            >
              mdi-decagram
            </v-icon>
            <div :class="{'filter-card__current-item': currentPagePath === '/new'}">New</div>
          </div>
          <div class="filter-card__item" @click="pushRouter('/top')">
            <v-icon
              :class="{'filter-card__current-item': currentPagePath === '/top'}"
              class="mr-1"
            >
              mdi-arrow-up-thick
            </v-icon>
            <div :class="{'filter-card__current-item': currentPagePath === '/top'}">Top</div>
          </div>
        </div>
      </v-card>
      <div v-for="post in posts" :key="post.id" class="mb-3">
        <Post :post="post" />
      </div>
    </div>
  </v-col>
  </template>
</template>

<script lang="ts">
import { useRoute } from '@nuxtjs/composition-api'
import { defineComponent, onMounted, onUnmounted, ref } from '@vue/composition-api'
import { Pagination } from '~/types/pagination'
import { PostData } from '~/types/post'
import { $axios } from '~/utils/api'

type Paths = '/' | '/hot' | '/new' | '/top'

export default defineComponent({
  setup() {
    const root = ref<HTMLElement | null>(null)
    const route = useRoute()

    const currentPagePath = ref<Paths>('/')
    const posts = ref<PostData[]>([])
    const pagination = ref<Pagination>({
      currentPage: 1,
      limitValue: null,
      nextPage: null,
      prevPage: null,
      totalCount: null,
      totalPages: 1
    })

    const pushRouter = (path: Paths) => {
      history.pushState({}, '', `${path}`)
      currentPagePath.value = path
    }

    onMounted(async () => {
      if (route.value.path === '/' || route.value.path === '/hot') {
        currentPagePath.value = '/hot'
      }
      if (route.value.path === '/new') {
        currentPagePath.value = '/new'
      }
      if (route.value.path === '/top') {
        currentPagePath.value = '/top'
      }
      window.addEventListener("scroll", handleScroll)
      const response = await $axios.get('/posts')
      posts.value.push(...response.data.posts)
    })

    onUnmounted(() => {
      window.removeEventListener("scroll", handleScroll)
    })

    const handleScroll = async () => {
      if (!pagination.value.nextPage && pagination.value.currentPage !== 1) return

      const elm = root.value as HTMLElement
      if (elm.getBoundingClientRect().bottom < window.innerHeight) {
        pagination.value.currentPage += 1
        const response = await $axios.get(`/posts`, { params: { page: pagination.value.currentPage }})
        posts.value.push(...response.data.posts)
        pagination.value = response.data.pagination
      }
    }

    return {
      root,
      route,
      posts,
      currentPagePath,
      pushRouter
    }
  }
})
</script>

<style lang="scss" scoped>
.main {
  width: 97%;
}

.popular-title {
  margin-bottom: 10px;
  font-size: 15px;
}

.filter-card {
  height: 58px;
  margin-bottom: 20px;
}

.filter-card__items {
  display: flex;
  justify-content: space-between;
  padding: 15px;
  width: 250px;
}

.filter-card__item {
  display: flex;
  align-items: center;
  color: rgb(120, 124, 126);
}

.filter-card__current-item {
  display: flex;
  align-items: center;
  color: rgb(12, 66, 243);
  font-weight: bold;
}
</style>