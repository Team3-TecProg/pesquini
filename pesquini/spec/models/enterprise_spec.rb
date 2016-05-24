require 'spec_helper'
require 'rails_helper'

describe Enterprise do

  before do
    @enterprise = Enterprise.new
    @sanction = Sanction.new
    @payment = Payment.new
    @enterprise.cnpj = "555"
    @enterprise.corporate_name = "Samsung"
    @enterprise.save

    @sanction.initial_date = "01/02/2010".to_date
    @sanction.enterprise_id = @enterprise.id
    @sanction.save

    @payment.sign_date = "01/02/2011".to_date
    @payment.enterprise_id = @enterprise.id
    @payment.save
  end

  subject { @enterprise }
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

    describe "#payment_after_sanction" do
      it "should return false if have any sanction or any payment" do
        e = Enterprise.new
        expect(e.sanctions.count).to be(0)
        expect(e.payments.count).to be(0)
        expect(e.payment_after_sanction?).to be false
      end
      it "should return false if don't have payment after sanction" do
        expect(@enterprise.payment_after_sanction?).to be false
      end

      it "should return true if have  payment after sanction" do
        @sanction.initial_date = "01/02/2015".to_date
        @sanction.save
        expect(@enterprise.payment_after_sanction?).to be true
      end
    end

    describe "#self.enterprise_position" do
      it "should return 1 if there is only 1 enterprise" do
        e = Enterprise.new
        e.sanctions_count = 10000
        e.save

        expect(Enterprise.enterprise_position(e)).to eq(1);
      end
    end

    describe "#update" do
      before do
        @e = Enterprise.new
        @e.cnpj = "12575431567543"
        @e.save
      end

      it "should return enterprise" do
        expect(@e.update).to eq(@e);
      end

      it "should not return other enterprise" do
        expect(@e.update).not_to eq(@enterprise);
      end
    end
  end
end
