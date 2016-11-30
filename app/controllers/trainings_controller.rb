class TrainingsController < ApplicationController
    before_action -> { authenticate_role!(["parentee", "worker", "manager"]) }
    before_action :authenticate_subscribed!

    def index

    end

    def show
      set_video_url
    end

    private

    def set_video_url
      # checks user is free or paid then selects video urls
      @course_url = current_user.active_subscribed? ? paid_trainings(params[:id].to_i) : free_trainings(params[:id].to_i)
    end

    def free_trainings id
      # free users video urls 
      # FREE[id]
      Video.where(category: "free",video_type: id,language: I18n.locale.upcase).last.url
    end

    def paid_trainings id
       # paid users video urls 
      # PAID[id]
      Video.where(category: "paid",video_type: id,language: I18n.locale.upcase).last.url
    end
end