require 'redmine'

Redmine::Plugin.register :forward_to_diffs do
  name 'Forward to Diffs'
  author 'Disqus (David Cramer)'
  url 'http://github.com/dcramer/forward-to-diffs'
  author_url 'http://www.disqus.com/'
  description 'Forward to the diffs pane when viewing a revision.'
  version '0.1'

  requires_redmine :version_or_higher => '0.8.0'
end
