class Store::BaseController < ApplicationController
  before_action :authenticate_user!
  layout 'store'
end
