class Type < ApplicationRecord
  has_many :photos

  def translated_name
    I18n.t(photo_type, :scope => 'models.type')
  end
end
