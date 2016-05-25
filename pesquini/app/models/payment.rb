# #####################################################################
# Class name: Payment
# File name: payment.rb
# Description: Represents a payment done by an enterprise.
######################################################################

class Payment < ActiveRecord::Base
  include Assertions

  belongs_to :enterprise
  validates_uniqueness_of :process_number

  # Description: Returns a payment recovered by its process number.
  # Parameters: none.
  # Return: payment.
  def update_payment
  	# Reloads the Payment object.
    payment = Payment.find_by_process_number( self.process_number )
    assert_object_is_not_null( payment )
    return payment
  end

end
