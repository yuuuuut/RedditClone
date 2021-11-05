<template>
  <v-card class="card">
    <!-- <v-img :src="props.item.headerImage" height="60" /> -->
    <div class="card-main">
      <div>
        <v-avatar tile size="75">
          <v-img :src="props.item.image" />
        </v-avatar>
        <div class="side-item__title">{{ props.item.uname }}</div>
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import { defineComponent, PropType } from "@nuxtjs/composition-api"
import { UserType } from "~/store/user"

export default defineComponent({
  props: {
    item: {
      type: Object as PropType<UserType>,
      required: true
    }
  },
  setup(props) {
    return {
      props
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
}

.side-item__title {
  margin-top: 5px;
  font-size: 14px;
}
</style>