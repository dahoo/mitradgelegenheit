class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :rememberable, :trackable, :validatable,
         :recoverable

  has_many :tracks

  validates :name, presence: true, allow_blank: false

  scope :admin, -> { where admin: true }
  scope :by_admin, -> { order 'admin DESC' }
  scope :by_name, -> { order :name }
end
