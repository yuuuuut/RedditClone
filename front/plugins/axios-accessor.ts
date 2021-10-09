import { Plugin } from '@nuxt/types'
import { initializeAxios } from '~/utils/api'

export const accessor: Plugin = ({ $axios }): void => {
  $axios.onRequest((config) => {
    config.headers['access-token'] = localStorage.getItem('access-token')
    config.headers.client = localStorage.getItem('client')
    config.headers.uid = localStorage.getItem('uid')
    config.headers.Accept = 'application/json'
  })
  initializeAxios($axios)
}

export default accessor