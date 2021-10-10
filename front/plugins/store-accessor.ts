import { getModule } from 'vuex-module-decorators'
import { Store } from 'vuex'

import User from '../store/user'

// eslint-disable-next-line import/no-mutable-exports
let userStore: User

function initializeStores (store: Store<any>) {
  userStore = getModule(User, store)
}

export {
  initializeStores,
  userStore
}