class ExpensesController < ApplicationController
  before_action :set_expense, only: [:mark_paid, :show, :edit, :update, :destroy]

  # GET /expenses/new
  def new
    return unless params[:group_id]
    @group = Group.find(params[:group_id])
    redirect_to root_path unless current_is_member?(@group)
    @users = @group.users
    @categories = [
      ['Food & Drink', 'Food & Drink'],
      ['Home', 'Home'],
      ['Transportation', 'Transportation'],
      ['Utilities', 'Utilities'],
      ['Entertainment', 'Entertainment'],
      ['Other', 'Other']
    ]
    @expense = Expense.new(group_id: @group.id)
  end

  # GET /expenses/1/edit
  def edit
    return unless params[:group_id]
    @group = Group.find(params[:group_id])
    redirect_to root_path unless current_is_member?(@group)
    @users = @group.users
    @categories = [
      ['Food & Drink', 'Food & Drink'],
      ['Home', 'Home'],
      ['Transportation', 'Transportation'],
      ['Utilities', 'Utilities'],
      ['Entertainment', 'Entertainment'],
      ['Other', 'Other']
    ]
  end

  # POST /expenses
  # POST /expenses.json
  def create
    @expense = Expense.new(expense_params)

    respond_to do |format|
      if @expense.save
        @group = Group.find(@expense.group_id)
        @group.users.each do |user|
          @paid = user.id == @expense.user_id
          @payment = Payment.new(expense: @expense, user: user, paid: @paid)
          @payment.save
        end

        format.html { redirect_to @expense, notice: 'Expense was successfully created.' }
        format.json { render :show, status: :created, location: @expense }
      else
        format.html { render controller: 'expenses', action: 'new', group_id: expense_params[:group_id] }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /expenses/1
  # PATCH/PUT /expenses/1.json
  def update
    respond_to do |format|
      if @expense.update(expense_params)
        format.html { redirect_to @expense, notice: 'Expense was successfully updated.' }
        format.json { render :show, status: :ok, location: @expense }
      else
        format.html { render :edit }
        format.json { render json: @expense.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /expenses/1
  # DELETE /expenses/1.json
  def destroy
    @expense.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: 'Expense was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  # POST /expenses/1/mark_paid/1
  # POST /expenses/1/mark_paid/1.json
  def mark_paid
    @payment = Payment.where(
      user_id: params[:user_id],
      expense_id: params[:id]
    ).first
    @payment.update(paid: !@payment.paid)
    redirect_back fallback_location: @expense
  end

  # GET /expenses/1
  # GET /expenses/1.json
  def show
    @group = Group.find(@expense.group_id)
    redirect_to root_path unless current_is_member?(@group)
    @who_paid = User.find(@expense.user_id)
    @payers = @expense.users.select('users.*, payments.paid as paid')
    @per_person = @expense.total.to_f / @payers.length
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_expense
    @expense = Expense.find(params[:id])
  end

  # Never trust parameters from the scary internet,
  # only allow the white list through.
  def expense_params
    params.require(:expense).permit(
      :date,
      :total,
      :description,
      :user_id,
      :group_id,
      :category
    )
  end
end
