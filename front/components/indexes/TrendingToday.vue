<template>
  <div class="mb-7">
    <div class="name">Trending today</div>
    <div class="d-flex justify-space-between">
      <div v-for="community in communities" :key="community.name" class="post-image__wrap">
        <v-img :src="community.image" class="post-image" />
        <div class="post-image__name">
          {{ community.name }}
        </div>
        <div class="post-image__describe">
          {{ community.describe }}
        </div>
        <div class="post-image__community-wrap">
          <v-avatar
            color="primary"
            size="19"
          ></v-avatar>
          <div class="post-image__community-name">
            r/news and more
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script lang="ts">
import { defineComponent, reactive } from "@vue/composition-api"

export default defineComponent({
  setup() {
    const communities = reactive([
      { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" },
      { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" },
      { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" },
      { image: "/image/sample.jpeg", name: "Covid", describe: "あああああああああああああああああああああああああああああ" }
    ])

    
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