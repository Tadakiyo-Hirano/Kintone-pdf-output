class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # devise :database_authenticatable, :registerable,
  #        :recoverable, :rememberable, :validatable

  devise :database_authenticatable, :rememberable, :validatable, :registerable

  validates :email, uniqueness: true
  validates :username, uniqueness: true

  def remember_me
    true
  end

  def email_required?
    false
  end
  
  def email_changed?
    false
  end

  # Devise使用時に現在のパスワードなしでユーザー情報を更新する
  def update_with_password(params, *options)
    params.delete(:current_password)

    if params[:password].blank?
      params.delete(:password)
      params.delete(:password_confirmation) if params[:password_confirmation].blank?
    end

    result = update(params, *options)

    clean_up_passwords
    result
  end
end
