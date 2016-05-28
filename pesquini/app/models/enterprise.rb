######################################################################
# Class name: Enterprise.
# File name: enterprise.rb.
# Description: Represents a Brazilian enterprise, with sanctions and
# payments.
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

    # Description: Finds and returns the last sanction, by date, of an
    # Enterprise object.
    # Parameters: none.
    # Return: last_sanction.
    def last_sanction
        last_sanction = self.sanctions.last
        # Runs through all the sanctions, selecting that which has the most
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

    # Description: Finds and returns the last Payment object.
    # Parameters: none.
    # Return: most_recent_payment.
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
            return payment.sign_date < sanction.initial_date
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

    # Description: Creates groups of enterprises based on their number of
    # sanctions.
    # Parameters: none.
    # Return: grouped_sanctions.
    def self.group_sanctions
        ordered_sanctions = self.featured_sanctions
        assert_object_is_not_null( ordered_sanctions )
        grouped_sanctions = ordered_sanctions.uniq.
        group_by( &:sanctions_count ).to_a
        assert_object_is_not_null( grouped_sanctions )

        return grouped_sanctions
    end

    # Description: Returns the index of an specific enterprise.
    # Parameters: enterprise.
    # Return: enterprise_index.
    def self.enterprise_position( enterprise )
        first_position = 0
        enterprise_identifier = 1

        grouped_sanctions = self.group_sanctions
        assert_object_is_not_null( grouped_sanctions )

        # Finds the enterprise position based on its sanctions.
        grouped_sanctions.each_with_index do | sanction, enterprise_index |
            enterprise_identifier = enterprise_identifier
            if ( sanction[first_position] == enterprise.sanctions_count )
                enterprise_position = enterprise_index + enterprise_identifier
                assert_object_is_not_null( enterprise_position )
                return enterprise_position
            else
                # Nothing to do.
            end
        end
    end

    # Description: Returns all the enterprises sorted by its sanctions count.
    # Parameters: none.
    # return: sorted_enterprises.
    def self.get_sorted_enterprises_by_sanctions_count
        sorted_enterprises = Enterprise.all.sort_by{ | enterprise | enterprise.
        sanctions_count }

        return sorted_enterprises
    end

    # Description: Sorts all enterprise by its sanctions_count attribute,
    # eliminating possible repetitions in the process.
    # Parameters: none.
    # Return: filtered_enterprises.
    def self.sort_and_filter_enterprises
        sorted_enterprises = get_sorted_enterprises_by_sanctions_count
        assert_object_is_not_null( sorted_enterprises )

        # Get all the enterprises in descendet order,
        # grouped by its sanctions_count
        filtered_enteprises = sorted_enterprises.uniq.
        group_by( &:sanctions_count ).to_a.reverse
        assert_object_is_not_null( filtered_enteprises )

        return filtered_enteprises
    end

    # Description: Returns a variable with the enterprises sorted and grouped.
    # Parameters: none.
    # return: enterprise_group_array
    def self.most_sanctioned_ranking
        first_position = 0
        second_position = 1

        enterprise_group = []
        enterprise_group_count = []

        filtered_enteprises = self.sort_and_filter_enterprises
        assert_object_is_not_null( filtered_enteprises )
        filtered_enteprises.each do | enterprise |
            enterprise_group << enterprise[first_position]
            enterprise_group_count << enterprise[second_position].count
        end

        enterprise_group_array = []
        enterprise_group_array << enterprise_group
        enterprise_group_array << enterprise_group_count
        assert_object_is_not_null( enterprise_group_array )

        return enterprise_group_array
    end

end
