######################################################################
# File name: enterprise_controller_spec.rb.
# Description: This file contains all units tests for the enterprise
# controller.
######################################################################

require 'rails_helper'

RSpec.describe EnterprisesController, :type => :controller do
    before do
        @ENTERPRISE = Enterprise.create( cnpj: "12345",
        corporate_name: "FooBarBaz" )
        @PAYMENT = Payment.create
        @ENTERPRISE.payments << @PAYMENT
        @SANCTION = Sanction.create
        @ENTERPRISE.sanctions << @SANCTION
    end

    describe "GET #index" do
        it "should work" do
            get :index
            expect( response ).to have_http_status( :success )
        end

        it "should show 10 enterprises per page" do
            get :index, :page => 1
            expect_result =  Enterprise.paginate( :page => 1, :per_page => 10 )
            expect( assigns( :ENTERPRISES ) ).to eq( expect_result )
        end

        it "should show an enterprise that matches the provided name" do
            get :index, :query => {:corporate_name_cont => "FooBarBaz"}
            expect( assigns( :ENTERPRISES ).all ).to include( @ENTERPRISE )
        end

        it "should show an enterprise that matches the provided CNPJ" do
            get :index, :query => {:corporate_name_cont => "12345"}
            expect( assigns( :ENTERPRISES ).all ).to include( @ENTERPRISE)
        end
    end

    describe 'GET #show' do
        it "should work" do
            get :show, :id => @ENTERPRISE.id
            expect( response ).to have_http_status( :success )
        end

        it "should show the correct enterprise" do
            get :show, :id => @ENTERPRISE.id
            expect( assigns( :ENTERPRISE ) ).to eq( @ENTERPRISE )
        end

        it "should show the enterprise's payments" do
            get :show, :id => @ENTERPRISE.id
            expect( assigns( :PAYMENTS ) ).to include( @PAYMENT )
        end

        it "should show the enterprise's sanctions" do
            get :show, :id => @ENTERPRISE.id
            expect( assigns ( :SANCTIONS ) ).to include( @SANCTION )
        end
    end
end
