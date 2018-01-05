class KakaoController < ApplicationController
  def keyboard
    home_keyboard = {
  :type => "text" #해쉬형태로 바꿈. type: "text"이렇게도 됨. 원래 buttons였는데 text로 바꿈.
  #우리는 text입력을 받을거여서. button형태로 입력받으려면 buttons쓰면됨. button형태 입력은 질문 값이 버튼에 다 들어있음
  # :buttons => ["선택 1", "선택 2", "선택 3"]  # buttons: []
    }
    render json: home_keyboard
  end

  def message
    user_message = params[:content]
    if user_message == '메뉴'
        menus =["20", "대독장", "부대찌개", "순남", "버거킹"]
        user_message = menus.sample
    elsif user_message =='로또'
        lotto=(1..45).to_a.sample(6)
        user_message=lotto
    else
        user_message="Nop. '메뉴' or '로또'"
    end
    return_message = {
      :message => {
        :text => user_message
      },# message: {}
      :keyboard => {
        :type => "hi!!!"
      } #keyboard: {}
    }
    render json: return_message
  end
end
