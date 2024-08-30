module ProjectColors::ApplicationHelperPatch
  def self.included(base) # :nodoc:
    base.class_eval do

      # Gets associative array of custom field values and asociated colors.
      def project_colors_get_color_map
        color_assignments = Setting.plugin_redmine_project_colors['color_assignments']

        # Split the color assignments by new lines and create an associotive array value: color from it:
        color_map = []
        color_assignments.each_line do |line|
          value, color = line.split(':', 2).map(&:strip)
          color_map[Integer(value)] = color
        end
        color_map
      end

      # Gets the style attribute for the project name color.
      def project_colors_get_style(project, color_map)
        color_field_id = Setting.plugin_redmine_project_colors['color_field_id']

        # Get project color:
        style = ''
        if !color_field_id.nil? && color_field_id =~ /\A\d+\z/
          project_state = Integer(CustomValue.where(customized_type: 'Project', customized_id: project.id, custom_field_id: color_field_id).first.value) rescue nil
          if !project_state.nil? && !color_map[project_state].nil?
            style = "color: #{color_map[project_state]};"
          end
        end
        style
      end

      # Overrides the page_header_title method and adds the project color to the project name.
      def page_header_title_with_color
        if @project.nil? || @project.new_record?
          h(Setting.app_title)
        else
          b = []
          ancestors = (@project.root? ? [] : @project.ancestors.visible.to_a)
          if ancestors.any?
            root = ancestors.shift
            b << link_to_project(root, {:jump => current_menu_item}, :class => 'root')
            if ancestors.size > 2
              b << "\xe2\x80\xa6"
              ancestors = ancestors[-2, 2]
            end
            b += ancestors.collect {|p| link_to_project(p, {:jump => current_menu_item}, :class => 'ancestor') }
          end

          # Add color to the project name:
          color_map = project_colors_get_color_map()
          style = project_colors_get_style(@project, color_map)
          b << content_tag(:span, h(@project), class: 'current-project', style: style)

          if b.size > 1
            separator = content_tag(:span, ' &raquo; '.html_safe, class: 'separator')
            path = safe_join(b[0..-2], separator) + separator
            b = [content_tag(:span, path.html_safe, class: 'breadcrumbs'), b[-1]]
          end
          safe_join b
        end
      end

      alias_method :page_header_title, :page_header_title_with_color
    end
  end
end

unless ApplicationHelper.include? ProjectColors::ApplicationHelperPatch
  ApplicationHelper.send(:include, ProjectColors::ApplicationHelperPatch)
end
