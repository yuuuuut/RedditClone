json.communities do
  json.array! @communities do |c|
    json.id c.id
    json.name c.name
    json.description c.description
    json.mainImage c.main_image
    json.headerImage c.header_image
  end
end