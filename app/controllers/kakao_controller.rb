require 'parse'
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
    image = false
    user_message = params[:content]
    if user_message == '메뉴'
        menus =["20", "대독장", "부대찌개", "순남", "버거킹"]
        bot_message = menus.sample
    elsif user_message =='로또'
        lotto=(1..45).to_a.sample(6).to_s
        bot_message=lotto
    elsif user_message == '박민정'
        bot_message="♡♥♡♥♡♥♡♥"
    elsif user_message =='냥이' || user_message=='고양이'|| user_message=='ㄱㅇㅇ'
      #app-helpers-parse.rb-Animal-cat
      image = true
      parser = Parse::Animal.new  #class로 접근하려고 ::
      bot_message = parser.cat[0]
      img_url = parser.cat[1]
      # parser.cat=[bot_message, img_url]
    elsif user_message =='영화'
      image=true
      parser=Parse::Movie.new
      movie=parser.naver
      bot_message = movie[0]
      img_url = movie[1]
      # bot_message = sample_movie +" - "+ movie_hash[sample_movie]
    elsif user_message =='모모'
      parser=Parse::Movie.new
      movie=parser.momo
      bot_message=movie
    else
        bot_message="Nop. '메뉴' or '로또' or 'ㄱㅇㅇ'"
    end
    return_message = {
      :message => {
        :text => bot_message
      },# message: {}
      :keyboard => {
        :type => "text"
      } #keyboard: {}
    }
    return_message_with_img = {
      :message => {:text => bot_message,
                    :photo => {
                      :url => img_url,
                      :width =>640,
                      :height => 480
                      }
                    },
      :keyboard => {type: "text"}
    }
    if image
      render json: return_message_with_img
    else
      render json: return_message
    end
  end
end
