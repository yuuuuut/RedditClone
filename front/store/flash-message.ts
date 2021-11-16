import { Module, VuexModule, Mutation, Action } from 'vuex-module-decorators'
import { FlashType } from '~/types/flash-message'

@Module({ stateFactory: true, namespaced: true, name: 'flash-message' })
export default class FlashMessage extends VuexModule {
  private message = ''
  private isFlash = false
  private type: FlashType = 'SUCCESS'

  @Mutation
  setMessage (message: string) {
    this.message = message
  }

  @Mutation
  setIsFlash (bool: boolean) {
    this.isFlash = bool
  }

  @Mutation
  setType (type: FlashType) {
    this.type = type
  }

  get getMessage () {
    return this.message
  }

  get getIsFlash () {
    return this.isFlash
  }

  get getType () {
    return this.type
  }

  @Action({ rawError: true })
  public createFlashMessage (payload: { message: string, type: FlashType }) {
    this.setMessage(payload.message)
    this.setIsFlash(true)
    this.setType(payload.type)
    setTimeout(() => {
      this.setIsFlash(false)
    }, 5000)
  }
}