module IllnessesHelper

  def user_departments
    current_user.daycare.departments.inject([]){|list, dept| list << {id: dept.id, name: dept.name }; list }
  end

  def illness_list
    ILLNESSES.values.collect{|illness| [illness[:name], illness[:code]]}.sort
  end

end
