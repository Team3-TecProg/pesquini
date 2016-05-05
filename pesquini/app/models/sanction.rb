######################################################################
# Class name: Sanction
# File name: sanction.rb
# Description: Represents all the sanctions of each enterprise
######################################################################

class Sanction < ActiveRecord::Base

    belongs_to :enterprise, counter_cache: true
    belongs_to :sanction_type
    belongs_to :state
    validates_uniqueness_of :process_number
    scope :by_year, lambda { |year| where('extract(year from initial_date) = ?', year) }

    def self.all_years
        # Array to be used for statistics in StatisticsController.
        years = ["Todos",1988, 1991, 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002,
            2003, 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012, 2013,
            2014, 2015]
        return years
    end

    def refresh!
        # Reloads the Sanction object.
        actual_sanction = Sanction.find_by_process_number(self.process_number)
    end

    def self.percentual_sanction(value)
        total = Sanction.all.count
        percentual = value * 100.0 / total
        return percentual
    end

end
