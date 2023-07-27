class AnaliticsController < ApplicationController
  def get_data
    AnalyticUpdater.call(params_visitor: params[:visitor]) if params[:visitor].present?

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