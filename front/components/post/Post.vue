<template>
  <v-card class="card" outlined>
    <div class="d-flex">
      <div class="post-side">
        <div class="post-side__item">
          <div>
            <v-icon>mdi-arrow-up-bold-outline</v-icon>
          </div>
          <div>0</div>
          <div>
            <v-icon>mdi-arrow-down-bold-outline</v-icon>
          </div>
        </div>
      </div>
      <div class="post-main">
        <div>
          <div class="d-flex">
            <v-avatar
              color="primary"
              size="23"
            >
              <v-img v-if="propsPost.post.type === POST_TYPE.community && propsPost.community" :src="propsPost.community.mainImage" />
              <v-img v-else :src="propsPost.user.image" />
            </v-avatar>
            <div class="post-header">
              <div class="post-name">
                <template v-if="propsPost.post.type === POST_TYPE.community && propsPost.community">
                  {{ communityRename(propsPost.community.name) }}
                </template>
                <template v-else>
                  {{ userRename(propsPost.user.uname) }}
                </template>
              </div>
              <div class="post-posted">・ Posted by {{ userRename(propsPost.user.uname) }} 6 months ago</div>
            </div>
          </div>
          <div>
            <div class="post-title">{{ propsPost.post.title }}</div>
          </div>
          <div class="post-text__parent">
            <div class="post-text" v-text="propsPost.post.text"></div>
          </div>
          <div v-if="propsPost.post.postImage.url" class="mt-2">
            <v-img max-width="100%" max-height="300" :src="propsPost.post.postImage.url" />
          </div>
        </div>
        <div class="post-footer">
          <div class="post-footer__item">
            <v-icon class="mr-2">mdi-comment-outline</v-icon>
            <div class="post-footer__text">1 Comments</div>
          </div>
          <div class="post-footer__item">
            <v-icon class="mr-2">mdi-share-outline</v-icon>
            <div class="post-footer__text">Share</div>
          </div>
          <div class="post-footer__item">
            <v-icon class="mr-2">mdi-bookmark-outline</v-icon>
            <div class="post-footer__text">Save</div>
          </div>
        </div>
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import { computed, defineComponent, PropType } from "@nuxtjs/composition-api"

import { userRename, communityRename } from "~/plugins/function"
import { POST_TYPE } from "~/plugins/const"
import { PostData } from "~/types/post"

export default defineComponent({
  props: {
    post: {
      type: Object as PropType<PostData>,
      required: true
    }
  },
  setup(props) {
    const propsPost = computed(() => {
      return props.post
    })

    return {
      propsPost,
      POST_TYPE,
      userRename,
      communityRename
    }
  }
})
</script>

<style lang="scss" scoped>
.card {
  overflow-x: hidden;
}

.post-side__item {
  display: flex;
  flex-direction: column;
  align-items: center;
  margin-top: 10px;
}

.post-side {
  width: 7%;
  background: rgb(245, 246, 247);
}

.post-main {
  width: 93%;
  padding: 10px;
}

.post-header {
  display: flex;
  align-items: center;
  margin-left: 5px;
}

.post-name {
  font-weight: bold;
  font-size: 13px;
}

.post-posted {
  color: rgb(120, 124, 126);
  font-size: 14px;
}

.post-title {
  font-size: 19px;
  margin-top: 5px;
  margin-bottom: 10px;
}

.post-text__parent {
  position: relative;
  max-height: 200px;
  overflow: hidden;
}

.post-text__parent::before {
  content: "";
  width: 100%;
  height: 100%;
  display: block;
  background: linear-gradient(rgba(255,255,255,0) 180px, #fff 200px);
  position: absolute;
}

.post-text {
  word-break: break-all;
  white-space: pre-line;
  line-height: 20px;
  font-size: 15px;
}

.post-footer {
  display: flex;
  justify-content: space-between;
  width: 50%;
  color: rgb(120, 124, 126);
  margin-top: 17px;
}

.post-footer__item {
  display: flex;
  align-items: center;
}

.post-footer__text {
  font-size: 13px;
  font-weight: bold;
}
</style>