# app/models/concerns/hashtaggable.rb
module Hashtaggable
  extend ActiveSupport::Concern

  included do
    has_many :entity_hashtags, as: :entity, dependent: :destroy
    has_many :hashtags, through: :entity_hashtags

    attr_accessor :hashtag_names

    after_commit :process_hashtags, on: [:create, :update]
  end

  def hashtag_names
    @hashtag_names || hashtags.pluck(:name).join(',')
  end

  def hashtag_names=(names_string)
    @hashtag_names = names_string.presence
  end

  private

  def process_hashtags
    return unless @hashtag_names
    
    ActiveRecord::Base.transaction do
      # Получаем массив имен хэштегов
      hashtag_names_array = @hashtag_names.split(',')
                                          .map(&:strip)
                                          .reject(&:blank?)
                                          .map { |name| normalize_hashtag_name(name) }
                                          .uniq

      # Находим или создаем хэштеги
      hashtag_objects = hashtag_names_array.map do |name|
        next if name.blank?
        Hashtag.find_or_create_by!(name: name)
      end.compact

      # Обновляем связь
      self.hashtags = hashtag_objects
    end

    # Очищаем временную переменную
    @hashtag_names = nil
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:hashtag_names, "contains invalid hashtag: #{e.message}")
    raise ActiveRecord::Rollback
  end

  def normalize_hashtag_name(name)
    # Удаляем все символы, кроме букв, цифр и подчеркиваний
    # Разрешаем кириллицу и другие языки
    name.gsub(/[^\p{Word}]/, '').downcase
  end
end