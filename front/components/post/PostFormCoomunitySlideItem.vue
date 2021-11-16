<template>
  <v-card class="card">
    <v-img :src="props.item.headerImage" height="60" />
    <div class="card-main">
      <div class="d-flex align-center">
        <v-avatar size="55">
          <v-img :src="props.item.mainImage" />
        </v-avatar>
        <div class="side-item__title">
          {{ props.item.path }}
        </div>
      </div>
      <div class="side-item__description">
        {{ props.item.description }}
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import { defineComponent, PropType } from "@nuxtjs/composition-api"
import { Community } from "~/types/community"

export default defineComponent({
  props: {
    item: {
      type: Object as PropType<Community>,
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
  margin-left: 10px;
  font-size: 20px;
}

.side-item__description {
  margin-top: 10px;
  font-size: 14px;
}
</style>