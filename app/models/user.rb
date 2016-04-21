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
