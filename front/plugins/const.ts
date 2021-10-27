import { PostStatus, PostType } from "~/types/post"

const ROOT_SUBMIT_ROUTE = 'submit'
const USER_SUBMIT_ROUTE = 'user-name-submit'
const COMMUNITY_SUBMIT_ROUTE = 'r-name-submit'

const POST_TYPE: { [key in PostType]: PostType } = {
  none: 'none',
  user: 'user',
  community: 'community'
}

const POST_STATUS: { [key in PostStatus]: PostStatus } = {
  draft: 'draft',
  public: 'public'
}

export {
  ROOT_SUBMIT_ROUTE,
  USER_SUBMIT_ROUTE,
  COMMUNITY_SUBMIT_ROUTE,
  POST_TYPE,
  POST_STATUS
}