class Account::BaseController < ApplicationController
  before_filter :require_login

end