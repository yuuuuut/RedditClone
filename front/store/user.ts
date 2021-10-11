import { Module, VuexModule, Mutation, Action } from 'vuex-module-decorators'
import { useContext } from '@nuxtjs/composition-api'
import { $axios } from '~/utils/api'

/**
 * Types
 */
export interface UserType {
  uid: string
  image: string
  email: string
}

@Module({ stateFactory: true, namespaced: true, name: 'user' })
export default class User extends VuexModule {
  private user: UserType | null = null

  @Mutation
  setUser (user: UserType | null) {
    this.user = user
  }

  get currentUser () {
    return this.user
  }

  @Action({ rawError: true })
  public async getCurrentUser () {
    const ctx = useContext()
    const response = await $axios.get('/account/me')
    if (response.status !== 200) {
      this.setUser(null)
      ctx.error({ statusCode: response.status })
      return
    }

    const currentUser = response.data.current_user
    this.setUser(currentUser)
  }
}