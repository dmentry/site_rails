class AnalyticsController < ApplicationController
  def get_data
    current_user_present = if current_user
                             true
                           else
                             false
                           end

    AnalyticUpdater.call(params_visitor: params[:visitor], current_user_present: current_user_present) if params[:visitor].present?

    head :ok
  end

  def show_visitors_info
    @pagy, @visitors = pagy(Visitor.where(uniq_visitor: true).order(created_at: :desc), items: Visitor::VISITORS_ON_PAGE)

    authorize @visitors
  end

  def show_visitor_info
    source = Visitor.where(u_id: params[:u_id]).order(created_at: :desc)

    @pagy, @visitor = pagy(source, items: Visitor::VISITORS_ON_PAGE)

    @visitor_all_visits = source.count

    authorize @visitor
  end

  def show_visits
    all_visits_uniq = 0
    all_visits_repeat = 0

    Analytic.all.each do |analytic|
      all_visits_uniq += analytic.uniq_visitor
      all_visits_repeat += analytic.repeat_visitor
    end

    @all_visits_uniq = all_visits_uniq
    @all_visits_repeat = all_visits_repeat

    if current_user
      authorize current_user
    else
      user_not_authorized
    end
  end
end
