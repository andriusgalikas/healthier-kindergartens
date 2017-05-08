class PagesController < ApplicationController
    before_action :authenticate_user!, only: [:welcome, :infection, :ethic_4]
    #before_action :authenticate_subscribed!, only: :instruction
    before_filter :check_xhr, only: [:mission, :standard, :path, :description]

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

    def guide_text
        respond_to do |format|
            type = params[:type].split('.')
            result = { :step => I18n.t(params[:type]), :label => I18n.t('guideline.tour_lable') }
            format.json {render :json => result}
        end
    end

    def guide_page
        if params[:page] == 'manager_survey' && (%(result_step2 result_step3).include? params[:step])
            layout_name = 'registration'
        else
            layout_name = 'dashboard_v2'
        end
        render action: "#{params[:page]}/#{params[:step]}", layout: layout_name
    end

    def ethic_4
        scheduler = AcuityScheduling.new(ENV['ACUITY_SCHEDULE_USER'], ENV['ACUITY_SCHEDULE_PASSWORD'], ENV['ACUITY_SCHEDULE_URL'])
        @app_types = scheduler.get_appointment_types        
        rescue Exception
            redirect_to dashboard_path
    end

    def add_schedule
        scheduler = AcuityScheduling.new(ENV['ACUITY_SCHEDULE_USER'], ENV['ACUITY_SCHEDULE_PASSWORD'], ENV['ACUITY_SCHEDULE_URL'])

        request = {
            :appointmentTypeID => params[:appointment_type],
            :datetime => params[:start_date],
            :firstName => params[:firstName],
            :lastName => params[:lastName],
            :email => params[:email],
            :phone => params[:phone],
            :fields => [
                {id: "2412391", value: params[:num_children]},
                {id: "2412394", value: params[:num_worker]},
                {id: "2421634", value: params[:care_type]}
            ]
        }
        apps = scheduler.put_appointment request
        redirect_to dashboard_path
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
