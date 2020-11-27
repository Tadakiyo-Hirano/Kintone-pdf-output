class AddDomainsToKintoneApps < ActiveRecord::Migration[6.0]
  def change
    add_column :kintone_apps, :domain, :string
    add_column :kintone_apps, :k_id, :string
    add_column :kintone_apps, :k_pass, :string
    add_column :kintone_apps, :token, :string
  end
end
