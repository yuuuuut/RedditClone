import { AxiosError, AxiosRequestConfig } from 'axios'
import { Plugin } from '@nuxt/types'
import { initializeAxios } from '~/utils/api'

export type CustomRequestConfig = AxiosRequestConfig & {
  dontDisplayErrorPage?: boolean
}

export const accessor: Plugin = ({ $axios, error }): void => {
  $axios.onRequest((config) => {
    config.headers['access-token'] = localStorage.getItem('access-token')
    config.headers.client = localStorage.getItem('client')
    config.headers.uid = localStorage.getItem('uid')
    config.headers.Accept = 'application/json'
  })

  $axios.onError((axiosError: AxiosError) => {
    const response = axiosError.response
    const status = response?.status ?? 500

    if (response?.config.url === '/account/me') return
    if ((axiosError.config as CustomRequestConfig)?.dontDisplayErrorPage) return

    error({ statusCode: status })
  })
  initializeAxios($axios)
}

export default accessor