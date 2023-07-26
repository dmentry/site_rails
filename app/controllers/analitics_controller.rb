class AnaliticsController < ApplicationController
  def get_data
    AnalyticUpdater.call(params_visitor: params[:visitor]) if params[:visitor].present?

    head :ok
  end

  def show_data
  end
end