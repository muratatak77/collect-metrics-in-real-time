class Api::AlertsController < ApplicationController
  before_action :set_alert, only: [:show, :update, :destroy]

  # GET /alerts
  def alert_update
    status = params[:status]
    alert_id = params[:alert_id]

    if alert_id.present? and status.present?
      if Alert.find(alert_id).update(status: status)
        render json: {status: :created}
      else
        render json: {status: :unprocessable_entity}
      end

    end

  end

end
