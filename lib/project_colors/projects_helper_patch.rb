module ProjectColors::ProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.class_eval do

      # Overrides the render_project_hierarchy method and adds the project color to the project name.
      def render_project_hierarchy_with_colors(projects)
        color_map = project_colors_get_color_map()
        render_project_nested_lists(projects) do |project|
          style = project_colors_get_style(project, color_map)
          s = link_to_project(project, {}, :class => "#{project.css_classes} #{User.current.member_of?(project) ? 'icon icon-user my-project' : nil}", :style => style)
          if project.description.present?
            s << content_tag('div', textilizable(project.short_description, :project => project), :class => 'wiki description')
          end
          s
        end
      end

      alias_method :render_project_hierarchy, :render_project_hierarchy_with_colors
    end
  end
end

unless ProjectsHelper.include? ProjectColors::ProjectsHelperPatch
  ProjectsHelper.send(:include, ProjectColors::ProjectsHelperPatch)
end
