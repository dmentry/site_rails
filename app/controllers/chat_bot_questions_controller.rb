class ChatBotQuestionsController < ApplicationController
  before_action :set_chat_bot_topic, only: [:index, :new, :create, :destroy, :update, :edit]
  before_action :chat_bot_question, only: [:destroy, :edit, :update]

  def index
    @nav_menu_active_item = 'nav_admin'

    chat_bot_questions = @chat_bot_topic.chat_bot_questions
           
    @chat_bot_questions = chat_bot_questions.order(order: :asc)
  end

  def new
    @nav_menu_active_item = 'nav_admin'

    @chat_bot_question = @chat_bot_topic.chat_bot_questions.build

    new_order_number = if @chat_bot_topic.chat_bot_questions.size == 1
                         1
                       elsif @chat_bot_topic.chat_bot_questions.size > 1
                         @chat_bot_topic.chat_bot_questions.pluck(:order).max + 1
                       end

    @chat_bot_question.order = new_order_number
  end

  def create
    @chat_bot_question = @chat_bot_topic.chat_bot_questions.build(chat_bot_question_params)

    if @chat_bot_question.save
      redirect_to chat_bot_topic_chat_bot_questions_path(@chat_bot_topic), notice: "Реплика успешно создана."
    else
      flash.now[:alert] = 'Реплику добавить не удалось!'
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @nav_menu_active_item = 'nav_admin'
  end

  def update
    if @chat_bot_question.update(chat_bot_question_params)
      redirect_to chat_bot_topic_chat_bot_questions_path(@chat_bot_topic), notice: "Реплика успешно отредактирована."
    else
      flash.now[:alert] = 'Реплику добавить не удалось!'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @chat_bot_question.destroy!
      message = { notice: 'Реплика удалена успешно.' }
    else
      message = { alert: 'Реплика не была удалена.' }
    end

    redirect_to chat_bot_topic_chat_bot_questions_path(@chat_bot_topic), message
  end

  private

  def set_chat_bot_topic
    if params[:chat_bot_topic_id].present? && params[:chat_bot_topic_id]&.match?(/\A\d+\z/)
      @chat_bot_topic = ChatBotTopic.where(id: params[:chat_bot_topic_id]).first

      redirect_to root_path if !@chat_bot_topic
    else
      redirect_to root_path
    end
  end

  def chat_bot_question
    if params[:id].present? && params[:id]&.match?(/\A\d+\z/)
      @chat_bot_question = @chat_bot_topic.chat_bot_questions.where(id: params[:id]).first

      redirect_to root_path if !@chat_bot_question
    else
      redirect_to root_path
    end
  end

  def chat_bot_question_params
    params.require(:chat_bot_question).permit(:body_ru, :body_en, :order, :next_id)
  end

end
