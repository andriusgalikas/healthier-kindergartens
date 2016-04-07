class Users::RegistrationsController < Devise::RegistrationsController
  before_filter :configure_sign_up_params, only: [:create]

  def new
    build_resource({})
    set_daycares
    new_child
    new_user_daycare
    new_daycare_department
    set_minimum_password_length
    yield resource if block_given?
    render "register/#{params[:role]}"
  rescue ActionView::MissingTemplate
    redirect_to new_user_session_url
  end

  # POST /resource
  def create
    build_resource(sign_up_params.merge(role: params[:role]))
    set_daycares
    resource.save
    yield resource if block_given?
    if resource.persisted?
      send_confirmation_email(resource)
      if resource.active_for_authentication?
        # set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource), notice: 'You have successfully signed up!'
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      new_user_daycare
      clean_up_passwords resource
      set_minimum_password_length
      render "register/#{params[:role]}"
    end
  end


  def daycare
    @daycare = Daycare.new(daycare_sign_up_params)
    assign_daycare_manager_role
    if @daycare.save
      user = @daycare.users.first
      send_confirmation_email(user)
      sign_up(:user, user)
      respond_with user, location: after_sign_up_path_for(user), notice: 'You have successfully signed up!'
    else
      clean_up_passwords resource
      set_minimum_password_length
      render "register/#{params[:role]}"
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up).push(:name, :department_id, user_daycare_attributes: [:daycare_id, :user_id], children_attributes: [:id, :name, :parent_id, :department_id, :birth_date, profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]])
  end

  def daycare_sign_up_params
    params.require(:daycare).permit(:name, :address_line1, :postcode, :country, :telephone, departments_attributes: [:_destroy, :name], user_daycares_attributes: [:daycare_id, :user_id, user_attributes: [:name, :email, :password_confirmation, :password, :role]])
  end

  def set_daycares
    @daycares ||= Daycare.all unless params[:role] == "manager"
  end

  def new_child
    if params[:role] == 'parentee'
      child = resource.children.build 
      child.build_profile_image
    end
  end
  
  def new_daycare_department
    if params[:role] == "manager"
      @daycare = Daycare.new
      @daycare.departments.build
      @user_daycare = @daycare.user_daycares.build
      @user_daycare.build_user
    end
  end

  def new_user_daycare
    resource.build_user_daycare unless params[:role] == "manager"
  end

  def assign_daycare_manager_role
    @daycare.user_daycares.first.user.role = params[:role]
  end

  def send_confirmation_email user
    RegistrationMailer.send_confirmation(user).deliver_later
  end

  # def build_resource params
  #   self.resource = User.new(params)
  #   resource.build_
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end