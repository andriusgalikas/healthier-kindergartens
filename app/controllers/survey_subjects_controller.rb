class SurveySubjectsController < ApplicationController
    before_action -> { authenticate_role!(["manager"]) }
    before_action :authenticate_subscribed!

    def results

    end
end