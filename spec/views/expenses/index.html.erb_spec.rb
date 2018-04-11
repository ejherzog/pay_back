require 'rails_helper'

RSpec.describe "expenses/index", type: :view do
  before(:each) do
    assign(:expenses, [
      Expense.create!(
        :total => 2.5,
        :description => "Description",
        :user => nil,
        :group => nil,
        :category => "Category"
      ),
      Expense.create!(
        :total => 2.5,
        :description => "Description",
        :user => nil,
        :group => nil,
        :category => "Category"
      )
    ])
  end

  it "renders a list of expenses" do
    render
    assert_select "tr>td", :text => 2.5.to_s, :count => 2
    assert_select "tr>td", :text => "Description".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Category".to_s, :count => 2
  end
end
