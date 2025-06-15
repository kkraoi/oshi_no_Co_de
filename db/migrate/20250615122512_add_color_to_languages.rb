class AddColorToLanguages < ActiveRecord::Migration[6.1]
  def change
    add_column :languages, :color, :string, default: "none", null: false

    # 既存のデータは取り柄あえず"none"
    Language.update_all(color: "none")
  end
end
