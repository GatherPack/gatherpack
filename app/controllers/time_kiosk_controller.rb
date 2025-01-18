class TimeKioskController < ApplicationController
  def index
  end

  def create
    @token = policy_scope(Token).find_by_value(normalize_id(time_kiosk_params[:token_id]))

    puts @token
  end

  private

    def time_kiosk_params
      params.require(:time_kiosk).permit(:token_id)
    end

    def normalize_id(rfid)
      if rfid.to_s.match?(/\A5700[0-9a-fA-F]+\z/)
        rfid = rfid.to_s[4..-1].to_i(16).to_s
      end

      rfid
    end
end
