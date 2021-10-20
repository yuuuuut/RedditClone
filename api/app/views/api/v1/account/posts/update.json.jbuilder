json.post do
  json.id @post.id
  json.title @post.title
  json.text @post.text
  json.url @post.url
  json.spoiler @post.spoiler
  json.nsfw @post.nsfw
  json.status @post.status
  json.type @post.type
  json.user do
    json.id @post.user.id
    json.name @post.user.name
    json.uname @post.user.uname
  end
  json.postImage do
    json.uid @post.post_image.present? ? @post.post_image.uid : ''
    json.url @post.post_image.present? ? @post.post_image.url : ''
  end
end