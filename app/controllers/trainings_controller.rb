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
      @course_url = current_user.daycare.active_subscription? ? paid_trainings(params[:id]) : free_trainings(params[:id])
    end

    def free_trainings(index)
      {'1': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Preview%20all%20courses/Food%20Handeling%20Norwegian%20Preview.mp4",
        '2': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Preview%20all%20courses/Exclude%20module%20Norwegian%20Preview.mp4",
              '3': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Preview%20all%20courses/Diapering%20module%20preview%20norwegain.mp4",
              '4': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Preview%20all%20courses/Outbreak%20Control%20preview%20Norwegian.mp4",
              '5': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Preview%20all%20courses/Cleaning%20bodily%20fluid%20preview%20Norwegian.mp4",
              '6': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Preview%20all%20courses/Handwash%20module%20preview%20Norwegian.mp4"
          }.first
      return "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Food%20Handling%20Norwegain/story.html"       
    end

    def paid_trainings(index)
        {'1': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Food%20Handling%20Norwegain/story.html",
              '2': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Smitte%20preventiv%20ekskludering%20av%20syke%20barn/story.html",
              '3': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Instruksjonskurset%20om%20smitte%20preventivt%20bleieskift/story.html",
              '4': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Smitte%20preventive%20strategier%20for%20kontroll%20av%20sykdoms%20utbrudd/story.html",
              '5': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Smitte%20preventiv%20rengj%C3%B8ring%20etter%20kroppsv%C3%A6sker/story.html",
              '6': "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Instruksjonskurset%20om%20smitte%20preventiv%20h%C3%A5ndvask/story.html"
          }.first
        return "https://dl.dropboxusercontent.com/u/550951711/Public%20%281%29/Healthier%20Childcare/Norway/Online%20training/Infection%20Control/Food%20Handling%20Norwegain/story.html"  
    end

end