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
        @course_url = "/trainings/course-#{params[:id]}/story.html"
    end
end