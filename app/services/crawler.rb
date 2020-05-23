class Crawler
  require "open-uri"
  
  def initialize(url)
    @page = Nokogiri::HTML(open(url, headers).read)
  end

  def subject
    result = @page.css("title").first
    if result && result.text.present?
      result.text
    else
      "This page has no title. Maybe you should append some of it."
    end
  end

  def summary
    result = @page.css("meta[name=description]").first
    if result && result.attr("content").present?
      result.attr("content")[0..200]
    else
      "This page has no summary. Maybe you should append some of it."
    end
  end

  private
  def headers
    {'User-Agent' => 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/81.0.4044.138 Mobile Safari/537.36'}
  end

end

# # 把以下整串取消一層井字號即可正常做單檔案測試
# # 專案中只要在controller內直接使用即可。
# # 以下是用法：
# url = "https://5xruby.tw/"
# crawler = Crawler.new(url)
# p crawler.subject# => "五倍紅寶石｜專業程式教育機構｜實戰轉職訓練"
# p crawler.summary# => "五倍紅寶石擁有業界強大師資群，程式課程多元豐富，提供實體線上課程選擇，由20年業界經驗的高見龍領軍，經驗值滿點助教群，專業年輕的服務團隊。"
