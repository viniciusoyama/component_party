# frozen_string_literal: true
require 'rails_helper'

describe 'users/index', type: :view do
  it 'renders a list of users' do
    users = [OpenStruct.new(name: 'Viny')]
    users << OpenStruct.new(name: 'Pedro')
    assign(:users, users)

    render

    expect(rendered).to include('Viny')
    expect(rendered).to include('Pedro')
    expect(rendered).to have_css('header', text: 'Header text')
  end
end
