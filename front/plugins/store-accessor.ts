/* eslint-disable import/no-mutable-exports */
import { getModule } from 'vuex-module-decorators'
import { Store } from 'vuex'

import flashMessage from '../store/flash-message'
import User from '../store/user'

let userStore: User
let flashMessageStore: flashMessage

function initializeStores (store: Store<any>) {
  userStore = getModule(User, store)
  flashMessageStore = getModule(flashMessage, store)
}

export {
  initializeStores,
  userStore,
  flashMessageStore
}