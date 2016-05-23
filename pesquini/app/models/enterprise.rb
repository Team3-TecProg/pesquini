# ######indexindexindex###############################################################
# Class name: Enterprise.
# File name: enterprise.rb.
# Description: Represents a brazilian enterprise that will be searched
# by the user.
######################################################################

class Enterprise < ActiveRecord::Base

    has_many :sanctions
    has_many :payments
    # CNPJ is an identifier that all brazilian enterprises must have.
    validates_uniqueness_of :cnpj

    scope :featured_sanctions, ->(number=nil){number ? order('sanctions_count DESC').limit(number) :order('sanctions_count DESC')}
    scope :featured_payments, -> (number=nil){number ? order('payments_sum DESC').limit(number) :order('payments_sum DESC')}

    #Description: Finds and returns the last sanction
    # , by date, of an Enterprise object.
    #Parameters: none.
    #return: last_sanction.
    def last_sanction
        last_sanction = self.sanctions.last
        # Runs through all the sanctions, selecting that which has the most.
        # recent date.
        if (not last_sanction.nil?)
            self.sanctions.each do |sanction|
                if (sanction.initial_date > last_sanction.initial_date)
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
    #Parameters: none
    #return: most_recent_payment
    def last_payment
        most_recent_payment = self.payments.last
        if (not most_recent_payment.nil?)
            self.payments.each do |payment|
                if (payment.sign_date > most_recent_payment.sign_date)
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

    # Description: Verifies that the initial date of sanction
    # is greather than sign date of payment.
    # Parameters: none
    # return: boolean
    def payment_after_sanction?
        sanction = last_sanction
        payment = last_payment

        if (sanction && payment)
            payment.sign_date < sanction.initial_date
        else
            return false
        end
    end

    # Description: Returns an enterprise recovered by its CNPJ.
    # Parameters: none
    # return: enterprise
    def refresh!
        enterprise = Enterprise.find_by_cnpj(self.cnpj)
    end

    # Description: Returns the index of an specific enterprise.
    # Parameters: none
    # return: enterprise
    def self.enterprise_position(enterprise)
        ordered_sanctions = self.featured_sanctions
        grouped_sanctions = ordered_sanctions.uniq.group_by(&:sanctions_count).to_a
    # Finds the enterprise position based on its sanctions.
        grouped_sanctions.each_with_index do |sanction,enterprise_index|
            if (sanction[0] == enterprise.sanctions_count)
                return enterprise_index + 1
            else
                # Nothing to do.
            end
        end
    end

    # Descríption: Returns a variable with the
    # enterprises sorted and grouped.
    # Parameters: none.
    # return: @enterprise_group_array
    def self.most_sanctioned_ranking
        enterprise_group = []
        enterprise_group_count = []
        @enterprise_group_array = []
        #Sorts all enterprise by its sanctions_count attributes.
        sorted_enterprises = Enterprise.all.sort_by{|x| x.sanctions_count}
        #Filters possible repetition of enterprise.
        filtered_enteprises = sorted_enterprises.uniq.group_by(&:sanctions_count).to_a.reverse

        filtered_enteprises.each do |enterprise|
            enterprise_group << enterprise[0]
            enterprise_group_count << enterprise[1].count
        end

        @enterprise_group_array << enterprise_group
        @enterprise_group_array << enterprise_group_count

        return @enterprise_group_array
    end

end
