######################################################################
# Class name: Enterprise.
# File name: enterprise.rb.
# Description: Represents a Brazilian enterprise, with sanctions and payments.
######################################################################

class Enterprise < ActiveRecord::Base
    include Assertions
    extend Assertions

    has_many :sanctions
    has_many :payments
    # CNPJ is an identifier that all Brazilian enterprises must have.
    validates_uniqueness_of :cnpj

    scope :featured_sanctions, 
    -> ( number = nil ) {number ? order( 'sanctions_count DESC' ).
        limit( number ) :order( 'sanctions_count DESC' ) }
    scope :featured_payments, 
    -> ( number = nil ) { number ? order( 'payments_sum DESC' ).
        limit( number ) :order( 'payments_sum DESC' ) }

    #Description: Finds and returns the last sanction, by date, of an Enterprise 
    # object.
    #Parameters: none.
    #Return: last_sanction.
    def last_sanction
        last_sanction = self.sanctions.last
        # Runs through all the sanctions, selecting that which has the most.
        # recent date.
        if ( !last_sanction.nil? )
            self.sanctions.each do | sanction |
                if ( sanction.initial_date > last_sanction.initial_date )
                    last_sanction = sanction
                else
                    # Nothing to do.
                end
            end
        else
            # Nothing to do.
        end

        return last_sanction
    end

    #Description: Finds and returns the last Payment object.
    #Parameters: none.
    #Return: most_recent_payment.
    def last_payment
        most_recent_payment = self.payments.last
        if ( !most_recent_payment.nil? )
            self.payments.each do | payment |
                if ( payment.sign_date > most_recent_payment.sign_date )
                    most_recent_payment = payment
                else
                    # Nothing to do.
                end
            end
        else
            # Nothing to do.
        end

        return most_recent_payment
    end

    # Description: Verifies that the initial date of sanction is greater than 
    # sign date of payment.
    # Parameters: none.
    # Return: boolean.
    def payment_after_sanction?
        sanction = last_sanction
        assert_object_is_not_null( sanction )
        payment = last_payment
        assert_object_is_not_null( payment )

        if ( sanction && payment )
            payment.sign_date < sanction.initial_date
        else
            return false
        end
    end

    # Description: Returns an enterprise recovered by its CNPJ.
    # Parameters: none.
    # return: enterprise.
    def update_enterprise
        enterprise = Enterprise.find_by_cnpj( self.cnpj )
        assert_object_is_not_null ( enterprise )
        return enterprise
    end

    # Description: Returns the index of an specific enterprise.
    # Parameters: enterprise.
    # Return: enterprise_index.
    def self.enterprise_position( enterprise )
        ordered_sanctions = self.featured_sanctions
        assert_object_is_not_null( ordered_sanctions )
        grouped_sanctions = ordered_sanctions.uniq.
        group_by( &:sanctions_count ).to_a
        assert_object_is_not_null( grouped_sanctions ) 
        # Finds the enterprise position based on its sanctions.
        grouped_sanctions.each_with_index do | sanction, enterprise_index |
            enterprise_identifier = 1
            if ( sanction[0] == enterprise.sanctions_count )
                enterprise_position = enterprise_index + enterprise_identifier
                assert_object_is_not_null( enterprise_position )
                return enterprise_position
            else
                # Nothing to do.
            end
        end
    end

    # Description: Returns a variable with the enterprises sorted and grouped.
    # Parameters: none.
    # return: enterprise_group_array
    def self.most_sanctioned_ranking
        #Sorts all enterprise by its sanctions_count attributes.
        sorted_enterprises = Enterprise.all.sort_by{ | enterprise | enterprise.
        sanctions_count }
        assert_object_is_not_null( sorted_enterprises )
        #Filters possible repetition of enterprise.
        filtered_enteprises = sorted_enterprises.uniq.
        group_by( &:sanctions_count ).to_a.reverse
        assert_object_is_not_null( filtered_enteprises )
        enterprise_group = []
        enterprise_group_count = []
        filtered_enteprises.each do | enterprise |
            enterprise_group << enterprise[0]
            enterprise_group_count << enterprise[1].count
        end

        enterprise_group_array = []
        enterprise_group_array << enterprise_group
        enterprise_group_array << enterprise_group_count
        assert_object_is_not_null( enterprise_group_array )

        return enterprise_group_array
    end

end
