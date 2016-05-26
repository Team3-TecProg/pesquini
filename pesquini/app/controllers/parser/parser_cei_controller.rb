######################################################################
# Class name: ParserCeiController
# File name: parser_cei_controller.rb
# Description: Contains methods to transport CSV data to the database.
######################################################################
class Parser::ParserCeiController < Parser::ParserController

    require 'csv'
    @@filename = 'parser_data/CEIS.csv'

    before_filter :authorize, only: [:check_nil_ascii, :check_date, :import,
    :build_state, :build_sanction_type, :build_enterprise, :build_sanction,
    :check_and_save]

    # Description: Transforms the "nil" ASCII statement in a string.
    # Parameters: text.
    # Return: String.
    def check_nil_ascii( text )
        if text.include?( "\u0000" )
            return "Não Informado"
        else
            return text.upcase
        end
    end

    # Description: Transforms a text in date format.
    # Parameters: text.
    # Return: date or nil.
    def check_date( text )
        begin
           return text.to_date
        rescue
          return nil
        end
    end

    # Description: Imports the data contained in the CSV file to the database.
    # Parameters: none.
    # Return: none.
    def import
        CSV.foreach(@@filename, :headers => true, :col_sep => "\t",
        :encoding => 'ISO-8859-1') do |row|
            data = row.to_hash
            if ( !data["Tipo de Pessoa"].match( "J|j".nil? ) )
                sanction_type = build_sanction_type( data )
                state = build_state( data )
                enterprise = build_enterprise( data )
                build_sanction( data, sanction_type, state, enterprise )
            else
                # Nothing to do.
            end
        end
    end

    # Description: Creates a state in the database.
    # Parameters: row_data.
    # Return: none.
    def build_state( row_data )
        state = State.new
        state.abbreviation = check_nil_ascii( row_data["UF Órgão Sancionador"] )
        check_and_save( state )
    end

    # Description: Creates a sanction_type in the database.
    # Parameters: row_data.
    # Return: none.
    def build_sanction_type( row_data )
        sanction_type = SanctionType.new
        sanction_type.description = check_nil_ascii( row_data["Tipo Sanção"] )
        check_and_save( sanction_type )
    end

    # Description: Creates an enterprise in the database.
    # Parameters: row_data.
    # Return: none.
    def build_enterprise( row_data )
        enterprise = Enterprise.new
        enterprise.cnpj = row_data["CPF ou CNPJ do Sancionado"]
        enterprise_name = "Razão Social - Cadastro Receita"
        enterprise.corporate_name = check_nil_ascii( row_data[enterprise_name] )
        check_and_save( enterprise )
    end

    # Description: Creates a sanction in the database.
    # Parameters: row_data, sanction_type, state, enterprise.
    # Return: none.
    def build_sanction(row_data, sanction_type, state, enterprise)
        sanction = Sanction.new
        sanction.initial_date = check_date( row_data["Data Início Sanção"] )
        sanction.final_date = check_date( row_data["Data Final Sanção"] )
        proccess_number = "Número do processo"
        sanction.process_number = check_nil_ascii( row_data[proccess_number] )
        sanction.enterprise_id = enterprise.id
        sanction.sanction_type_id = sanction_type.id
        sanctioning_organ = "Órgão Sancionador"
        sanction.sanction_organ = check_nil_ascii( row_data[sanctioning_organ] )
        sanction.state_id = state.id
        check_and_save( sanction )
    end

    # Description: Verifies if the object is valid, and saves it.
    # Parameters: database_object.
    # Return: database_object.
    def check_and_save( database_object )
        begin
          database_object.save!
          return database_object
        rescue ActiveRecord::RecordInvalid
          database_object = database_object.update_sanction_type
          return database_object
        end
    end
end
