class PagesController < ApplicationController
    before_action :authenticate_user!, only: [:welcome, :infection, :instruction]
    before_action :authenticate_subscribed!, only: :instruction
    before_filter :check_xhr, only: [:mission, :standard, :path]

    def welcome

    end

    def instruction

    end

    def infection
        set_subjects
    end

    def getting_started
        render layout: 'registration'
    end

    def implementation

    end

    def invite_registration
      render layout: 'login'
    end

    def home

    end

    private

    def set_subjects
        @subjects ||= SurveySubject.where(language: I18n.locale.upcase)
    end

    def check_xhr
      if request.xhr?
        render partial: action_name
      end
    end
end
