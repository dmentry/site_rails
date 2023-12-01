class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :registerable, :trackable and :omniauthable, :registerable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  has_many :photos
end
