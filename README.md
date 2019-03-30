# Welcome to component_party gem

[![Travis](https://travis-ci.com/viniciusoyama/component_party.svg?branch=master)](https://travis-ci.com/viniciusoyama/component_party)
[![Code Climate](https://codeclimate.com/github/viniciusoyama/component_party/badges/gpa.svg)](https://codeclimate.com/github/viniciusoyama/component_party)
[![Test Coverage](https://codeclimate.com/github/viniciusoyama/component_party/badges/coverage.svg)](https://codeclimate.com/github/viniciusoyama/component_party)

Frontend components for Ruby on Rails: group your view logic, html and css files in components to be used in views or directly rendered from controllers.

# How to use?

Add to your:

**Gemfile**
```ruby
gem 'component_party'
```

# What do you get?

## Organize your frontend code
Your can stop using rails views and organize your frontend by components with isolated logic and css:

```
app
├── components
│   └── user
│       └── filter
│           └── template.html.erb
│           └── view_model.rb
│           └── style.sass
│       └── list
│           └── template.html.erb
│           └── style.sass
```


You can render any component inside a template file (be it a view or another component)!

**app/view/users/index.html.erb**

```html
<%
  import_component 'Filter', path: 'user/filter'
  import_component 'List', path: 'user/list'
%>

<%= Filter() %>

<%= List(users: @users) %>
```

If you want to stop using views, just tell the controller to render your component: Compoment

```
app
├── components
│   └── /pages
│      └── users
│          └── filter
│             └── template.erb
│          └── list
│             └── template.slim
│             └── view_model.rb
│          └── index
│             └── style.sass
│             └── template.erb
```


Yes! You can use your processor to render a component template or css file.

**app/components/pages/users/index/template.html.erb**

```html
<%
  import_component 'Filter', path: './filter'
  import_component 'List', path: './list'
%>

<%= Filter() %>

<%= List(users: users) %>
```

**app/components/pages/users/list/template.html.erb**

```html
<table>
  <tbody>
    <% users.each do |user| %>
      <tr>
        <td><%= user.name %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

**app/controllers/users_controller.rb**

```ruby

class UsersController < ApplicationController

  def index
    render component: true, view_model_data: { users: User.all }
  end

end
```

## Pass data to your components in your templates

When you render a component you can pass data in a hash format. The data will be exposed in your template through a view model.  

Suppose that you have a header component like this:

```
app
├── components
│   └── header
│       └── template.html.erb
```

And you want to render this component in your layout file.

**app/views/layouts/application.html.erb**

```html

<%
  import_component 'Header', path: 'header'
%>

<%= Header(my_user: current_user) %>
```

You can access the my_user attribute in your template like this:

**app/components/header/template.html.erb**

```html
<p>Hello <%= my_user.name %></p>
```

## Relative importing also works!


```
app
├── components
│   └── user
│       └── panel
│           └── sidebar
│               └── template.html.erb
│           └── template.html.erb
```


**app/components/user/panel/sidebar.html.erb**

```html

<%
  import_component 'Sidebar', path: './sidebar'
%>

<%= Sidebar() %>
```

Note the "./" before the sidebar component path. This will look for a `sidebar` component inside the app/components/user/panel folder.

## View Models

The methods available inside a template will be those defined in your view model.

When a view model is instantiated we pass the arguments that you provide while calling your component.

### ComponentParty::Component::ViewModel

It takes all the constructor arguments (it must be a hash/named args) and creates a getter for each one of them. Example:

```ruby
vm = ComponentParty::Component::ViewModel.new(name: 'John', age: 12)
vm.name # John
vm.age # 12
```

### Create your own ViewModel: handle complex view logic

We only use our own view model if there is no view_model.rb file inside your component's folder. This file should declare a class following all the Rails naming conventions.

So, imagine that we want our custom view model to have a random_greeting method. We can can create a view model like this:

**app/components/header/view_model.rb**

```ruby
class Header::ViewModel < ComponentParty::Component::ViewModel
  def random_greeting
    hi_text = ['Hi', 'Yo'].sample
    "#{hi_text}, #{user.name}"
  end
end
```

Now the template can access the method like this:

**app/components/header/template.html.erb**
```html
<header>
  <%= random_greeting %>
</header>
```

Note that you *must* inherit from ComponentParty::Component::ViewModel in order to be compliant to the internal expected API that a view model must have. Also, as everything you pass to a view model is available as a getter method, it is not expected that you override the `initialize` method in your custom view model.

## Using helpers inside your components

When initializing the view model we also provide two parameters (:h and :helper) so you can have access to rails helpers.

As all view model methods are available to your template your will have access to a `h` or `helper` like this:

### Using helpers inside a template

```
<div class="child">
  <div class="date">
    <%= helper.l(Date.new(2019, 01, 03)) %>
  </div>

  <div class="routes">
    <%= h.users_path %>
  </div>

  <div class="translation">
    <%= h.t('hello')%>
  </div>
</div>
```

### Using helpers inside a ViewModel

A `helper` and a `h` attribute are passed when instantiating a ViewModel. That means that you can call a `h` or a `helper` method anywhere in your class.

```ruby
class Header::ViewModel < ComponentParty::Component::ViewModel
  def random_greeting
    hi_text = ['Hi', 'Yo'].sample
    "#{hi_text}, #{user.name}."
  end

  def formated_date
    h.l(Date.today)
  end
end
```

**app/components/header/template.html.erb**
```html
<header>
  <%= random_greeting %> Today is <%= formated_date %>
</header>
```


## Access your controller in your VM or Template

When rendering a component, a `c` or `controller` parameter is passed through so you can have access to all your request data inside your VM or template.

**view_model**

```ruby
class ControllerData::ViewModel < ComponentParty::Component::ViewModel

  def formated_page
    "Current page: #{c.params[:page]}"
  end

  def formated_search
    "Searching for: #{controller.params[:search]}"
  end

  def hello
    "Hi #{controller.current_user.name}"
  end

end
```

**template.erb**

```html
<%= hello %>

<%= formated_search %>

<%= formated_page %>
```

# Rendering from a controller

When you are in an action you can render a component instead of a rails view using the following syntax:

```ruby
render(component: 'my/component/path', view_model_data: { new_arg: 2, more_arg: 'text'})
```

If you want to render the default component for an given action (just like rails automatically renders you views) you can write:


```ruby
class ClientsController < ApplicationController

  def index
    render component: true, view_model_data: { clients: Client.all }
  end

end
```

This will search for a component with a path of `app/components/pages/clients/index`. Note that we will add a 'pages' before the controller+action path.


*why not set this behavior to be the default?*

Even if the default behavior was to render a component instead of a view the developer would have to pass the view model data in the action using some kind of method like:

```
def index
  set_view_model_attribute(:users, User.all)
end
```

Also, as we want to make things more explicitly (in case that another dev that doesn't know about this gem enters the project) so it's better to always have to write the command.

```
render component: true
```


# Style namespacing

Each rendered component will be wrapped inside a div with a dynamic data attribute storing the component path. This means that you can create custom css for each component. Example:


```
app
├── components
│   └── shared_stuff
│       └── header
│           └── template.html.erb
│           └── style.css
```

When we render the header it will generate a HTML like this

```html

<div class='component' data-component-path='shared_stuff-header'>
  => content in header/template.html.erb
</div>

```

Then you can customize the component with the following css:

```css
[data-component-path=shared_stuff-header] {
  background: red;
}
```

## Where do I put my CSS files?

Where it belongs: in your component's folder.

It doesn't matter the name or the number of css/sass/less files that you have in that folder... Just don't forget to namespace it!

Also, in your application.css file you should require all the css from the app/components folder. You can do that with a relative `require_tree`. Like this:

**application.sass**

```sass
//*=require_tree ../../../components
@import "fullcalendar.min"
@import "bootstrap"
@import "datepicker"

// ...
```

# Configuration

You can change some parameters by creating an initializer on your rails app.

**config/initializers/component_party.rb**


```ruby

ComponentParty.configure do |config|
  # Folder path to look for components
  config.components_path = 'app/components'

  # Name for the html/erb/slim/etc template file inside the component folder
  config.template_file_name = 'template'

  # Name for the view model file inside the component folder
  config.view_model_file_name = 'view_model'

  # Folder path inside the components folder to look for pages when
  # rendering the default component for a controller#action
  config.component_folder_for_actions = 'pages'
end

```
