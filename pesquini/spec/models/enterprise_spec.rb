######################################################################
# File name: enterprise_spec.rb.
# Description: This file contains all units tests for enterprise
# model.
######################################################################

require 'spec_helper'
require 'rails_helper'

describe Enterprise do
    before do
        @ENTERPRISE = Enterprise.new
        @sanction = Sanction.new
        @more_recent_sanction = Sanction.new
        @payment = Payment.new

        @ENTERPRISE.cnpj = "555"
        @ENTERPRISE.corporate_name = "Samsung"
        @ENTERPRISE.save

        @more_recent_sanction.initial_date = "01/02/2010".to_date
        @more_recent_sanction.enterprise_id = @ENTERPRISE.id
        @more_recent_sanction.save

        @sanction.initial_date = "01/02/2008".to_date
        @sanction.enterprise_id = @ENTERPRISE.id
        @sanction.save

        @payment.sign_date = "01/02/2011".to_date
        @payment.enterprise_id = @ENTERPRISE.id
        @payment.save
    end

    describe "#last_sanction" do
        it "should return the sanction that has the earliest initial date" do
            expected_sanction_date = "01/02/2010".to_date

            returned_sanction = @ENTERPRISE.last_sanction

            expect(returned_sanction.initial_date)
            .to eq(expected_sanction_date);
        end
    end

    describe "#self.get_sorted_enterprises_by_id" do
        it "should return all enterprises sorted by its id" do
            boolean_sort = true
            previous_enterprise_sanction_count = 0
            returned_sorted_enterprises = Enterprise.get_sorted_enterprises_by_sanctions_count

            returned_sorted_enterprises.each do |enterprise|
                if enterprise.sanctions_count >= previous_enterprise_sanction_count
                    #nothing to do
                else
                    boolean_sort = false
                end

                previous_enterprise_sanction_count = enterprise.sanctions_count
            end

            expect(boolean_sort).to eq(true);
        end
    end

    subject { @ENTERPRISE }
        it { should respond_to(:cnpj) }
        it { should respond_to(:corporate_name) }
    it { should be_valid }

    describe "uniqueness validation of cnpj" do

    describe "unique cnpj" do
        it "should be_valid" do
            uniqueness_enterprise = Enterprise.new
            uniqueness_enterprise.cnpj = "1234"
            expect(uniqueness_enterprise).to be_valid
        end
    end

    describe "duplicated cnpj" do
        it "should not be_valid" do
            duplicated_enterprise = Enterprise.new
            duplicated_enterprise.cnpj = "555"
            expect(duplicated_enterprise).not_to be_valid
        end
    end

    describe "#last_payment" do
        it "should return the payment that has the earliest sign date" do
            expected_sign_date = "01/02/2011".to_date

            returned_payment = @ENTERPRISE.last_payment

            expect(returned_payment.sign_date)
            .to eq(expected_sign_date);
        end
    end


    describe "#payment_after_sanction" do
        it "should return false if have any sanction or any payment" do
            e = Enterprise.new
            expect(e.sanctions.count).to be(0)
            expect(e.payments.count).to be(0)
            expect(e.payment_after_sanction?).to be false
        end

        it "should return false if don't have payment after sanction" do
            expect(@ENTERPRISE.payment_after_sanction?).to be false
        end

        it "should return true if have  payment after sanction" do
            @sanction.initial_date = "01/02/2015".to_date
            @sanction.save
            expect(@ENTERPRISE.payment_after_sanction?).to be false
        end
    end

    describe "#self.enterprise_position" do
        it "should return 1 if there is only 1 enterprise" do
            enterprise = Enterprise.new
            enterprise.sanctions_count = 10000
            enterprise.save

            expect(Enterprise.enterprise_position(enterprise)).to eq(1);
        end
    end

    describe "#update" do
        before do
            @e = Enterprise.new
            @e.cnpj = "12575431567543"
            @e.save
        end

        it "should return enterprise" do
            expect(@e.update_enterprise).to eq(@e);
        end

        it "should not return other enterprise" do
            expect(@e.update_enterprise).not_to eq(@ENTERPRISE);
        end
    end
  end
end
