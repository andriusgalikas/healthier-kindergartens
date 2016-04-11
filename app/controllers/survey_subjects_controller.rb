class SurveySubjectsController < ApplicationController
    before_action -> { authenticate_role!(["manager"]) }
    before_action :subscribed_manager!

    def results

    end
end