# emailに一致するAdminを探し、なければ、新規作成として、ブロック内の処理をする。
Admin.find_or_create_by!(email: ENV["ADMIN_EMAIL"]) do |admin|
  # admin = Admin.new(email: ENV["ADMIN_EMAIL"]) <= これは、find_or_create_by! に引数で渡した値は、自動でカラムにセットされるので不要。
  
  # パスワードをセット
  admin.password = ENV["ADMIN_PASSWORD"]

  # パスワードの「確認用入力欄」と一致するかをチェックするにセット
  admin.password_confirmation = ENV["ADMIN_PASSWORD"]
end

# テストデータ: ユーザー
User.find_or_create_by(email: "john@example.com") do |user|
  user.name = "John"
  user.password = "test00"
  user.password_confirmation = "test00"
  user.introduction = "#{user.name}です、よろしく。"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end
User.find_or_create_by(email: "jane@example.com") do |user|
  user.name = "Jane"
  user.password = "test00"
  user.password_confirmation = "test00"
  user.introduction = "#{user.name}です、よろしく。"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end
User.find_or_create_by(email: "doe@example.com") do |user|
  user.name = "Doe"
  user.password = "test00"
  user.password_confirmation = "test00"
  user.introduction = "#{user.name}です、よろしく。"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end
