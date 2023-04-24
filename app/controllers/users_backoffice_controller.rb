class UsersBackofficeController < ApplicationController
    before_action :authenticate_user!
    
    def index
        render 'page'
    end
end
