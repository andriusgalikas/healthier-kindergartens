class TrainingsController < ApplicationController
    before_action -> { authenticate_role!(["parentee", "worker", "manager"]) }
    before_action :subscribed_manager!, :if => :current_user_manager?

    def index

    end

    def show
        set_video_url
    end

    private

    def set_video_url
        @course_url = "/trainings/course-#{params[:id]}/story.html"
    end

    def current_user_manager?
        current_user.manager? ? true : false
    end
end