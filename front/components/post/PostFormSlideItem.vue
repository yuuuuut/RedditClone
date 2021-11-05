<template>
  <v-card class="card">
    <v-img :src="props.item.headerImage" height="60" />
    <div class="card-main">
      <div class="d-flex align-center">
        <v-avatar size="55">
          <v-img :src="props.item.mainImage" />
        </v-avatar>
        <div>{{ props.item.path }}</div>
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import { computed, defineComponent, onMounted, PropType, ref } from "@nuxtjs/composition-api"
import { Community } from "~/types/community"

export default defineComponent({
  props: {
    item: {
      type: String,
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

.info-item {
  margin: 10px 5px;
  font-size: 14px;
}
</style>