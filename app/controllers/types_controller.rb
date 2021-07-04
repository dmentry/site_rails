class TypesController < ApplicationController
  def index
    types = Type.select(:id)

    @recent = []

    types.each do |type|
      recent_photos = Photo.where('type_id = ?', type).order(created_at: :desc).limit(2)

      @recent << recent_photos
    end

    @recent
  end

end