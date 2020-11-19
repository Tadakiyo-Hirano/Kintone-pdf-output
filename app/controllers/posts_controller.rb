class PostsController < ApplicationController
  before_action :authenticate_user!
  
  def show
    record_id = params[:id]
    api = Kintone::Api.new("#{ENV['DOMAIN']}.cybozu.com", ENV['ID'], ENV['PASSWORD'])
    url = "https://#{ENV['DOMAIN']}.cybozu.com/k/v1/record.json"
    uri = URI.parse(url)
    api_token = ENV['TOKEN']
    req = Net::HTTP::Get.new(uri.path)
    req['X-Cybozu-API-Token'] = api_token
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate({"app": "62", "id": record_id })

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
      res = http.request(req)
      case res.code.to_i
      when 200
        @post = JSON.parse(res.body)
        # @post = JSON.pretty_generate(JSON.parse(res.body))
      else
        %Q(#{res.code} #{res.message})
        JSON.parse(res.body)
      end
    }
    
    respond_to do |format|
      format.html
      format.pdf do
        pdf = KintonePdf.new(@post)

        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.render,
          filename:    "全農あきた発注書#{@post['record']['date']['value']}.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end

  def index
    api = Kintone::Api.new("#{ENV['DOMAIN']}.cybozu.com", ENV['ID'], ENV['PASSWORD'])

    url = "https://#{ENV['DOMAIN']}.cybozu.com/k/v1/records/cursor.json"
    uri = URI.parse(url)
    api_token = ENV['TOKEN']
    req = Net::HTTP::Post.new(uri.path)
    req['X-Cybozu-API-Token'] = api_token
    req['Content-Type'] = 'application/json'
    fields = ["レコード番号", "date", "table"]
    # query = %q(金額 >= "50000")
    query = ""
    req.body = JSON.generate({"app" => "62", "fields" => fields, "query" => query, "totalCount" => true, "size" => "500"})
    cursor = ""
    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
      res = http.request(req)
      case res.code.to_i
      when 200
        JSON.parse(res.body)
        cursor = JSON.parse(res.body)["id"]
        cursor
      else
        %Q(#{res.code} #{res.message})
        JSON.parse(res.body)
      end
    }

    req = Net::HTTP::Get.new(uri.path)
    req['X-Cybozu-API-Token'] = api_token
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate({"id" => cursor})
    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
      res = http.request(req)
      case res.code.to_i
      when 200
        JSON.pretty_generate(JSON.parse(res.body))
        @post = JSON.pretty_generate(JSON.parse(res.body))
        # @post = JSON.pretty_generate(JSON.parse(res.body)["records"].find { |h| h['レコード番号']['value'] == '2' }['ea']['value'])
        # @post = JSON.parse(res.body)["records"].find { |h| h['レコード番号']['value'] == '2' }['ea']['value']
        # @post2 = JSON.parse(res.body)["records"].find { |h| h['レコード番号']['value'] == '2' }['ja_code']['value']
        # @post3 = JSON.parse(res.body)["records"].find { |h| h['レコード番号']['value'] == '2' }['ja']['value']
        # @post4 = JSON.parse(res.body)["records"].find { |h| h['レコード番号']['value'] == '2' }['ja_price']['value']
      else
        %Q(#{res.code} #{res.message})
        JSON.parse(res.body)
      end
    }
    # render json: @post
  end
end
