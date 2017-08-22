class Permission < ActiveRecord::Base
    enum member_type: [:manager, :worker, :parentee, :partner]
    enum sub_type: [:partner_daycare, :partner_certificate, :manager_chain, :manager_independent, :manager_govermantal]
    enum feature: [:survey, :online_training, :message, :todo, :illness_analysics, :illness_record, :illness_guide]

    def sub_type_label
        case self.sub_type
        when 'partner_certificate'
            "Certification Partnership"
        when 'partner_daycare'
            "Healthier and Safer Childcare Partnership"
        when 'manager_chain'
            "Chain Daycare"
        when 'manager_independent'
            "Independant Daycare"
        when 'manager_govermantal'
            "Govermantal Daycare"
        end
    end

    def feature_label
        case self.feature
        when 'survey'
            "Survey"
        when 'online_training'
            "Online Training"
        when 'message'
            "Message"
        when 'todo'
            "Todo"
        when 'illness_analysics'
            "Illness Analysics"
        when 'illness_record'
            "Illness Record"
        when 'illness_guide'
            "Illness Guide"
        end
    end
end
