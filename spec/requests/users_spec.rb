require 'rails_helper'

describe "Users API", type: :request do

    describe "GET /users" do

        before do
            FactoryBot.create(:user, username: 'test1234', password: 'ABCabc123!', password_confirmation: 'ABCabc123!')
            FactoryBot.create(:user, username: 'test2345', password: 'ABCabc123!', password_confirmation: 'ABCabc123!')
        end

        it 'returns all users' do

            get '/api/users'
            expect(response).to have_http_status(:success)
            expect(JSON.parse(response.body).size).to eq(2)
        end
    end
    
    describe "POST /users" do
        it 'create a new user' do
            expect {
                post '/api/users', params:  { user: { username: 'test123',  password: 'ABCabc123!', password_confirmation: 'ABCabc123!' }}
            }.to change {User.count}.from(0).to(1)

            expect(response).to have_http_status(:created)
        end
    end

    describe "User authentication and authorization" do
       
        before do
            FactoryBot.create(:user, username: 'test123', password: 'ABCabc123!', password_confirmation: 'ABCabc123!', first_name: 'fname', last_name: 'lastname', email: 'email@email.com')
            post '/api/authenticate', params: { user: { username: 'test123', password: 'ABCabc123!' }}
        end
            
        
        it 'returns a token upon successful authentication' do
            expect(JSON.parse(response.body)['token']).not_to be_empty
        end

        it 'returns firstname lastname and email' do

            token = JSON.parse(response.body)['token']
            bearer = "Bearer " + token

            post '/api/authorize', headers: {'Authorization' => bearer}

            expect(JSON.parse(response.body)['first_name']).not_to be_empty
            expect(JSON.parse(response.body)['last_name']).not_to be_empty
            expect(JSON.parse(response.body)['email']).not_to be_empty
   
       
        end
    end
end
