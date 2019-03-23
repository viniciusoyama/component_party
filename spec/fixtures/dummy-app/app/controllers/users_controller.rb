class UsersController < ApplicationController
  def index
    @users = [
      OpenStruct.new(name: 'Viny'),
      OpenStruct.new(name: 'Pedro'),
      OpenStruct.new(name: 'Jose')
    ]
  end
end
