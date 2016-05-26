######################################################################
# Class name: ParserPaymentController
# File name: parser_payment_controller.rb
# Description: Contains methods to transport CSV payment data to the database.
######################################################################

class Parser::ParserPaymentController < Parser::ParserController

    require 'csv'
    require 'open-uri'
    @@filename = 'parser_data/CEIS.csv'

    before_filter :authorize, only: [:check_nil_ascii, :check_date, :import,
    :build_state, :build_sanction_type, :build_enterprise, :build_sanction,
    :check_and_save]

    # Description: Receives a string representing a payment value in the format 
    # 19,470.99. Then it takes off the comma (",") and parse it to float format 
    # as 19470.99.
    # Parameters: text.
    # Return: value.
    def check_value( text )
        begin
            value = text.gsub(",","").to_f
            return value
        rescue
            return nil
        end
    end

    # Description: Prepares Payment object data based on enterprises.
    # Parameters: none.
    # Return: none.
    def import
        constant = 0
        Enterprise.find_each do |enterprise|
            url = 'http://compras.dados.gov.br/contratos/v1/contratos.csv?cnpj_contratada='
            begin
                data =  open(vurl+enterprise.cnpj ).read
                encoding = 'ISO-8859-1'
                csv = CSV.parse( data, :headers => true, :encoding => encoding )
                csv.each_with_index do |row, index|
                    payment = Payment.new
                    payment.identifier = check_nil_ascii( row[0] )
                    payment.process_number = check_nil_ascii( row[10] )
                    payment.initial_value = check_value( row[16] )
                    payment.sign_date = check_date( row[12] )
                    payment.start_date = check_date( row[14] )
                    payment.end_date = check_date( row[15] )
                    payment.enterprise = enterprise
                    enterprise.payments_sum = enterprise.payments_sum + 
                    payment.initial_value
                    check_and_save(enterprise)
                    check_and_save(payment)
                end
            rescue
                constant = constant +   1
            end
        end
        puts "="*50
        puts "Quantidade de empresas sem pagamentos: ", constante
    end

    # Description: Verifies if the object is valid, and saves it.
    # Parameters: database_object.
    # Return: database_object.
    def check_and_save( database_object)
        begin
            database_object.save!
            database_object
        rescue ActiveRecord::RecordInvalid
            database_object = database_object.update_payment
            database_object
        end
    end
end
