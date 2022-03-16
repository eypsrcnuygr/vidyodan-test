require 'pry'

class TradesController < ApplicationController
  rescue_from ActionController::MethodNotAllowed, with: :not_allowed
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  def index
    @trades = Trade.all unless params[:user_id] && params[:trade_type]
    @trades = Trade.where(trade_type: params[:trade_type]) if params[:trade_type]
    @trades = Trade.where(user_id: params[:user_id]) if params[:user_id]
    render json: TradesSerializer.new(@trades).to_serialized_json_all, status: 200
  end

  def create
    @trade = Trade.create(set_params)
    time_stamp_value = params[:timestamp].to_i / 1000
    @trade.timestamp = DateTime.strptime("#{time_stamp_value}",'%s')
    render json: TradesSerializer.new(@trade).to_serialized_json, status: 201
  end

  def show
    @trade = Trade.find(params[:id])

    if @trade
      render json: TradesSerializer.new(@trade).to_serialized_json, status: 200
    else
      render :json 
    end
  end

  def update
    raise ActionController::MethodNotAllowed
  end

  def destroy
    raise ActionController::MethodNotAllowed
  end


  private


  def record_not_found(exception)
    render json: {error: exception.message}.to_json, status: 404
    return
  end

  def not_allowed(exception)
    render json: {error: exception.message}.to_json, status: 405
    return
  end

  def set_params
    params.permit(:trade_type, :user_id, :symbol, :shares, :price, :timestamp)
  end
end