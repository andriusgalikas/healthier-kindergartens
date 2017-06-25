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

    def journey
        journey_model = GlobalSetting.find_by(key: "Journey Page Mode")
        if journey_model.value == "userplan_mode"
            redirect_to pre_user_plan_path
        end
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

    def ethic_1
        if params[:plan]
            session[:apply_plan] = params[:plan]
        else
            session[:apply_plan] = 0
        end
    end

    def ethic_4
        get_schedule_params
        scheduler = AcuityScheduling.new(@schedule_user.value, @schedule_password.value, @schedule_url.value)
        @app_types = scheduler.get_appointment_types

        rescue Exception
            redirect_to dashboard_path
    end

    def add_schedule
        get_schedule_params

        scheduler = AcuityScheduling.new(@schedule_user.value, @schedule_password.value, @schedule_url.value)

        request = {
            :appointmentTypeID => params[:appointment_type],
            :datetime => params[:start_date],
            :firstName => params[:firstName],
            :lastName => params[:lastName],
            :email => params[:email],
            :phone => params[:phone],
            :fields => [
                {id: @schedule_num_children.value, value: params[:num_children]},
                {id: @schedule_num_worker.value, value: params[:num_worker]},
                {id: @schedule_care_type.value, value: params[:care_type]}
            ]
        }
        apps = scheduler.put_appointment request

        unless apps["message"].nil?
            flash[:alert] = apps["message"]
        else
            flash[:notice] = t('page.ethic.step4.schedule_success')
        end
        redirect_to dashboard_path
    end

    def contact_us
        render layout: 'registration'
    end

    def send_message
        RegistrationMailer.contact_us_message(params[:email], params[:subject], params[:content]).deliver_later
        redirect_to root_path 
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

    def get_schedule_params
        @schedule_user = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_USER")
        @schedule_password = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_PASSWORD")
        @schedule_url = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_URL")

        @schedule_num_children = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_NUM_OF_CHILD_ID")
        @schedule_num_worker = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_NUM_OF_WORKER_ID")
        @schedule_care_type = GlobalSetting.find_by(key: "ACUITY_SCHEDULE_CARD_TYPE_ID")
    end
end
