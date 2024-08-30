unless File.basename(File.dirname(__FILE__)) == 'redmine_project_colors'
  raise "Redmine Project Colors plugin directory should be 'redmine_project_colors' instead of '#{File.basename(File.dirname(__FILE__))}'"
end

Redmine::Plugin.register :redmine_project_colors do
  name 'Redmine Project Colors plugin'
  author 'Jan Vojtech'
  description 'Allows to change project name colors in the project list page.'
  version '1.0.0'
  url 'https://github.com/klasyc/redmine_project_colors'
  author_url 'https://github.com/klasyc'
  requires_redmine version_or_higher: '3.3'

  settings default: {
		'color_field_id'           => '0',
		'color_assignments'        => '',
  }, partial: 'settings/project_colors'
end

require 'redmine_project_colors'
require 'project_colors/projects_helper_patch'
