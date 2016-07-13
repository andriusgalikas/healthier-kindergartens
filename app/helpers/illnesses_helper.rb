module IllnessesHelper

  def user_departments
    current_user.daycare.departments.inject([]){|list, dept| list << {id: dept.id, name: dept.name }; list }
  end

  def illness_list
    ILLNESSES.values.inject([]){|list, illness| list << {code: illness[:code], name: illness[:name]}; list }
  end

end
