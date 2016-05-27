######################################################################
# File name: payment_spec.rb.
# Description: This file contains all units tests for payment
# model.
######################################################################

require 'spec_helper'
require 'rails_helper'

describe Payment do
    before do
        @payment = Payment.new
        @payment.process_number = "1"
        @payment.save
    end

    subject { @payment }
    it { should respond_to( :process_number ) }
    it { should be_valid }

    describe "uniqueness validation of process_number" do

    describe "unique process_number" do
        it "should be_valid" do
            uniqueness_payment = Payment.new
            uniqueness_payment.process_number = "7"
            expect(uniqueness_payment).to be_valid
        end
    end

    describe "duplicated process_number" do
        it "should not be_valid" do
            duplicated_payment = Payment.new
            duplicated_payment.process_number = "1"
            expect( duplicated_payment ).not_to be_valid
        end
    end

    describe "#update" do
        before do
            @payment_update = Payment.new
            @payment_update.process_number = "437924"
            @payment_update.save
        end

        it "should return Payment" do
            expect( @payment_update.update_payment ).to eq( @payment_update );
        end

        it "should not return other Payment" do
            expect( @payment_update.update_payment ).not_to eq( @payment );
        end
    end
  end
end
