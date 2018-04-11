require 'rails_helper'

RSpec.describe "expenses/new", type: :view do
  before(:each) do
    assign(:expense, Expense.new(
      :total => 1.5,
      :description => "MyString",
      :user => nil,
      :group => nil,
      :category => "MyString"
    ))
  end

  it "renders new expense form" do
    render

    assert_select "form[action=?][method=?]", expenses_path, "post" do

      assert_select "input[name=?]", "expense[total]"

      assert_select "input[name=?]", "expense[description]"

      assert_select "input[name=?]", "expense[user_id]"

      assert_select "input[name=?]", "expense[group_id]"

      assert_select "input[name=?]", "expense[category]"
    end
  end
end
