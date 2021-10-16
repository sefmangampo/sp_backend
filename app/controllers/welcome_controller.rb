class WelcomeController < ApplicationController
  def index
    render json: {
      message: 'Hello world',
      github: 'https://github.com/sefmangampo/sp_backend',
      endpoints: {
        post: {
          authenticate: "api/authenticate",
          authorize: "api/authorize",
          create_user: "api/users"
        },
        get: {
          get_all_users: "api/users"
        }
      }
    }
  end
end
