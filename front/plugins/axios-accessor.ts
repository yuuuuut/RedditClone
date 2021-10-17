import { AxiosError, AxiosRequestConfig } from 'axios'
import { Plugin } from '@nuxt/types'
import { initializeAxios } from '~/utils/api'

export type CustomRequestConfig = AxiosRequestConfig & {
  dontDisplayErrorPage?: boolean
}

export const accessor: Plugin = ({ $axios, $cookies, error }): void => {
  $axios.onRequest((config) => {
    config.headers['access-token'] = $cookies.get('access-token')
    config.headers.client = $cookies.get('client')
    config.headers.uid = $cookies.get('uid')
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