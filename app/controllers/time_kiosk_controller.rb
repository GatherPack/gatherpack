class TimeKioskController < ApplicationController
  def index
  end

  def create
    @token = policy_scope(Token).find_by_rfid(time_kiosk_params[:token_id])

    puts @token.value
  end

  private

    def time_kiosk_params
      params.require(:time_kiosk).permit(:token_id)
    end
end
