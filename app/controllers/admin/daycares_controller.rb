class Admin::DaycaresController < AdminController

    def index
        @daycares ||= Daycare.all
        @daycares = @daycares.includes(:discount_code)
        @daycares = @daycares.where(id: params[:id]) unless params[:id].nil?
        @daycares = @daycares.name_like(params[:name]) unless params[:name].nil?
        @daycares = @daycares.address_like(params[:address]) unless params[:address].nil?
        @daycares = @daycares.by_country(params[:country]) unless params[:country].nil? || params[:country].blank?
    end

    def edit
        @daycare = Daycare.find(params[:id])
    end

    def update
        @daycare = Daycare.find(params[:id])
        respond_to do |format|
          if @daycare.update(daycare_params)
            @daycare.users.each do |user|
                subscription = Subscription.where(transaction_id: nil, user_id: user.id).first
                if subscription
                    subscription.month = @daycare.payment_month
                    subscription.discount_code_id = @daycare.discount_code_id
                    subscription.save
                end
            end

            format.html { redirect_to admin_clients_path(country: @daycare.country), notice: 'Daycare was successfully updated.' }
            format.json { render :show, status: :ok, location: @daycare }            
          else
            format.html { render :edit }
            format.json { render json: @daycare.errors, status: :unprocessable_entity }
          end
        end
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

      def daycare_params
        params.require(:daycare).permit(
          :name,
          :address_line1,          
          :postcode,          
          :telephone,          
          :num_children,          
          :num_worker,          
          :payment_month,          
          :discount_code_id        
        )
      end

      def set_daycares
        @daycares ||= Daycare.all
    end
end