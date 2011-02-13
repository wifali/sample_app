# By using the symbol ':user', we get Factory Girl to simulate the User model.
Factory.define :user do |user|
  user.name "Willi Fast"
  user.email "wifali@arcor.de"
  user.password "foobar"
  user.password_confirmation "foobar"
end
