class PagesController < ApplicationController
    before_action :authenticate_user!, only: [:welcome, :infection, :instruction]
    before_action :authenticate_subscribed!, only: :instruction

    def home
      render layout: 'home'
    end

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

    def implementation

    end

    private

    def set_subjects
        @subjects ||= SurveySubject.where(language: I18n.locale.upcase)
    end
end
