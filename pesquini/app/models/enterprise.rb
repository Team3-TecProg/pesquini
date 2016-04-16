######################################################################
# Class name: Enterprise
# File name: enterprise.rb
# Description: Represents a brazilian enterprise that will be searched by the user
######################################################################

class Enterprise < ActiveRecord::Base

  has_many :sanctions
  has_many :payments
  validates_uniqueness_of :cnpj

  scope :featured_sanctions, ->(number=nil){number ? order('sanctions_count DESC').limit(number) :order('sanctions_count DESC')}
  scope :featured_payments, -> (number=nil){number ? order('payments_sum DESC').limit(number) :order('payments_sum DESC')}

  def last_sanction
      sanction = self.sanctions.last
      if not sanction.nil?
          self.sanctions.each do |s|
              sanction = s if s.initial_date > sanction.initial_date
          end
      else
          #nothing to do
      end
      return sanction
  end

  def last_payment
      payment = self.payments.last
      if not payment.nil?
          self.payments.each do |f|
              payment = f if f.sign_date > payment.sign_date
          end
      else
          #nothing to do
      end
      return payment
  end

  def payment_after_sanction?
      sanction = last_sanction
      payment = last_payment
      if sanction && payment
          payment.sign_date < sanction.initial_date
      else
          return false
      end
  end

  def refresh!
      enterprise = Enterprise.find_by_cnpj(self.cnpj)
  end

  def self.enterprise_position(enterprise)
      orderedSanc = self.featured_sanctions
      groupedSanc = orderedSanc.uniq.group_by(&:sanctions_count).to_a

      groupedSanc.each_with_index do |k,index|
          if k[0] == enterprise.sanctions_count
              return index + 1
          end
      end
  end

  def self.most_sanctioned_ranking
      enterprise_group = []
      enterprise_group_count = []
      @enterprise_group_array = []
      a = Enterprise.all.sort_by{|x| x.sanctions_count}
      b = a.uniq.group_by(&:sanctions_count).to_a.reverse

      b.each do |k|
          enterprise_group << k[0]
          enterprise_group_count << k[1].count
      end

      @enterprise_group_array << enterprise_group
      @enterprise_group_array << enterprise_group_count
      @enterprise_group_array
  end

end
