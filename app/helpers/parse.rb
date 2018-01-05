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

      def momo
        url = "http://www.arthousemomo.co.kr"
        movie_html = RestClient.get(url)
        doc = Nokogiri::HTML(movie_html)
        movie_list=Array.new
        time_list=Array.new

        movie_hash=Hash.new

        i=0
        movie=doc.css('div.widget.article-list-14 h5').text+"\n"+"\n"
        doc.css('div.time-box ul li').each do |m|
          if i%2==0
            time_list << m.text
          else
            movie_list << m.css('a').text
          end
          i=i+1
        end
        k=1
        for i in (0..time_list.length-1)
          if time_list[i].to_s[0]=="1" && time_list[i].to_s[1]=="0"&&k<3
            movie=movie+k.to_s+"관"+"\n"
            k=k+1
          end
          movie = movie + time_list[i].to_s  + " - " + movie_list[i].to_s+"\n"
          if time_list[i].to_s[0]=="2"&& k<2
            movie=movie+"\n"
          end
        end
        bot_message = movie
        return bot_message
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
