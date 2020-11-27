class CreateKintoneApps < ActiveRecord::Migration[6.0]
  def change
    create_table :kintone_apps do |t|
      t.integer :app_id

      t.timestamps
    end
  end
end
