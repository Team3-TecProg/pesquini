class Parser::ParserCeiController < Parser::ParserController

  require 'csv'
  @@filename = 'parser_data/CEIS.csv'

  before_filter :authorize, only: [:check_nil_ascii, :check_date, :import, 
                                       :build_state, :build_sanction_type, 
                                       :build_enterprise, :build_sanction, 
                                       :check_and_save]

  def index

  end

  def check_nil_ascii(text)
    if text.include?("\u0000")
      return "Não Informado"
    else
      return text.upcase
    end
  end

  def check_date(text)
    begin
      return text.to_date
    rescue
      return nil
    end
  end

  def import
    xd = 0
    CSV.foreach(@@filename, :headers => true, :col_sep => "\t",
                :encoding => 'ISO-8859-1') do |row|
      data = row.to_hash
      unless data["Tipo de Pessoa"].match("J|j").nil?
        sanction_type = build_sanction_type(data)
        state = build_state(data)
        enterprise = build_enterprise(data)
        build_sanction(data, sanction_type, state, enterprise)
      end
    end
  end

  def build_state(row_data)
    s = State.new
    s.abbreviation = check_nil_ascii(row_data["UF Órgão Sancionador"])
    check_and_save(s)
  end

  def build_sanction_type(row_data)
    s = SanctionType.new
    s.description = check_nil_ascii(row_data["Tipo Sanção"])
    check_and_save(s)
  end

  def build_enterprise(row_data)
    e = Enterprise.new
    e.cnpj = row_data["CPF ou CNPJ do Sancionado"]
    # e.trading_name = check_nil_ascii(row_data["Nome Fantasia - Cadastro Receita"])
    e.corporate_name = check_nil_ascii(row_data["Razão Social - Cadastro Receita"])
    check_and_save(e)
  end

  def build_sanction(row_data, sanction_type, state, enterprise)
    s = Sanction.new
    s.initial_date = check_date(row_data["Data Início Sanção"])
    s.final_date = check_date(row_data["Data Final Sanção"])
    s.process_number = check_nil_ascii(row_data["Número do processo"])
    s.enterprise_id = enterprise.id
    s.sanction_type_id = sanction_type.id
    s.sanction_organ = check_nil_ascii(row_data["Órgão Sancionador"])
    s.state_id = state.id
    check_and_save(s)
  end

  def check_and_save(c)
    begin
      c.save!
      c
    rescue ActiveRecord::RecordInvalid
      c = c.update
      c
    end
  end
end
