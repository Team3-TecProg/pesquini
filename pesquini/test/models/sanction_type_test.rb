######################################################################
# Class name: StateTest
# File name: state_test.rb
# Description: Class that contains all unit tests for state model
######################################################################

require 'test_helper'

class StateTest < ActiveSupport::TestCase

    test "get all the sanctions types" do
        expected_sanction_types = [
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
        returned_sanction_types = SanctionType.all_sanction_types

        assert_equal expected_sanction_types, returned_sanction_types
    end

end
