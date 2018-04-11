require 'rails_helper'

RSpec.describe "expenses/edit", type: :view do
  before(:each) do
    @expense = assign(:expense, Expense.create!(
      :total => 1.5,
      :description => "MyString",
      :user => nil,
      :group => nil,
      :category => "MyString"
    ))
  end

  it "renders the edit expense form" do
    render

    assert_select "form[action=?][method=?]", expense_path(@expense), "post" do

      assert_select "input[name=?]", "expense[total]"

      assert_select "input[name=?]", "expense[description]"

      assert_select "input[name=?]", "expense[user_id]"

      assert_select "input[name=?]", "expense[group_id]"

      assert_select "input[name=?]", "expense[category]"
    end
  end
end
