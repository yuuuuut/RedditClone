json.user do
  json.id @user.id
  json.uid @user.uid
  json.uname @user.uname
  json.name @user.name
  json.image @user.image
  json.email @user.email
  json.headerImage 'https://uploads-ssl.webflow.com/5cff83ac2044e22cb8cf2f11/5cffeaf7b3cb0ed2d33f7943_hero.jpg'
  json.isFirstLogin @user.is_first_login
end