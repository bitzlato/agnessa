class CreateCountries < ActiveRecord::Migration[6.1]
  def change
    create_table :countries do |t|
      t.string :iso_code, null: false, uniq: true, index: true
      t.string :title_ru, null: false, uniq: true
      t.string :title_en, null: false, uniq: true
      t.jsonb :id_types,null: false, default: []

      t.timestamp :archived_at
      t.timestamps
    end
  end
end
