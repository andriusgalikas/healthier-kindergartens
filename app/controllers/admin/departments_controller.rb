class Admin::DepartmentsController < AdminController

    def index
        set_departments
    end

    private

    def set_departments
        @departments ||= Department.all
    end
end