class AnaliticsController < ApplicationController
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
    @visitors = Visitor.where(uniq_visitor: true)

    authorize @visitors
  end

  def show_visits
    @visits = Analytic.all

    authorize @visits
  end
end