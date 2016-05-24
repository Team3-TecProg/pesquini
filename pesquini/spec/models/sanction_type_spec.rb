require 'spec_helper'
require 'rails_helper'

describe SanctionType do
    before do
        @sanction_type = SanctionType.new
        @sanction_type.description = "Proibição - Lei Eleitoral"
        @sanction_type.save
    end

    subject {@sanction_type}
    it { should respond_to(:description) }
    it { should be_valid }

    describe "uniqueness validation of description" do
        describe "unique description" do
            it "should be_valid" do
                uniqueness_sanction_type = SanctionType.new
                uniqueness_sanction_type.description = "Inidoneidade - Lei de Licitações"
                expect(uniqueness_sanction_type).to be_valid
            end
        end

        describe "duplicated description" do
            it "should not be_valid" do
                duplicated_sanction_type = SanctionType.new
                duplicated_sanction_type.description = "Proibição - Lei Eleitoral"
                expect(duplicated_sanction_type).not_to be_valid
            end
        end

        describe "#update" do
            before do
                @s = SanctionType.new
                @s.description = "Teste 1"
                @s.save
            end

            it "should return SanctionType" do
              expect(@s.update_sanction_type).to eq(@s);
            end

            it "should not return other SanctionType" do
              expect(@s.update_sanction_type).not_to eq(@sanction_type);
            end
        end

        describe "#get_all_sanction_types" do
            expected_array_of_sanction_types = [
            [ "INIDONEIDADE - LEGISLAçãO ESTADUAL",
                "Inidoneidade - Legislação Estadual"],
            [ "IMPEDIMENTO - LEI DO PREGãO", "Impedimento - Lei do Pregão"],
            [ "PROIBIçãO - LEI ELEITORAL", "Proibição - Lei Eleitoral"],
            [ "INIDONEIDADE - LEI DE LICITAçõES",
                "Inidoneidade - Lei de Licitações"],
            [ "SUSPENSãO - LEI DE LICITAçõES",
                "Suspensão - Lei de Impedimento Licitações"],
            [ "SUSPENSãO - LEGISLAçãO ESTADUAL", "Suspensão - Legislação estadual"],
            [ "PROIBIçãO - LEI DE IMPROBIDADE", "Proibição - Lei de improbidade"],
            [ "DECISãO JUDICIAL LIMINAR/CAUTELAR QUE IMPEçA CONTRATAçãO",
                "Decisão Judicial liminar"] ,
            [ "INIDONEIDADE - LEI DA ANTT E ANTAQ ",
                "Inidoneidade - Lei da ANTT e ANTAQ"] ,
            [ "INIDONEIDADE - LEI ORGâNICA TCU", "Inidoneidade - Lei Orgânica TCU"],
            [ "IMPEDIMENTO - LEGISLAçãO ESTADUAL",
                "Impedimento - Legislação Estadual"],
            [ "SUSPENSãO E IMPEDIMENTO - LEI DE ACESSO à INFORMAçãO",
                "Suspensão e Impedimento - Lei de Acesso à Informação"],
            [ "PROIBIçãO - LEI ANTITRUSTE", "Proibição - Lei Antitruste"],
            [ "IMPEDIMENTO - LEI DO RDC", "Impedimento - Lei do RDC"],
            [ "PROIBIçãO - LEI AMBIENTAL", "Proibição - Lei Ambiental" ],
            ]

            it "should return an array with all years" do
                expect(SanctionType.get_all_sanction_types).to eq(expected_array_of_sanction_types)
            end
        end
    end
end
