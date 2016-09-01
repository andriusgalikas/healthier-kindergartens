class Users::RegistrationsController < Devise::RegistrationsController
  layout 'dashboard'
  before_filter :configure_sign_up_params, only: [:create]

  def new
    build_resource({})
    init_resource_per_role

    set_minimum_password_length
    yield resource if block_given?
    render "register/#{params[:role]}"
  rescue ActionView::MissingTemplate
    redirect_to new_user_session_url
  end

  # POST /resource
  def create
    build_resource(sign_up_params.merge(role: params[:role]))
    set_daycares unless ['manager', 'partner'].include?(params[:role])
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
      new_user_daycare unless ['manager', 'partner'].include?(params[:role])
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

  def affiliate
    @affiliate = Affiliate.new(affiliate_sign_up_params)

    assign_affiliate_partner_role

    if @affiliate.save
      user = @affiliate.users.first
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

  def init_resource_per_role
    case params[:role]
    when 'manager'
      new_daycare_department
    when 'partner'
      new_affiliate
    when 'parentee'
      set_daycare
      set_departments
      new_child
      new_user_daycare
    when 'worker'
      set_daycares
      new_user_daycare
    when 'medical_professional'
      new_user_profile
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.for(:sign_up).push(
      :name,
      :department_id,
      user_daycare_attributes: [:daycare_id, :user_id],
      user_affiliate_attributes: [:affiliate_id, :user_id],
      children_attributes: [:_destroy, :id, :name, :parent_id, :department_id, :birth_date, profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]],
      user_profile_attributes: [:id, :phone_number, :physical_address, :web_address, :about_yourself, :education, :online_presence, certifications: [], profile_image_attributes: [:id, :attachable_type, :attachable_id, :file], doctor_specialization_attributes: :medical_specialization_id],
      profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]
    )
  end

  def daycare_sign_up_params
    params.require(:daycare).permit(
      :name,
      :address_line1,
      :postcode,
      :country,
      :telephone,
      departments_attributes: [:_destroy, :name],
      user_daycares_attributes: [:daycare_id, :user_id, user_attributes: [:name, :email, :password_confirmation, :password, :role]],
      profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]
    )
  end

  def affiliate_sign_up_params
    params.require(:affiliate).permit(
      :name,
      :address,
      :postcode,
      :country,
      :telephone,
      user_affiliates_attributes: [:affiliate_id, :user_id, user_attributes: [:name, :email, :password_confirmation, :password, :role]],
      profile_image_attributes: [:id, :attachable_type, :attachable_id, :file]
    )
  end

  def set_daycares
    @daycares ||= Daycare.all
  end

  def new_child
    child = resource.children.build
    child.build_profile_image
  end

  def new_daycare_department
    @daycare = Daycare.new
    @daycare.build_profile_image
    @daycare.departments.build
    @user_daycare = @daycare.user_daycares.build
    @user_daycare.build_user
  end

  def new_affiliate
    @affiliate = Affiliate.new
    @affiliate.build_profile_image
    @user_affiliate = @affiliate.user_affiliates.build
    @user_affiliate.build_user
  end

  def new_user_daycare
    resource.build_user_daycare
  end

  def assign_daycare_manager_role
    @daycare.user_daycares.first.user.role = params[:role]
  end

  def assign_affiliate_partner_role
    @affiliate.user_affiliates.first.user.role = params[:role]
  end

  def send_confirmation_email user
    RegistrationMailer.send_confirmation(user).deliver_later
  end

  def set_daycare
    @daycare ||= Daycare.find params[:daycare_id]
  end

  def set_departments
    @departments ||= @daycare.departments
  end

  def new_user_profile
    profile = resource.build_user_profile
    profile.build_profile_image
    profile.build_doctor_specialization
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
