import { Store } from 'vuex'
import { initializeStores } from '../plugins/store-accessor'

export * from '../plugins/store-accessor'

const initializer = (store: Store<any>) => initializeStores(store)

export const plugins = [initializer]