json.post do
  json.id @post.id
  json.status @post.status
  json.title @post.title
  json.text @post.text
  json.url @post.url
  json.spoiler @post.spoiler
  json.nsfw @post.nsfw
  json.type @post.type
  json.user do
    json.id @post.user.id
    json.name @post.user.name
    json.uname @post.user.uname
  end
  json.post_image @post.post_image
end