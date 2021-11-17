<template>
  <v-card class="filter-card" outlined>
    <div class="filter-card__items">
      <div class="filter-card__item" @click="props.clickFunc('hot')">
        <v-icon
          :class="{'filter-card__current-item': props.currentSelect === 'root' || props.currentSelect === 'hot'}"
          class="mr-1"
        >
          mdi-fire
        </v-icon>
        <div :class="{'filter-card__current-item': props.currentSelect === 'root' || props.currentSelect === 'hot'}">Hot</div>
      </div>
      <div class="filter-card__item" @click="props.clickFunc('new')">
        <v-icon
          :class="{'filter-card__current-item': props.currentSelect === 'new'}"
          class="mr-1"
        >
          mdi-decagram
        </v-icon>
        <div :class="{'filter-card__current-item': props.currentSelect === 'new'}">New</div>
      </div>
      <div class="filter-card__item" @click="props.clickFunc('top')">
        <v-icon
          :class="{'filter-card__current-item': props.currentSelect === 'top'}"
          class="mr-1"
        >
          mdi-arrow-up-thick
        </v-icon>
        <div :class="{'filter-card__current-item': props.currentSelect === 'top'}">Top</div>
      </div>
    </div>
  </v-card>
</template>

<script lang="ts">
import { defineComponent, PropType } from "@nuxtjs/composition-api"
import { Paths } from "~/types/post"

export default defineComponent({
  props: {
    currentSelect: {
      type: String,
      required: true
    },
    clickFunc: {
      type: Function as PropType<(path: Paths) => void>,
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