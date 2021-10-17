import { Plugin } from '@nuxt/types'
import { initializeCookies } from '~/utils/cookies'

const accessor: Plugin = ({ $cookies }: any) => {
  initializeCookies($cookies)
}

export default accessor