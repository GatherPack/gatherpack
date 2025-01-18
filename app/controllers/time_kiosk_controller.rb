class TimeKioskController < ApplicationController
  def index
    @accept_input = true
    @message = {}
    render layout: "kiosk"
  end

  def create
    @token = Token.find_by_rfid(time_kiosk_params[:token_id])
    @accept_input = true
    @message = {}

    unless @token
      @message[:danger] = "Invalid Token"
    end

    case @token&.tokenable_type
    when "Hook"
      @hook = Hook.find_by_id(@token.tokenable_id)
      @message[:info] = @hook.run(@hook.code)
    when "Person"
      @person = Person.find_by_id(@token.tokenable_id)

      current_punches = TimeClockPunch.all.where(person: @person, end_time: nil)
      current_punches.each do |punch|
        punch.update!(end_time: Time.now)
        @message[:info] = "Punched out #{@person.identifier_name}"
      end

      if current_punches.empty?
        @accept_input = false
      end
    end

    render :index, layout: "kiosk"
  end

  private

    def time_kiosk_params
      params.require(:time_kiosk).permit(:token_id)
    end
end
