class CreateCountries < ActiveRecord::Migration[6.1]
  def change
    create_table :countries do |t|
      t.string :code, null: false, uniq: true, index: true
      t.string :title_ru, null: false
      t.string :title_en, null: false
      t.jsonb :id_types, default: []

      t.timestamp :archived_at
      t.timestamps
    end
  end
end
