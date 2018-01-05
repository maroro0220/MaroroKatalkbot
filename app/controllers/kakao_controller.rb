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
      bot_message="나만 고양이 없어"
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = RestClient.get(url)
      doc = Nokogiri::XML(cat_xml)
      cat_url = doc.xpath("//url").text#url에 접근해서 안에 있는 text만 가져옴
      image = true
    elsif user_message =='영화'
      url = "http://movie.naver.com/movie/running/current.nhn?view=list&tab=normal&order=reserve"
      movie_html = RestClient.get(url)
      doc = Nokogiri::HTML(movie_html)
      movie_list=Array.new
      # movie_rate=Array.new
      movie_hash=Hash.new
      doc.css('ul.lst_detail_t1 li').each do |movie| #ul의 lst클래스에 들어있는 li태그
        movie_title = movie.css('dt a').text
        movie_list << movie_title
        #dt안에 있는 a tag의 text
        # movie_rate << movie.css('dd.star dl.info_star dd div.star_t1 a span.num')
        # movie_hash [ movie.css('dt a').text] = movie.css('dl.info_star span.num')
        movie_hash[movie_title] = {
          :star => movie.css('dl.info_star span.num').text
        }
        # movie.css('dd.star dl.info_star dd div.star_t1 a span.num').text
        #<<는 movie_list배열에 하나씩 넣는다
      end
      sample_movie = movie_list.sample
      bot_message = sample_movie +" - "+ movie_hash[sample_movie][:star]
      # bot_message = sample_movie +" - "+ movie_hash[sample_movie]
    elsif user_message =='모모'
      url = "http://www.arthousemomo.co.kr"
      movie_html = RestClient.get(url)
      doc = Nokogiri::HTML(movie_html)
      # movie_list=Array.new
      time_list=Array.new
      movie_hash=Hash.new
      doc.css('div.time-box ul').each do |movie|
        time_list << movie.css('li.first')
        # movie_list << movie.css('li a').text
        movie_hash[time_list]
      end
      for i in time_list.length
        bot_message = time_list[i] + movie_list[i]
      end
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
                      :url => cat_url,
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
