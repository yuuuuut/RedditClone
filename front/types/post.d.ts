import { UserPost } from "./user"

export type PostType = {
  none: 'none'
  user: 'user'
  community: 'community'
}

export type PostStatus = {
  draft: 'draft'
  public: 'public'
}

export interface Post {
  id: number
  status: PostStatus['draft'] | PostStatus['public']
  title: string
  text: string
  url: string
  spoiler: boolean
  nsfw: boolean
  type: PostType['none'] | PostType['user'] | PostType['community']
  communityId: string
  createdAt: Date | null
  postImage: {
    uid: string
    url: string
  }
}

export interface PostData {
  user: UserPost
  post: Post
}

