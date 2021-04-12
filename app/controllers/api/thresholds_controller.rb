class Api::ThresholdsController < ApplicationController
  before_action :set_threshold, only: [:show, :update, :destroy]

  # GET /thresholds
  def index
    @thresholds = Threshold.all
    render json: @thresholds
  end

  # GET /thresholds/1
  def show
    render json: @threshold
  end

  # POST /thresholds
  def create
    @threshold = Threshold.new(threshold_params)

    if @threshold.save
      render json: @threshold, status: :created
    else
      render json: @threshold.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /thresholds/1
  def update
    if @threshold.update(threshold_params)
      render json: @threshold
    else
      render json: @threshold.errors, status: :unprocessable_entity
    end
  end

  # DELETE /thresholds/1
  def destroy
    @threshold.destroy
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_threshold
    @threshold = Threshold.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def threshold_params
    params.require(:threshold).permit(:name, :min, :max)
  end
end
