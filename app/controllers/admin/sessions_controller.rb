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
        @form = Admin::LoginForm.new(params[:admin_login_form])
        if @form.email.present?
            admin_member =
                Administrator.find_by("LOWER(email) = ?", @form.email.downcase)
        end
        if admin_member
            session[:administrator_id] = admin_member.id
            redirect_to :admin_root
        else
            render action: "new"
        end
    end
end
