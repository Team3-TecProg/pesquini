require 'rails_helper'

RSpec.describe User, :type => :model do
		before do
				@user = User.create(login: "teste_user", password:"password_teste")
				@aux = User.create(login: "teste_123", password:"password_teste")
		end

		it {
				expect(@user).to respond_to(:login, :type, :password_confirmation, :password)
		}
		it {
				expect(@user).to be_valid
		}

		describe 'attribute' do
				describe 'login' do
						describe 'with more than 50 chars' do
								before { @user.login = 'a'*55 }
								it 'should not pass' do
										expect(@user).not_to be_valid
								end
						end

						describe 'with less than 5 chars' do
								before { @user.login = 'b'*2 }
								it 'should not pass' do
										expect(@user).not_to be_valid
								end
						end

						describe 'with duplicate login' do
								before { @user.login = @aux.login }
								it 'should not pass' do
										expect(@user).not_to be_valid
								end
						end

					describe 'blank field' do
							before {@user.login = nil }
							it 'should not pass' do
									expect(@user).not_to be_valid
							end
					end

				end

				describe 'password' do
						describe 'blank field' do
								before{ @user.password = nil }
								it 'should not pass' do
										expect(@user).not_to be_valid
								end
						end

						describe 'with less than 8 chars' do
								before { @user.password = 'c'*5 }
								it 'should not pass' do
										expect(@user).not_to be_valid
								end
						end
				end
		end
end
