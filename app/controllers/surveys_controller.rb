class SurveysController < ApplicationController
    before_action -> { authenticate_role!(["parentee", "worker"]) }

    def index
        set_surveys
    end

    private

    def set_surveys
        @surveys ||= Survey::Survey.active.all
    end
end