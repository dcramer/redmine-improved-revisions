class RepositoriesController < ApplicationController
  unloadable
 
  before_filter :forward_to_diff, :only => :revision

  def forward_to_diff
    redirect_to(:controller => "repositories", :action => "diff", :rev => params[:rev])
    return false
  end
end
