require 'rails_helper'

RSpec.configure do |config|
    config.expect_with :rspec do |c|
        c.syntax = [:should, :expect]
    end
end

RSpec.describe SessionsController, :type => :controller do
    user = User.new(login: 'sanjaninha', password: 'sanjana123')
    user.save

    subject { post :create, :session => {:login => 'sanjana', :password => 'sanjana123'}}
    describe   "GET" do
        describe '#create' do
            it "should log in user with correct login and password" do
                post :create, :session => {:login =>"sanjaninha", :password => 'sanjana123'}
                expect(response).to redirect_to(root_path)
            end
            it "shoul show a message of error when the login or password is invalid" do
                post :create, :session => {:login =>"sanjaninha", :password => 'sanjana'}
                flash[:error].should eq('Login ou senha invalidos!')
            end
        end
    end

    describe "#destroy" do
        it "should sign out the user" do
            post :create, :session => {:login =>"sanjaninha", :password => 'sanjana123'}
            get :destroy
            expect(session[:user_id]).to be(nil)
            expect(response).to redirect_to(root_path)
        end
    end
end
