module ProjectColors::ProjectsHelperPatch
  def self.included(base) # :nodoc:
    base.class_eval do

      def render_project_hierarchy_with_progress_bars(projects)
        # Get the custom colors configuration from the settings:
        color_field_id = Setting.plugin_redmine_project_colors['color_field_id']
        color_assignments = Setting.plugin_redmine_project_colors['color_assignments']

        # Split the color assignments by new lines and create an associotive array value: color from it:
        color_map = []
        color_assignments.each_line do |line|
          value, color = line.split(':', 2).map(&:strip)
          color_map[Integer(value)] = color
        end

        render_project_nested_lists(projects) do |project|
          # Get project color:
          style = ''
          if !color_field_id.nil? && color_field_id =~ /\A\d+\z/
            project_state = Integer(CustomValue.where(customized_type: 'Project', customized_id: project.id, custom_field_id: color_field_id).first.value) rescue -1
            if !project_state.nil? && !color_map[project_state].nil?
              style = "color: #{color_map[project_state]};"
            end
          end

          s = link_to_project(project, {}, :class => "#{project.css_classes} #{User.current.member_of?(project) ? 'icon icon-user my-project' : nil}", :style => style)
          if project.description.present?
            s << content_tag('div', textilizable(project.short_description, :project => project), :class => 'wiki description')
          end
          job_list = CustomValue.where(customized_type: 'Project', customized_id: project.id, custom_field_id: 14).first.value rescue nil
          s
        end
      end

      alias_method :render_project_hierarchy_without_progress_bars, :render_project_hierarchy
      alias_method :render_project_hierarchy, :render_project_hierarchy_with_progress_bars
    end
  end
end

unless ProjectsHelper.include? ProjectColors::ProjectsHelperPatch
  ProjectsHelper.send(:include, ProjectColors::ProjectsHelperPatch)
end
