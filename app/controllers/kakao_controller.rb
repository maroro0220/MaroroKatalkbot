class KakaoController < ApplicationController
  def keyboard
    home_keyboard = {
  :type => "text", #해쉬형태로 바꿈. type: "text"이렇게도 됨. 원래 buttons였는데 text로 바꿈.
  #우리는 text입력을 받을거여서. button형태로 입력받으려면 buttons쓰면됨. button형태 입력은 질문 값이 버튼에 다 들어있음
  # :buttons => ["선택 1", "선택 2", "선택 3"]  # buttons: []
    }
    render json: home_keyboard
  end

  def message
    user_message = params[:content]
    return_message = {
      :message => {
        :text => user_message
      },# message: {}
      :keyboard => {
        :type => "text"
      } #keyboard: {}
    }
    render json: return_message
  end
end
