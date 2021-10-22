<template>
  <v-col ref="root" cols="8">
    <div class="main">
      <v-card class="filter-card" outlined>
        <div class="filter-card__items">
          <div class="filter-card__item">
            <v-icon class="mr-1">mdi-fire</v-icon>
            <div>Hot</div>
          </div>
          <div class="filter-card__item">
            <v-icon class="mr-1">mdi-decagram</v-icon>
            <div>New</div>
          </div>
          <div class="filter-card__item">
            <v-icon class="mr-1">mdi-arrow-up-thick</v-icon>
            <div>Top</div>
          </div>
        </div>
      </v-card>
      <div v-for="post in posts" :key="post.post.id" class="mb-3">
        <Post :post="post" />
      </div>
    </div>
  </v-col>
</template>

<script lang="ts">
import { defineComponent, onMounted, onUnmounted, ref } from '@vue/composition-api'
import { Pagination } from '~/types/pagination'
import { PostData } from '~/types/post'
import { $axios } from '~/utils/api'

export default defineComponent({
  setup() {
    const root = ref<HTMLElement | null>(null)

    const posts = ref<PostData[]>([])
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
      posts
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
</style>