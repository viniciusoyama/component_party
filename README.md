# Welcome to action_component gem

[![Travis](https://travis-ci.org/viniciusoyama/action_component.svg?branch=master)](https://travis-ci.org/viniciusoyama/action_component)
[![Code Climate](https://codeclimate.com/github/viniciusoyama/action_component/badges/gpa.svg)](https://codeclimate.com/github/viniciusoyama/action_component)
[![Test Coverage](https://codeclimate.com/github/viniciusoyama/action_component/badges/coverage.svg)](https://codeclimate.com/github/viniciusoyama/action_component)

Frontend components for Ruby on Rails: group your view logic, html, css and javascript files in components to be used in views or directly rendered from controllers.

# Organize your frontend code
Your can group your frontend stuff by domain and organize the UI of your Rails app like this:

```
app
├── components
│   └── user
│       └── filter
│           └── template.html.erb
│       └── list
│           └── template.html.erb
```


And, in your views, or in your components, your can render it!

**app/view/users/index.html.erb**

```erb
<%
  import_action_component 'Filter', path: 'user/filter'
  import_action_component 'List', path: 'user/list'
%>

<%= Filter() %>

<%= List(users: @users) %>
```

Or, you can completely drop your view and tell your controller to render a User Index Compoment

```
app
├── components
│   └── user
│       └── filter
│           └── template.html.erb
│       └── list
│           └── template.html.erb
│       └── index
│           └── template.html.erb
```


**app/components/user/index/template.html.erb**

```erb
<%
  import_action_component 'Filter', path: 'user/filter'
  import_action_component 'List', path: 'user/list'
%>

<%= Filter() %>

<%= List(users: @users) %>
```

**app/controllers/users_controller.rb**

```ruby

# ...
def index
  # ...
  render component: 'user/index', component_locals: { users: @users }
end
# ...

```


# Configuration

You can change some parameters by creating a initializer on your app

**config/initializers/action_component.rb**

```ruby

ActionComponent.configure do |config|
  # Folder path to look for components
  config.components_path = 'app/components'

  # Default name for the html/erb/slim/etc template file inside the component folder
  config.template_file_name = 'template'
end

```
