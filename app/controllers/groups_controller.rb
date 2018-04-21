class GroupsController < ApplicationController
  before_action :set_group, only: [:add_users, :add_user, :show, :edit, :update, :destroy]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
  end

  # GET /groups/1/add_user
  # GET /groups/1/add_user.json
  def add_users
    @users = User.all
  end

  # POST /groups/1/add_user(/1)
  # POST /groups/1/add_user(/1).json
  def add_user
    @user = if params[:user_id]
              User.find(params[:user_id])
            else
              current_user
            end
    @name = params[:user_id] ? @user.full_name + ' has' : 'You have'
    @group.add_user(@user)
    respond_to do |format|
      format.html { redirect_to @group, notice: "#{@name} successfully been added this group." }
      format.json { head :no_content }
    end
  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @members = @group.users
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
    @members = @group.users
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to @group, notice: "#{@group.name} was successfully created." }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to @group, notice: "#{@group.name} was successfully updated." }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: "#{@group.name} was successfully deleted." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name)
    end
end
