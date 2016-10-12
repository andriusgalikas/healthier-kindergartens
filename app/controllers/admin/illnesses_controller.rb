class Admin::IllnessesController < AdminController

  before_filter :set_illness, only: [:edit, :update, :destroy]

  def index
    @illnesses = Illness.all.order(:name)
  end

  def new
    @illness = Illness.new
    @illness.symptoms.build
  end

  def create
    @illness = Illness.new(illness_params)

    respond_to do |format|
      if @illness.save
        format.html { redirect_to admin_illnesses_path, notice: 'Illness was successfully created.' }
        format.json { render :show, status: :created, location: @illness }
      else
        format.html { render :new }
        format.json { render json: @illness.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @illness.update(illness_params)
        format.html { redirect_to admin_illnesses_path, notice: 'Illness was successfully updated.' }
        format.json { render :show, status: :ok, location: @illness }
      else
        format.html { render :edit }
        format.json { render json: @illness.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @illness.destroy

    respond_to do |format|
      format.html { redirect_to admin_illnesses_path, notice: 'Illness was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_illness
    @illness = Illness.find(params[:id])
  end

  def illness_params
    params.require(:illness).permit(
      :name,
      :code,
      symptoms_attributes: [:_destroy, :id, :name, :code, :illness_id]
    )
  end

end
