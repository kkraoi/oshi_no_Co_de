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
  { extension: 'html', name: 'HTML', color: "#e34c26" },
  { extension: 'htm',  name: 'HTML', color: "#e34c26" },
  { extension: 'xhtml', name: 'XHTML', color: "#f7df1e" },
  { extension: 'xml',  name: 'XML', color: "#005b9f" },
  
  # スタイルシート
  { extension: 'css',  name: 'CSS', color: "#2965f1" },
  { extension: 'scss', name: 'Sass', color: "#cc6699" },
  { extension: 'sass', name: 'Sass', color: "#cc6699" },
  { extension: 'less', name: 'LESS', color: "#1d365d" },
  
  # プログラミング言語
  { extension: 'rb',   name: 'Ruby', color: "#cc342d" },
  { extension: 'erb',  name: 'ERB', color: "#cc342d" },
  { extension: 'js',   name: 'JavaScript', color: "#f7df1e" },
  { extension: 'ts',   name: 'TypeScript', color: "#3178c6" },
  { extension: 'php',  name: 'PHP', color: "#777bb4" },
  { extension: 'py',   name: 'Python', color: "#3776ab" }, 
  { extension: 'java', name: 'Java', color: "#007396" },
  { extension: 'kt',   name: 'Kotlin', color: "#7f52ff" },
  
  # データ形式
  { extension: 'json', name: 'JSON', color: "#ffffff" },
  { extension: 'yaml', name: 'YAML', color: "#ffffff" },
  { extension: 'yml',  name: 'YAML', color: "#ffffff" },
  { extension: 'csv',  name: 'CSV', color: "#237346" },
  
  # テキスト/その他
  { extension: 'txt',  name: 'Plain Text', color: "#cccccc" },
  { extension: 'md',   name: 'Markdown', color: "#083fa1" },
  { extension: 'sh',   name: 'Shell Script', color: "#4eaa25" },
  { extension: 'sql',  name: 'SQL', color: "#dd8a00" }
]
# ActiveRecord::Base.transaction ↓
# ここでのデータベース操作は「全部成功」か「全部失敗」のどちらか
# 例: 1つでも失敗したら全てロールバック（取り消し）
ActiveRecord::Base.transaction do
  language_data.each do |data|
    Language.find_or_create_by!(extension: data[:extension]) do |lang|
      lang.name = data[:name]
      lang.color = data[:color]
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
