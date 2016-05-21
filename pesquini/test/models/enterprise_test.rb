require 'test_helper'

class EnterpriseTest < ActiveSupport::TestCase

    #TESTAAARRRR SE ESTÁ CRIANDO O OBJETO DE ACORDO COM OS VALIDATES DAS MODELS E COLOCAR TAMBÉM
    #VALIDATES NA Sanction

    def setup
        @enterprise = Enterprise.new
        @enterprise.save!
    end

    test "get the last valid sanction" do
        @sanction = Sanction.new
        @sanction.process_number = 21
        @sanction.save!

        @enterprise.sanctions << @sanction

        expected_last_sanction = @sanction
        returned_last_sanction = @enterprise.last_sanction

        assert_equal expected_last_sanction,returned_last_sanction
    end

end
