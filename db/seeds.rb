# emailに一致するAdminを探し、なければ、新規作成として、ブロック内の処理をする。
Admin.find_or_create_by!(email: ENV["ADMIN_EMAIL"]) do |admin|
  # admin = Admin.new(email: ENV["ADMIN_EMAIL"]) <= これは、find_or_create_by! に引数で渡した値は、自動でカラムにセットされるので不要。
  
  # パスワードをセット
  admin.password = ENV["ADMIN_PASSWORD"]

  # パスワードの「確認用入力欄」と一致するかをチェックするにセット
  admin.password_confirmation = ENV["ADMIN_PASSWORD"]
end

# 言語
language_data = [
  # マークアップ言語
  { extension: 'html', name: 'HTML' },
  { extension: 'htm',  name: 'HTML' },
  { extension: 'xhtml', name: 'XHTML' },
  { extension: 'xml',  name: 'XML' },
  
  # スタイルシート
  { extension: 'css',  name: 'CSS' },
  { extension: 'scss', name: 'Sass' },
  { extension: 'sass', name: 'Sass' },
  { extension: 'less', name: 'LESS' },
  
  # プログラミング言語
  { extension: 'rb',   name: 'Ruby' },
  { extension: 'erb',  name: 'ERB' },
  { extension: 'js',   name: 'JavaScript' },
  { extension: 'ts',   name: 'TypeScript' },
  { extension: 'php',  name: 'PHP' },
  { extension: 'py',   name: 'Python' },
  { extension: 'java', name: 'Java' },
  { extension: 'kt',   name: 'Kotlin' },
  
  # データ形式
  { extension: 'json', name: 'JSON' },
  { extension: 'yaml', name: 'YAML' },
  { extension: 'yml',  name: 'YAML' },
  { extension: 'csv',  name: 'CSV' },
  
  # テキスト/その他
  { extension: 'txt',  name: 'Plain Text' },
  { extension: 'md',   name: 'Markdown' },
  { extension: 'sh',   name: 'Shell Script' },
  { extension: 'sql',  name: 'SQL' }
]
# ActiveRecord::Base.transaction ↓
# ここでのデータベース操作は「全部成功」か「全部失敗」のどちらか
# 例: 1つでも失敗したら全てロールバック（取り消し）
ActiveRecord::Base.transaction do
  language_data.each do |data|
    Language.find_or_create_by!(extension: data[:extension]) do |lang|
      lang.name = data[:name]
    end
  end
end

# テストデータ: ユーザー
User.find_or_create_by!(email: "john@example.com") do |user|
  user.name = "John"
  user.password = "test00"
  user.password_confirmation = "test00"
  user.introduction = "#{user.name}です、よろしく。"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user1.jpg"), filename:"sample-user1.jpg")
end
User.find_or_create_by!(email: "jane@example.com") do |user|
  user.name = "Jane"
  user.password = "test00"
  user.password_confirmation = "test00"
  user.introduction = "#{user.name}です、よろしく。"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user2.jpg"), filename:"sample-user2.jpg")
end
User.find_or_create_by!(email: "doe@example.com") do |user|
  user.name = "Doe"
  user.password = "test00"
  user.password_confirmation = "test00"
  user.introduction = "#{user.name}です、よろしく。"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/sample-user3.jpg"), filename:"sample-user3.jpg")
end
