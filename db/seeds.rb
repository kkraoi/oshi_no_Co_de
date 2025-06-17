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
  { extension: 'html', name: 'HTML', color: "#B25F28" },
  { extension: 'htm',  name: 'HTML', color: "#B25F28" },
  { extension: 'xhtml', name: 'XHTML', color: "#AF5E28" },
  { extension: 'xml',  name: 'XML', color: "#B66129" },
  
  # スタイルシート
  { extension: 'css',  name: 'CSS', color: "#2965f1" },
  { extension: 'scss', name: 'Sass', color: "#AB3C5E" },
  { extension: 'sass', name: 'Sass', color: "#AB3C5E" },
  { extension: 'less', name: 'LESS', color: "#3F7790" },
  
  # プログラミング言語
  { extension: 'rb',   name: 'Ruby', color: "#A33236" },
  { extension: 'erb',  name: 'ERB', color: "#A33236" },
  { extension: 'js',   name: 'JavaScript', color: "#A2A234" },
  { extension: 'ts',   name: 'TypeScript', color: "#417B95" },
  { extension: 'php',  name: 'PHP', color: "#805D9D" },
  { extension: 'py',   name: 'Python', color: "#417B95" }, 
  { extension: 'java', name: 'Java', color: "#A33236" },
  { extension: 'kt',   name: 'Kotlin', color: "#B66129" },
  { extension: 'go',   name: 'Go', color: "#417B95" },
  { extension: 'rs',   name: 'Rust', color: "#57666B" },
  { extension: 'c',   name: 'C', color: "#417B95" },
  { extension: 'cpp',   name: 'C++', color: "#417B95" },
  { extension: 'cc',   name: 'C++', color: "#417B95" },
  { extension: 'cxx',   name: 'C++', color: "#417B95" },
  { extension: 'cs',   name: 'C#', color: "#417B95" },
  { extension: 'swift',   name: 'Swift', color: "#B66129" },
  
  # データ形式
  { extension: 'json', name: 'JSON', color: "#A2A234" },
  { extension: 'yaml', name: 'YAML', color: "#805D9D" },
  { extension: 'yml',  name: 'YAML', color: "#805D9D" },
  { extension: 'csv',  name: 'CSV', color: "#719A3A" },
  
  # テキスト/その他
  { extension: 'txt',  name: 'Plain Text', color: "#A6A9A8" },
  { extension: 'md',   name: 'Markdown', color: "#417B95" },
  { extension: 'sh',   name: 'Shell Script', color: "#719A3A" },
  { extension: 'sql',  name: 'SQL', color: "#C4426A" }
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
