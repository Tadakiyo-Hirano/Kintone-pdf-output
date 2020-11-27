class KintoneApp < ApplicationRecord
  validates :app_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :domain, presence: true, length: { maximum: 100 }
  validates :k_id, presence: true, length: { maximum: 100 }
  validates :k_pass, presence: true, length: { maximum: 100 }
  validates :token, presence: true, length: { maximum: 100 }
end
