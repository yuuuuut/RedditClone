<template>
  <v-card class="card">
    <v-img :src="props.item.headerImage" height="90" />
    <div class="card-main">
      <div>
        <v-avatar tile size="75" class="card-avatar">
          <v-img :src="props.item.image" />
        </v-avatar>
        <div class="side-item__title">{{ props.item.uname }}</div>
        <div v-if="props.isShowCreateBtn && isCurrentUser" class="mt-5">
          <NuxtLink :to="`/user/${route.params.name}/submit`">
            <v-btn width="100%" color="primary" rounded>New Post</v-btn>
          </NuxtLink>
        </div>
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import { computed, defineComponent, PropType, useRoute } from "@nuxtjs/composition-api"
import { userStore } from "~/store"
import { UserType } from "~/store/user"

export default defineComponent({
  props: {
    item: {
      type: Object as PropType<UserType>,
      required: true
    },
    isShowCreateBtn: {
      type: Boolean,
      required: true
    }
  },
  setup(props) {
    const route = useRoute()

    const currentUser = computed(() => {
      return userStore.currentUser
    })
    const isCurrentUser = computed(() => {
      return currentUser.value?.uname === route.value.params.name
    })

    return {
      props,
      isCurrentUser,
      route
    }
  }
})
</script>

<style lang="scss" scoped>
.card {
  max-width: 90%;
  margin-bottom: 20px;
}

.card-main {
  padding: 16px;
  position: relative;
}

.card-avatar {
  position: absolute;
  top: -50px;
  background: #fff;
  padding-top: 5px;
  padding-right: 3px;
  padding-left: 3px;
  z-index: 999;
}

.side-item__title {
  margin-top: 13px;
  font-size: 13px;
}
</style>