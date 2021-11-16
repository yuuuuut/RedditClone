<template>
  <v-col ref="root" cols="8">
    <div class="main">
      <PostHeader :current-select="currentSelect" :click-func="pushRouter" />
      <div v-for="post in posts" :key="post.id" class="mb-3">
        <Post :post="post" />
      </div>
    </div>
  </v-col>
  </template>
</template>

<script lang="ts">
import { defineComponent, onMounted, onUnmounted, PropType, ref, useRoute } from '@nuxtjs/composition-api'
import { Pagination } from '~/types/pagination'
import { Paths, PostData } from '~/types/post'
import { $axios } from '~/utils/api'

export default defineComponent({
  props: {
    clickType: {
      type: String as PropType<'ROOT' | 'USER'>,
      required: true
    },
  },
  setup(props) {
    const root = ref<HTMLElement | null>(null)
    const route = useRoute()

    const currentSelect = ref<Paths>('root')
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
      if (props.clickType === 'ROOT') {
        (path === 'root')
          ? history.pushState({}, '', `/`)
          : history.pushState({}, '', `/${path}`)
        currentSelect.value = path
      } else {
        history.pushState({}, '', route.value.path + `?sort=${path}`)
        currentSelect.value = path
      }
    }

    onMounted(async () => {
      if (route.value.path === '/' || route.value.path === '/hot') {
        currentSelect.value = 'hot'
      }
      if (route.value.path === '/new') {
        currentSelect.value = 'new'
      }
      if (route.value.path === '/top') {
        currentSelect.value = 'top'
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
      currentSelect,
      pushRouter
    }
  }
})
</script>

<style lang="scss" scoped>
.main {
  width: 97%;
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