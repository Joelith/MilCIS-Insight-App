class RequisitionsController < ApplicationController
  before_action :set_requisition, only: [:show, :edit, :update, :destroy, :approve, :received]

  # GET /requisitions
  # GET /requisitions.json
  def index
    @requisitions = Requisition.all.order(id: :desc)
  end

  def tasks
    @requisitions = Requisition.where status: ['Pending', 'Shipped']
  end

  def approve
    respond_to do |format|
      if @requisition.update(status: 'Approved')
        RestClient::Resource.new(APP_CONFIG[:insight_url], :verify_ssl => false, :user => APP_CONFIG[:insight_username], :password => APP_CONFIG[:insight_password]).post({
            "modelId" => "Resupply_Ky06ggwO",
            "correlationValue" => @requisition.id,
            "eventTime" => Time.now.strftime('%Y-%m-%dT%H:%M:%S'),
            "milestoneId" => "Approved"
          }.to_json, :content_type => 'application/json')
        format.html { redirect_to tasks_requisitions_url, notice: 'Requisition was successfully approved.' }
      else
        format.html { redirect_to tasks_requisitions_url, notice: 'Error when attempting to approve' }
      end
    end
  end

  def received
    respond_to do |format|
      if @requisition.update(status: 'Received')
        RestClient::Resource.new(APP_CONFIG[:insight_url], :verify_ssl => false, :user => APP_CONFIG[:insight_username], :password => APP_CONFIG[:insight_password]).post({
            "modelId" => "Resupply_Ky06ggwO",
            "correlationValue" => @requisition.id,
            "eventTime" => Time.now.strftime('%Y-%m-%dT%H:%M:%S'),
            "milestoneId" => "Received"
          }.to_json, :content_type => 'application/json')
        format.html { redirect_to tasks_requisitions_url, notice: 'Requisition was successfully marked as received.' }
      else
        format.html { redirect_to tasks_requisitions_url, notice: 'Error when attempting to receive' }
      end
    end
  end 

  # GET /requisitions/1
  # GET /requisitions/1.json
  def show
  end

  # GET /requisitions/new
  def new
    @requisition = Requisition.new
  end

  # GET /requisitions/1/edit
  def edit
  end

  # POST /requisitions
  # POST /requisitions.json
  def create
    @requisition = Requisition.new(requisition_params)
    respond_to do |format|
      if @requisition.save
        # Send to the Business Insight Model
        RestClient::Resource.new(APP_CONFIG[:insight_url], :verify_ssl => false, :user => APP_CONFIG[:insight_username], :password => APP_CONFIG[:insight_password]).post({
            "modelId" => "Resupply_Ky06ggwO",
            "measures" => [{
              "name" => "TotalCost",
              "value" => @requisition.amount
            }],
            "identifierValue" => @requisition.id,
            "correlationValue" => @requisition.id,
            "eventTime" => Time.now.strftime('%Y-%m-%dT%H:%M:%S'),
            "milestoneId" => "RequsitionRaised",
            "dimensions" => [ {
              "name" => "Location",
              "value" => @requisition.loc
            } ]
          }.to_json, :content_type=>'application/json')
        format.html { redirect_to requisitions_url, notice: 'Requisition was successfully created.' }
        format.json { render :show, status: :created, loc: @requisition }
      else
        format.html { render :new }
        format.json { render json: @requisition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /requisitions/1
  # PATCH/PUT /requisitions/1.json
  def update
    respond_to do |format|
      if @requisition.update(requisition_params)
        format.html { redirect_to @requisition, notice: 'Requisition was successfully updated.' }
        format.json { render :show, status: :ok, loc: @requisition }
      else
        format.html { render :edit }
        format.json { render json: @requisition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /requisitions/1
  # DELETE /requisitions/1.json
  def destroy
    @requisition.destroy
    respond_to do |format|
      format.html { redirect_to requisitions_url, notice: 'Requisition was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_requisition
      @requisition = Requisition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def requisition_params
      params.require(:requisition).permit(:id, :title, :description, :amount, :status, :loc)
    end
end
