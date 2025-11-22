class HashtagsController < ApplicationController
  def index
    query = params[:q].to_s.strip

    if query.present?
      hashtags = Hashtag.search(query)
      render json: hashtags.map { |h| { id: h.id, name: h.name } }
    else
      render json: []
    end
  end

  # Дополнительный метод для поиска хэштегов по сущности
  def by_entity
    entity_type = params[:entity_type]
    entity_id = params[:entity_id]

    if entity_type.present? && entity_id.present?
      entity = entity_type.constantize.find(entity_id)
      hashtags = entity.hashtags
      render json: hashtags.map { |h| { id: h.id, name: h.name } }
    else
      render json: []
    end
  end
end
