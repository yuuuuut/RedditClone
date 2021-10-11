import { Module, VuexModule, Mutation, Action } from 'vuex-module-decorators'
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
  public user: UserType | null = null

  @Mutation
  setUser (user: UserType) {
    this.user = user
  }

  get currentUser () {
    return this.user
  }

  @Action({ rawError: true })
  public getCurrentUser () {
    $axios.get('/account/me').then(response => {
      if (response.status !== 200) throw new Error('error')
      const currentUser = response.data.current_user
      this.setUser(currentUser)
    }).catch((e) => {
      console.error(e)
    })
  }
}