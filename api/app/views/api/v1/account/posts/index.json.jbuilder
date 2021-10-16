json.posts do
  json.array! @posts do |post|
    json.id post.id
    json.title post.title
    json.created_at post.created_at
    json.user do
      json.id post.user.id
      json.name post.user.name
    end
  end
end