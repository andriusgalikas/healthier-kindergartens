class MedicalProfessional::DiscussionsController < ApplicationController
  layout 'dashboard_v2'
  before_action -> { authenticate_role!(['medical_professional'])}

  def choose_child
    @children = Child.all
  end

end
