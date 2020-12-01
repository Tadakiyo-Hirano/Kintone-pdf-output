class KintoneAppsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_app
  before_action :set_domain

  def show
  end

  def edit
  end

  def update
    @oid_app = @app.app_id
    if @app.update_attributes(app_params)
      if @oid_app != @app.app_id
        flash[:notice] = "アプリIDを#{@oid_app}から#{@app.app_id}へ更新しました。"
      end
      redirect_to @app
    else
      str = @app.errors.full_messages.to_sentence
      flash[:notice] = str.gsub!("App","アプリID")
      render :edit
    end
  end

  def domain_update
    if @domain.update_attributes(domain_params)
      flash[:notice] = "ドメイン情報を更新しました。"
      redirect_to @domain
    else
      str = @domain.errors.full_messages.to_sentence
      flash[:notice] = str.gsub(/Domain|K|pass|Token/, "Domain" => "ドメイン", "K" => "ID", "pass" => "パスワード", "Token" => "トークン")
      render :edit
    end
  end

  private

    def set_app
      @app = KintoneApp.find(params[:id])
    end

    def set_domain
      @domain = KintoneApp.find(params[:id])
    end

    def app_params
      params.require(:kintone_app).permit(:app_id)
    end

    def domain_params
      params.require(:kintone_app).permit(:domain, :k_id, :k_pass, :token)
    end
end
