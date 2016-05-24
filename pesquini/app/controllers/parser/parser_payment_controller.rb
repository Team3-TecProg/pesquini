class Parser::ParserPaymentController < Parser::ParserController

  require 'csv'
  require 'open-uri'
  @@filename = 'parser_data/CEIS.csv'

  before_filter :authorize, only: [:check_nil_ascii, :check_date, :import,
                                       :build_state, :build_sanction_type,
                                       :build_enterprise, :build_sanction,
                                       :check_and_save]

  def index

  end

  def check_value(text)
    #this method recieves a string representing a payment value in the format 19,470.99
    #Then it takes off the comma (",") and parse it to float format as 19470.99
     begin
      return text.gsub(",","").to_f
    rescue
      return nil
    end
  end

  def import()
    constante = 0
    Enterprise.find_each do |e|

      url = 'http://compras.dados.gov.br/contratos/v1/contratos.csv?cnpj_contratada='
      begin
        data =  open(url+e.cnpj).read
        csv = CSV.parse(data, :headers => true, :encoding => 'ISO-8859-1')

        csv.each_with_index do |row, i|
          p = Payment.new
          p.identifier = check_nil_ascii(row[0])
          p.process_number = check_nil_ascii(row[10])
          p.initial_value = check_value(row[16])
          p.sign_date = check_date(row[12])
          p.start_date = check_date(row[14])
          p.end_date = check_date(row[15])
          p.enterprise = e
          e.payments_sum = e.payments_sum + p.initial_value
          check_and_save(e)
          check_and_save(p)
        end
      rescue
        constante = constante +   1
      end
    end
    puts "="*50
    puts "Quantidade de empresas sem pagamentos: ", constante
  end

  def check_and_save(c)
    begin
      c.save!
      c
    rescue ActiveRecord::RecordInvalid
      c = c.update_payment
      c
    end
  end
end
