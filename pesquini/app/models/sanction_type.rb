######################################################################
# Class name: SanctionType
# File name: sanction_type.rb
# Description: Represents all the classifications for sanctions.
######################################################################

class SanctionType < ActiveRecord::Base

    has_many :sanctions
    validates_uniqueness_of :description

    # Description: Reloads the Sanction object.
    # Parameters: none.
    # Return: actual_sanction.
    def refresh!
        actual_sanction = SanctionType.find_by_description(self.description)
    end

    # Description: Recover all sanction types.
    # Parameters: none.
    # Return: sanction_types.
    def self.all_sanction_types
        # The array containing all the possible sanction types is used for
        # statistics in StatisticsController.
        stantion_types = [
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

        return stantion_types
    end

end
