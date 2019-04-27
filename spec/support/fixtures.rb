def fixture_path(fixture_name)
  File.expand_path("../../fixtures/#{fixture_name}", __FILE__)
end

def app_view_file_path(view_file_name)
  ::Rails.root.join('app/views', view_file_name)
end
