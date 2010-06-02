class RepositoriesController < ApplicationController
  unloadable
 
  before_filter :find_repository, :except => :edit
  before_filter :find_project, :only => :edit
  before_filter :improved_revision, :only => :revision

  def improved_revision
    @changeset = @repository.find_changeset_by_name(@rev)
    (show_error_not_found; return) unless @changeset

    if params[:format] == 'diff'
      @diff = @repository.diff(@path, @rev, @rev_to)
      (show_error_not_found; return) unless @diff
      filename = "changeset_r#{@rev}"
      filename << "_r#{@rev_to}" if @rev_to
      send_data @diff.join, :filename => "#{filename}.diff",
                            :type => 'text/x-patch',
                            :disposition => 'attachment'
    else
      @diff_type = params[:type] || User.current.pref[:diff_type] || 'inline'
      @diff_type = 'inline' unless %w(inline sbs).include?(@diff_type)
      
      # Save diff type as user preference
      if User.current.logged? && @diff_type != User.current.pref[:diff_type]
        User.current.pref[:diff_type] = @diff_type
        User.current.preference.save
      end
      
      @cache_key = "repositories/diff/#{@repository.id}/" + Digest::MD5.hexdigest("#{@path}-#{@rev}-#{@rev_to}-#{@diff_type}")    
      unless read_fragment(@cache_key)
        @diff = @repository.diff(@path, @rev, @rev_to)
        show_error_not_found unless @diff
      end
    end
    render :template => "repositories/revision.html"
    return
  end
end
