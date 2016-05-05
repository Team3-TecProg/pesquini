# #####################################################################
# Class name: Payment
# File name: payment.rb
# Description: Represents a payment done by an enterprise.
######################################################################

class Payment < ActiveRecord::Base

  belongs_to :enterprise
  validates_uniqueness_of :process_number


  def refresh!
  	# Reloads the Payment object.
    Payment.find_by_process_number(self.process_number)
  end


end