######################################################################
# File name: sessions_controller_spec.rb.
# Description: This file contains all units tests for the sessions
# controller.
######################################################################

require 'rails_helper'

RSpec.describe SessionsController, :type => :controller do

    before( :all ) do
       @user = User.new( login: 'foobar', password: '12345678',
        password_confirmation: '12345678' )
       @user.save
    end

    describe 'POST #create' do
        it "should log in user with correct login and password" do
            post :create,:session => { :login =>'foobar',:password => '12345678' }
            expect( response ).to redirect_to( root_path )
        end

        it "should show an error message with invalid login or password" do
            post :create, :session => { :login =>'foobarz', :password => '12345' }
            expect( flash[ :error ] ).to eq( 'Login ou senha invalidos!' )
            expect( response ).to render_template( "new" )
        end
    end

    describe "GET #destroy" do
        it "should sign out the user" do
            post :create,:session => { :login =>'foobar',:password => '12345678' }
            get :destroy
            expect( session[ :user_id ] ).to be( nil )
            expect( response ).to redirect_to( root_path )
        end
    end
end
