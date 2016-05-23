require 'rails_helper'

RSpec.describe EnterprisesController, :type => :controller do
    before do
        @enterprise = Enterprise.create(cnpj: "12345")
    end

    describe "GET" do
        describe '#index' do
            it "should work" do
                get :index
                expect(response).to have_http_status(:success)
            end
        end

        describe '#show' do
            describe 'with a registered enterprise' do
                it "should work" do
                    get :show, :id => @enterprise.id
                    expect(response).to have_http_status(:success)
                end
            end
        end
    end
end
