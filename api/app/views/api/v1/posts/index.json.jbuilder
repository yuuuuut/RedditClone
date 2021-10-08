json.posts do
  json.array! @posts do |post|
    json.id post[:id]
    json.name post[:title]
  end
end