import { AxiosError, AxiosRequestConfig } from 'axios'
import { Plugin } from '@nuxt/types'

import { initializeAxios } from '~/utils/api'

export type CustomRequestConfig = AxiosRequestConfig & {
  dontDisplayErrorPage?: boolean
}

export const accessor: Plugin = ({ $axios, $cookies, store, redirect, error }): void => {
  $axios.onRequest((config) => {
    config.headers['access-token'] = $cookies.get('access-token')
    config.headers.client = $cookies.get('client')
    config.headers.uid = $cookies.get('uid')
    config.headers.Accept = 'application/json'
  })

  $axios.onResponse((config) => {
    if (config.headers['access-token'] && config.headers.uid && config.headers.client) {
      $cookies.set('access-token', config.headers['access-token'])
      $cookies.set('client', config.headers.client)
      $cookies.set('uid', config.headers.uid)
    }
  })

  $axios.onError((axiosError: AxiosError) => {
    $cookies.remove('post-value')
    const response = axiosError.response
    const status = response?.status ?? 500

    // sign_outの404エラーは無視
    if (response?.config.url === '/auth/sign_out') return
    // 422 Validationエラーは無視
    if (status === 422) return
    // 401エラーの場合はログアウトさせてTopページへ
    if (status === 401) {
      store.dispatch('user/logout')
      redirect('/')
    }

    // if ((axiosError.config as CustomRequestConfig)?.dontDisplayErrorPage) return
    // error({ statusCode: status })
  })
  initializeAxios($axios)
}

export default accessor