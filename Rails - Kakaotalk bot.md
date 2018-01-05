#Rails - Kakaotalk bot

Rails – 설정보다 규약(CoC:convention over configuration). 중복 되게 쓰지 말기

---

 

플러스친구 관리자센터에서 플러스 친구 만들고

왼쪽에

스마트 채팅 – api형 – apidocument 

```console
$rails new kakaobot

$ rails g controller kakao keyboardmessage
```

app-controller-kakao_controller.erb

```ruby
#application_controller.rb   
  # protect_from_forgery with: :exception
  # protect이거 보안 관련된거라 주석처리
```



 

kakao플러스친구 관리자 센터 apisepc에서 homekeyboard api에 예제를

kakao_controller.rb에 keyboard에 붙여넣기

그리고 hash형태로 바꾸기 

 ```ruby 
#kakao_controller.rb
def keyboard

    home_keyboard = {#처음 채팅방에 들어가면 띄워주는게 home_keyboard

  #:type => "buttons", #해쉬형태로 바꿈
  #type: "buttons", #해쉬형태로 바꿈
  :type => "text", #button형태를 text형태로 바꿈
  #:buttons => ["선택 1", "선택 2", "선택 3"]
    }
    render json: home_keyboard

  end

 ```

---

#### 메시지 수신

| 필드명      | 타입     | 필수여부     | 설명                              |
| -------- | ------ | -------- | ------------------------------- |
| user_key | String | Required | 메시지를 발송한 유저 식별 키                |
| type     | String | Required | text, photo                     |
| content  | String | Required | 자동응답 명령어의 메시지 텍스트 혹은 미디어 파일 uri |

params[]로 받아옴. 

카톡 서버를 거쳐서 어떤 사람이 보냈는지랑 어떤 메시지인지, 그리고 메시지 값이 전달됨.

```ruby
#  kakao_controller.rb
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
```

```ruby
  get '/keyboard' => 'kakao#keyboard'

  get '/message' => 'kakao#message'
  post '/message' => 'kakao#message'
```

---

### Heroku Deploy

```ruby
#gemfile
gem 'sqlite3', :group => :development
gem 'pg', :group => :production   #heroku에선 pg를 씀
gem 'rails_12factor', :group => :production
```

```ruby
#config-database.yml
# 변경전
# production:
#   <<: *default
#   database: db/production.sqlite3

# 변경후
production:
  <<: *default
  adapter: postgresql
  encoding: unicode

```



```console
$bundle install
만약 에러나면
$sudo apt-get install libpq-dev
$gem install heroku
$heroku login
```

heroku email이랑 pw치고 로그인

```console
$git init
$git add .
$git commit -m "maroro katalk bot"
$heroku create marorobot
$git push heroku master
```

완료되면 https://marorokabot.herokuapp.com/ 이런 서버 주소가 나오는데

들어가보기. 그냥 들어가면 index가 없어서 에러나니깐 

https://marorokabot.herokuapp.com/ keyboard 해서 들어가보기

그리고

플러스친구 관리자센터에서

스마트채팅- api형에서

앱등록

앱URL에 https://marorokabot.herokuapp.com 입력하고 API테스트(마지막에 / 빼기)

그리고 시작하기 누르기

관리에서 공개설정 on으로 하기

---

#### 응답

```ruby
#kakaocontroller에 message에 추가 
if user_message == '메뉴'
    menus =["20", "대독장", "부대찌개", "순남", "버거킹"]
    user_message = menus.sample
elsif user_message =='로또'
    lotto=(1..45).to_a.sample(6)
    user_message=lotto
else 
  user_message="Nop. '메뉴' or '로또'"
end
```
```console
$git add .
$git commit -m "menu function add"
$git push heroku master
```

---

#### message

```ruby

```



catapi 검색해서 찾기 (고양이 사진 뽑아주는 사이트)

view documentation - example -h ttp://thecatapi.com/api/images/get?format=xml&results_per_page=20

result_per_page=20 빼면 20장 말고 1장만

```ruby
#kakao_controller.rb
elsif user_message =='냥이'
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"

```

```ruby
gem 'rest-client'
gem 'nokogiri'
```

추가하기

```console
$ bundle install
```

```ruby
  elsif user_message =='냥이' || user_message=='고양이'|| user_message=='ㄱㅇㅇ'
      bot_message="나만 고양이 없어"
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = RestClient.get(url)
      doc = Nokogiri::XML(cat_xml)
      cat_url = doc.xpath("//url").text#url에 접근해서 안에 있는 text만 가져옴
      image = true
end
```

```ruby
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
```

위에도 다 채팅에 보여주는 메시지는 bot_message로 바꿈

---

# Module

app-helpers에   parse.rb만들기

```ruby
module Parse
  class Movie
      def naver
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
            :star => movie.css('dl.info_star span.num').text,
            :url => movie.css('div.thumb img').attribute('src').to_s
          }
          # movie.css('dd.star dl.info_star dd div.star_t1 a span.num').text
          #<<는 movie_list배열에 하나씩 넣는다
        end
        sample_movie = movie_list.sample
        bot_message = sample_movie +" - "+ movie_hash[sample_movie][:star]
        img_url = movie_hash[sample_movie][:url]
        return [bot_message, img_url]
      end
  end

  class Animal
    def cat
      bot_message="나만 고양이 없어"
      url = "http://thecatapi.com/api/images/get?format=xml&type=jpg"
      cat_xml = RestClient.get(url)
      doc = Nokogiri::XML(cat_xml)
      img_url = doc.xpath("//url").text#url에 접근해서 안에 있는 text만 가져옴
      return [bot_message, img_url] #없어도 됨. 자동으로 해줌
    end
  end
end

```

controller에서 소스 가져와서 넣기

```ruby
#kakao_controller.rb  
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
```







---



[참고1](https://github.com/och8808/kakao_bot_sample)

[참고2](https://github.com/classHANA?tab=repositories)

