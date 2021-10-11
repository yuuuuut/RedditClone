<template>
  <v-app>
    <v-app-bar color="white" height="48" app>
      <v-toolbar-title>Reddit Clone</v-toolbar-title>
      <v-text-field
        hide-details
        outlined
        dense
        prepend-inner-icon="mdi-magnify"
        placeholder="Search Reddit"
        class="search-input"
      />
      <div class="mr-8">
        <v-btn
          rounded
          outlined
          color="primary"
          width="120"
          class="mr-5"
        >
          Log In
        </v-btn>
        <v-btn
          rounded
          color="primary"
          dark
          width="120"
          class="mr-5"
        >
          Sign Up
        </v-btn>
        <v-menu
          bottom
          left
        >
          <template #activator="{ on, attrs }">
            <v-btn
              dark
              icon
              v-bind="attrs"
              v-on="on"
            >
              <v-icon color="black">mdi-account-outline</v-icon>
              <v-icon color="black">mdi-chevron-down</v-icon>
            </v-btn>
          </template>

          <v-list>
            <!-- <v-list-item
              v-for="(item, i) in items"
              :key="i"
            >
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item> -->
          </v-list>
        </v-menu>
      </div>
    </v-app-bar>
    <v-main class="main">
      <v-container>
        <Nuxt />
      </v-container>
    </v-main>
  </v-app>
</template>

<script lang="ts">
import { defineComponent } from '@nuxtjs/composition-api'
import { userStore } from '@/plugins/store-accessor'

export default defineComponent({
  setup() {

    const setCurrentUser = () => {
      userStore.getCurrentUser()
    }

    setCurrentUser()
  }
})
</script>

<style lang="scss" scoped>
.main {
  background-color: #dae0e6;
}

.v-sheet.v-app-bar.v-toolbar:not(.v-sheet--outlined) {
  box-shadow: initial;
}

.search-input {
  margin-right: 100px;
  margin-left: 150px;
  max-width: 650px;
}

::v-deep .v-input__icon--prepend-inner .v-icon { 
  padding-bottom: 5px;
}

::v-deep .v-text-field .v-input__control .v-input__slot {
  min-height: 34px !important;
}

@media (min-width: 1264px) {
  .container {
    max-width: 1000px;
  }
}
</style>