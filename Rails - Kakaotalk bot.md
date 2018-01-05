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
```





---

[참고](https://github.com/och8808/kakao_bot_sample)

