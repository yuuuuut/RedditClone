json.communities do
  json.array! @communities do |c|
    json.name c.name
    json.description c.description
    json.mainImage c.main_image
    json.headerImage c.header_image
    json.path c.path
  end
end