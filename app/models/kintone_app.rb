class KintoneApp < ApplicationRecord
  validates :app_id, numericality: { only_integer: true, greater_than: 0 }
  validates :domain, length: { maximum: 100 }
  validates :k_id, length: { maximum: 100 }
  validates :k_pass, length: { maximum: 100 }
  validates :token, length: { maximum: 100 }
end
