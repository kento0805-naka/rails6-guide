class Admin::Authenticator
    def initialize(admin_member)
        @admin_member = admin_member
    end

    def authenticate(raw_password)
        @admin_member &&
            @admin_member.hashed_password &&
            BCrypt::Password.new(@admin_member.hashed_password) == raw_password
    end
end