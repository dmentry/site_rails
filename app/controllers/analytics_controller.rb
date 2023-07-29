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
    @pagy, @visitors = pagy(Visitor.where(uniq_visitor: true), items: Visitor::VISITORS_ON_PAGE)

    authorize @visitors
  end

  def show_visitor_info
    @pagy, @visitor = pagy(Visitor.where(u_id: params[:u_id]), items: Visitor::VISITORS_ON_PAGE)

    authorize @visitor
  end

  def show_visits
    @visits = Analytic.all

    authorize @visits
  end
end
