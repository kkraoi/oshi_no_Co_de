class AddExtensionToLanguages < ActiveRecord::Migration[6.1]
  def change
    add_column :languages, :extension, :string, null: false
  end
end
