class ApplicationController < ActionController::API


    def encode_token(payload)

        #set the expiration tome
        payload[:exp] = get_expiration 

        #i just use it to compare, almost irrelevant
        payload[:issued_time] = Time.now.to_i
        
        JWT.encode(payload, secret_key)
    end

    def get_expiration
        time = ENV['JWT_EXPIRATION_IN_MINUTES']
        exp_time = Time.now.to_i + (time.to_i  * 60)
        
        exp_time
    end

    #secret from ENV
    def secret_key
        ENV['SECRET_KEY']
    end
    
    def decoded_token
        if auth_header
            token = auth_header.split(' ')[1]  # [0] Bearer [1]token
            begin
                JWT.decode(token, secret_key, true, algorithm: 'HS256')
            rescue JWT::DecodeError
                nil
            end
        end
    end

    #check if there's a bearer token
    def auth_header 
        request.headers['Authorization']
    end

    # core of the verification
    def is_valid_token
        if decoded_token
            user_id = decoded_token[0]['userid']
            expiration = decoded_token[0]['exp']
            if expiration.to_i < Time.now.to_i     
                nil
            else
                @user = User.find(user_id)
            end
        end
    end

    def is_authorized?
        !!is_valid_token
    end

    #this is called by the authozation method in users
    def authorized
        render json: {success: false, message: :unauthorized}, status: :unauthorized unless is_authorized?
    end

end
