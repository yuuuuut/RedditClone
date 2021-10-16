json.post do
  json.id @post.id
  json.status @post.status
  json.title @post.title
  json.text @post.text
  json.url @post.url
  json.spoiler @post.spoiler
  json.nsfw @post.nsfw
  json.user do
    json.id @post.user.id
    json.name @post.user.name
  end
  json.post_image @post.post_image
end