class NewPostsController < ApplicationController
  def show
    k = KintoneApp.find(1)
    record_id = params[:id]
    api = Kintone::Api.new("#{k.domain}.cybozu.com", k.k_id, k.k_pass)
    url = "https://#{k.domain}.cybozu.com/k/v1/record.json"
    uri = URI.parse(url)
    api_token = k.token
    req = Net::HTTP::Get.new(uri.path)
    req['X-Cybozu-API-Token'] = api_token
    req['Content-Type'] = 'application/json'
    req.body = JSON.generate({"app": KintoneApp.find(1).app_id, "id": record_id })

    Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
      res = http.request(req)
      res.code.to_i
      @post = JSON.parse(res.body)
    }

    respond_to do |format|
      format.html
      format.pdf do
        pdf = NewKintonePdf.new(@post)  

        # disposition: "inline" によりPDFはダウンロードではなく画面に表示される
        send_data pdf.render,
          filename:    "全農あきた発注書#{@post['record']['date']['value']}.pdf",
          type:        "application/pdf",
          disposition: "inline"
      end
    end
  end
end
