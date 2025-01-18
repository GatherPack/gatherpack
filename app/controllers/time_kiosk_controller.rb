class TimeKioskController < ApplicationController
  def index
  end

  def create
    @token = policy_scope(Token).find_by_rfid(time_kiosk_params[:token_id])

    if @token&.tokenable_type == "Hook"
      @hook = policy_scope(Hook).find_by_id(@token.tokenable_id)
      @hook.run(@hook.code)
      puts "Ran Hook \"#{@hook.identifier_name}\""
    end

    puts @token&.value
    render :index
  end

  private

    def time_kiosk_params
      params.require(:time_kiosk).permit(:token_id)
    end
end
