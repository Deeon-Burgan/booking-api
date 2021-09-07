class ApplicationController < ActionController::Base


    def encode_token(payload)
        payload[:exp] = 7.days.from_now.to_i
        JWT.encode(payload, ENV["JWT_KEY"])
    end

    def decode_token
        if auth_header
            token = auth_header.split(' ')[1]
            begin
                JWT.decode(token, ENV['JWT_KEY'], true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    def current_user
        if decode_token
            user_id = decode_token[0]["user_id"]
            @user = User.find(user_id)
        else
            puts "authentication failed"
        end
    end

    def authorized
        render json: { message: "Please log in" }, status: :unauthorized unless logged_in?
    end

    def logged_in?
        !!current_user
    end

end
