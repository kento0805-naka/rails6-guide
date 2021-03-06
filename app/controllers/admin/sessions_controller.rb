class Admin::SessionsController < Admin::Base
    def new
        if current_administrator
            redirect_to admin_root
        else
            @form = Admin::LoginForm.new
            render action: "new"
        end
    end

    def create
        @form = Admin::LoginForm.new(login_form_params)
        if @form.email.present?
            admin_member =
                Administrator.find_by("LOWER(email) = ?", @form.email.downcase)
        end
        if Admin::Authenticator.new(admin_member).authenticate(@form.password)
            session[:administrator_id] = admin_member.id
            flash.notice = "ログインしました"
            redirect_to :admin_root
        else
            flash.now.alert = "メールアドレスまたはパスワードが正しくありません"
            render action: "new"
        end
    end

    def destroy
        session.delete(:administrator_id)
        flash.notice = "ログアウトしました"
        redirect_to :admin_root
    end

    private def login_form_params
        params.require(:admin_login_form).permit(:email, :password)
    end
end
