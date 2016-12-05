class Admin::DaycaresController < AdminController

    def index
        set_daycares
    end

    def destroy
	    @daycare = Daycare.find(params[:id])
	    @daycare.destroy    	
	    respond_to do |format|
	      format.html { redirect_to admin_daycares_url, notice: 'Daycare was successfully destroyed.' }
	      format.json { head :no_content }
	    end
    end

    private

    def set_daycares
        @daycares ||= Daycare.all
    end
end