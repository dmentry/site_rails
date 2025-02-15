class ChatBotTopicsController < ApplicationController
  before_action :set_chat_bot_topic, only: [:edit, :update, :destroy, :show]

  def index
    @nav_menu_active_item = 'nav_admin'

    @chat_bot_topics = ChatBotTopic.all.order(show_order: :asc)
  end

  def show
  end

  def new
    @nav_menu_active_item = 'nav_admin'

    @chat_bot_topic = ChatBotTopic.new
  end

  def create
    @chat_bot_topic = ChatBotTopic.new(chat_bot_topic_params)

    if @chat_bot_topic.save
      redirect_to @chat_bot_topic, notice: 'Тема добавлена успешно!'
    else
      flash.now[:alert] = 'Тему добавить не удалось!'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @nav_menu_active_item = 'nav_admin'
  end

  def update
    if @chat_bot_topic.update(chat_bot_topic_params)
      redirect_to @chat_bot_topic, notice: 'Тема обновлена успешно!'
    else
      flash.now[:alert] = 'Тему обновить не удалось!'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @chat_bot_topic.destroy

    redirect_to chat_bot_topics_path, notice: ('Тема удалена')
  end

  def have_answer
    language_en = false
    language_en = true if params[:language_en].present?

    if params[:next_id].is_a?(Array) && !params[:next_id].all? { |item| item.to_s =~ /\A\d+\z/ }
      render json: { success: false, message: "Invalid input" }, status: :unprocessable_entity
      return
    end

    if params[:topic_id].present? && !params[:topic_id].match?(/\A\d+\z/)
      redirect_to root_path, notice: ('Что-то пошло не так с чат-ботом')
      return
    end

    out = if !(params[:next_id].present? && params[:topic_id].present?)
            first_time_data(language_en)
          else
            current_data(topic_id: params[:topic_id].to_i, next_id: params[:next_id], language_en: language_en)
          end

    respond_with out.to_json
  end

  private

  def set_chat_bot_topic
    if params[:id].present? && params[:id]&.match?(/\A\d+\z/)
      @chat_bot_topic = ChatBotTopic.where(id: params[:id]).first

      redirect_to root_path if !@chat_bot_topic
    else
      redirect_to root_path
    end
  end

  def chat_bot_topic_params
    params.require(:chat_bot_topic).permit(:label_ru, :label_en, :show_order)
  end

  def first_time_data(language_en)
    out=[]

    ChatBotTopic.visible_topics.each do |cbt|
      cbq = cbt.chat_bot_questions.where(order: 1).first

      next if !cbq

      next_ids_arr = cbq.next_id.scan(/\d+/).map(&:to_i)

      next_ids_arr = nil if next_ids_arr.size <= 0

      body =  if language_en
                cbq.body_en
              else
                cbq.body_ru
              end

      out << { label: body, next_id: next_ids_arr, topic_id: cbt.id }
    end

    out
  end

  def current_data(topic_id:, next_id:, language_en:)
    out=[]

    cbt = ChatBotTopic.where(id: topic_id).first

    cbqs = cbt&.chat_bot_questions&.where(order: next_id)&.order(:order)

    cbqs.each do |cbq|
      next_ids_arr = cbq.next_id.scan(/\d+/).map(&:to_i)

      next_ids_arr = nil if next_ids_arr.size <= 0

      body =  if language_en
                cbq.body_en
              else
                cbq.body_ru
              end

      out << { label: body, next_id: next_ids_arr, topic_id: cbt.id }
    end

    out
  end

end
