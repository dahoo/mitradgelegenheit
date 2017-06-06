# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  created_at             :datetime
#  updated_at             :datetime
#  admin                  :boolean          default(FALSE), not null
#  name                   :string(255)      default(""), not null
#  guest                  :boolean          default(FALSE)
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :rememberable, :trackable, :validatable,
    :recoverable

  has_many :tracks

  validates :name, presence: true, allow_blank: false

  has_settings do |s|
    s.key :email, defaults: {
      new_track: true,
      new_comment: true,
      admin_new_comment: true
    }
  end

  scope :admin, -> { where admin: true }
  scope :by_admin, -> { order 'admin DESC' }
  scope :by_name, -> { order :name }

  alias_attribute :admin?, :admin
end
