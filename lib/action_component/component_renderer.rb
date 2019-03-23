module ActionComponent
  class ComponentRenderer
    def initialize(view_renderer)
      @view_renderer = view_renderer
    end

    def render(opts)
      rendering_file_path = get_file_path_from_component_path(opts[:path])
      @view_renderer.render(rendering_context, file: rendering_file_path)
    end

    def rendering_context
      Class.new do
      end.new
    end

    def get_file_path_from_component_path(path)
      path
    end
  end
end
