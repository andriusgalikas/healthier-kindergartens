class PagesController < ApplicationController
    before_action :authenticate_user!, only: [:welcome, :infection, :instruction]

    def welcome

    end

    def instruction

    end

    def infection
        set_subjects
    end

    def getting_started

        render layout: 'login'
    end    

    private

    def set_subjects
        @subjects ||= SurveySubject.all
    end
end
