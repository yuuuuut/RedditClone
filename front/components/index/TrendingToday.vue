<template>
  <div class="mb-7">
    <div class="name">Trending today</div>
    <div class="d-flex justify-space-between">
      <div v-for="community in communities" :key="community.id" class="post-image__wrap">
        <NuxtLink :to="`/r/${community.name}`">
          <v-img :src="community.mainImage" class="post-image" />
          <div class="post-image__name">
            {{ community.name }}
          </div>
          <div class="post-image__describe">
            {{ community.description }}
          </div>
          <div class="post-image__community-wrap">
            <v-avatar
              color="primary"
              size="19"
            >
              <v-img src="https://firebasestorage.googleapis.com/v0/b/redditclone-16a84.appspot.com/o/images%2F16349048489070?alt=media&token=5ed7d2a8-6dda-430f-8c62-9ba7ca166b3b" />
            </v-avatar>
            <div class="post-image__community-name">
              r/news and more
            </div>
          </div>
        </NuxtLink>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, onMounted, reactive, ref } from "@vue/composition-api"
import { $axios } from "~/utils/api"

export default defineComponent({
  setup() {
    const communities = ref([])
    // const communities = reactive([
    //   { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" },
    //   { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" },
    //   { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" },
    //   { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" }
    // ])

    onMounted(async () => {
      await a()
    })

    const a = async () => {
      const response = await $axios.get('/communities')
      communities.value.push(...response.data.communities)
    }


    
    return {
      communities
    }
  }
})
</script>

<style lang="scss" scoped>
.name {
  font-size: 15px;
  margin-bottom: 5px;
}

.post-image__wrap {
  display: flex;
  position: relative;
  background: #000;
  border-radius: 10px;
  width: 238px;
  cursor: pointer;

  .post-image {
    width: 238px;
    height: 178px;
    border-radius: 10px;
    display: block;
    opacity: 0.5;
  }

  .post-image__name {
    position: absolute;
    color: #fff;
    font-weight: bold;
    font-size: 20px;
    top: 45%;
    padding-left: 10px;
    z-index: 9999;
  }

  .post-image__describe {
    position: absolute;
    color: #fff;
    font-weight: bold;
    font-size: 13px;
    top: 60%;
    padding-left: 10px;
    padding-right: 10px;
    z-index: 9999;
  }

  .post-image__community-wrap {
    display: flex;
    position: absolute;
    top: 83%;
    margin-left: 10px;

    .post-image__community-name {
      color: #fff;
      font-size: 12px;
      margin-left: 10px;
      z-index: 9999;
    }
  }
}
</style>