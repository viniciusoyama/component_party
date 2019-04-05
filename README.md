# Welcome to component_party gem

[![Travis](https://travis-ci.com/viniciusoyama/component_party.svg?branch=master)](https://travis-ci.com/viniciusoyama/component_party)
[![Code Climate](https://codeclimate.com/github/viniciusoyama/component_party/badges/gpa.svg)](https://codeclimate.com/github/viniciusoyama/component_party)
[![Test Coverage](https://codeclimate.com/github/viniciusoyama/component_party/badges/coverage.svg)](https://codeclimate.com/github/viniciusoyama/component_party)

Frontend components for Ruby on Rails: group your view logic, html and css files in components to be rendered from views or directly from controllers.

# Table of contents

<!-- TOC depthFrom:1 depthTo:1 withLinks:1 updateOnSave:0 orderedList:0 -->

- [Quick overview](#quick-overview)
- [Importing components](#importing-components)
- [View Models: pass data to your components](#view-models-pass-data-to-your-components)
- [Using helpers inside your components](#using-helpers-inside-your-components)
- [Accessing params and other controller's methods](#accessing-params-and-other-controllers-methods)
- [Rendering a component from a controller's action](#rendering-a-component-from-a-controllers-action)
- [Style namespacing: css scoped by component](#style-namespacing-css-scoped-by-component)
- [Configuration](#configuration)

<!-- /TOC -->

# Quick overview

## Installation
Add to your gemfile: `gem 'component_party'`

## Using the gem

1) Move things to app/components folder and organize your frontend


```
app
├── components
│   └── sidebar
│       └── template.erb
│       └── style.sass
│   └── header
│       └── template.erb
│       └── style.sass
│   └── pages
│       └── users
│           └── index
│               └── template.erb
│               └── style.sass
│               └── filter
│                   └── template.erb
│                   └── view_model.rb
│                   └── style.sass
│               └── list
│                   └── template.erb
│                   └── style.sass
```


2) Code your templates

**app/components/pages/users/index/template.erb**

```html
<%
  import_component 'Filter', path: './filter'
  import_component 'List', path: './list'
%>

<%= Filter() %>

<%= List(users: users) %>
```

**app/components/pages/users/list/template.erb**

```html
<table>
  <tbody>
    <% vm.users.each do |user| %>
      <tr>
        <td><%= user.name %></td>
      </tr>
    <% end %>
  </tbody>
</table>
```

3) Render a component from your controller

```ruby

class UsersController < ApplicationController

  def index
    render component: true, view_model_data: { users: User.all }
  end

end
```

4) Customize and namespace your css for a given component

**app/components/pages/users/list/style.sass**

```sass
[data-component-path=pages-users-list] table tr
  background: blue
```

5) Be astonished by what you've accomplished

![I'm so cool](rainbow_meme_v1.jpg?raw=true "Title")
![Party Hard](partyhard.gif?raw=true "Title")

# Importing components

```
app
├── components
│   └── application_layout
│       └── header
│           └── template.html.erb
│   └── user
│       └── panel
│           └── sidebar
│               └── template.html.erb
│           └── template.html.erb
```

You can import a component inside a layout, view or a component's template.

## Absolute importing

Just use the full component path.

**app/views/layouts/application.html.erb**

```html

<%
  import_component 'Header', path: 'application_layout/header'
%>

<%= Header(my_user: current_user) %>
```

## Relative importing

Use "./" before component's path.

The next example will look for a `sidebar` component inside the app/components/user/panel folder.

**app/components/user/panel/sidebar.html.erb**

```html

<%
  import_component 'Sidebar', path: './sidebar'
%>

<%= Sidebar() %>
```

# View Models: pass data to your components

While rendering a component, you can pass data in a hash format. The data will automatically be exposed to your template though a `vm` variable.  

```
app
├── components
│   └── header
│       └── template.html.erb
```

Rendering the component and passing data:

```html

<%
  import_component 'Header', path: 'header'
%>

<%= Header(my_user: current_user) %>
```

You have access to the my_user attribute in your component's template:

The component's template code:

```html
<p>Hello <%= vm.my_user.name %></p>
```

## How it works?

The `vm` variable is an instance of a ViewModel.

By default, we instantiate our `ComponentParty::ViewModel`. This class takes all the constructor arguments (it must be a hash/named args) and creates a getter for each one of them. Example:

```ruby
vm = ComponentParty::ViewModel.new(name: 'John', age: 12)
vm.name # John
vm.age # 12
```

When a view model is instantiated we pass the all arguments that you provided while calling your component in the template.

## Create your own ViewModel and handle complex view logic

Suppose that we want to use a custom view model (inside our header component's folder).

**app/components/header/view_model.rb**

```ruby
class Header::ViewModel < ComponentParty::ViewModel
  def random_greeting
    hi_text = ['Hi', 'Yo'].sample
    "#{hi_text}, #{user.name}"
  end
end
```

While importing our Header component we can pass a `custom_view_model` option to the import directive.

```html
<%
  import_component 'Header', path: 'header', custom_view_model: true
%>

<%= Header(name: 'John') %>
```

By default we will use our own view model. But if you pass the `custom_view_model` options as `true` the rendering process will look for a class following all the Rails naming conventions.

Also, you can use any class as a view model. Instead of `true` just use the class itself:

```html
<%
  import_component 'Header', path: 'header', custom_view_model: MyCustomClass
%>

<%= Header(name: 'John') %>
```

*PS:* You need to pass the class and not an instance of it.

Note that a view model *must* inherit from ComponentParty::ViewModel in order to be compliant to the internal API that a view model must have. Also, it is not expected that you override the `initialize` method in your custom view model.

**Is it possible to (by default) automatically search for a custom view model and, if not found, just use the default one instead?**

Yes, it would be possible to avoid the need of you passing a `custom_view_model` option but we don't like this approach for 2 main reasons:

1) This feature would make the rendering process much slower.

2) We think it's better to do things more explicitly for who is reading your code.

# Using helpers inside your components

The component's template is compiled using a normal rails view context so you have access to all helpers/params/routes/etc:

```
<div class="child">
  <div class="date">
    <%= l(Date.new(2019, 01, 03)) %>
  </div>

  <div class="routes">
    <%= users_path %>
  </div>

  <div class="translation">
    <%= t('hello')%>
  </div>
</div>
```

If you want to to access it inside a view model, just use the `view` method.

```ruby
class Header::ViewModel < ComponentParty::ViewModel
  def formated_date
    view.l(Date.today)
  end
end
```

**app/components/header/template.html.erb**
```html
<header>
  Today is <%= vm.formated_date %>
</header>
```


# Accessing params and other controller's methods


```ruby
class Header::ViewModel < ComponentParty::ViewModel

  def formated_page
    "Current page: #{view.params[:page]}"
  end

  def formated_search
    "Searching for: #{view.params[:search]}"
  end

  def hello
    "Hi #{view.current_user.name}"
  end

end
```

**template.erb**

```html
<%= vm.hello %>

<%= vm.formated_search %>

<%= vm.formated_page %>

<%= params[:search] %>
```

# Rendering a component from a controller's action

When you are in an action you can render a component instead of a rails view using the following syntax:

```ruby

class ClientsController < ApplicationController

  def index
    render(component: 'my/component/path', view_model_data: { new_arg: 2, more_arg: 'text'})
  end

end

```

If you want to render the default component for an given action just do:


```ruby
class ClientsController < ApplicationController

  def index
    render component: true, view_model_data: { clients: Client.all }
  end

end
```

This will search for a component with a path of `app/components/pages/clients/index`.

Note that we will add **pages** before the default controller+action path.

**Can I make the gem render a component instead of a view by default?**

We though about doing this but - even if the default behavior was to render a component instead of a view - you would have to pass the view model data in the action using some kind of trick like:

```
def index
  set_view_model_attribute(:users, User.all)
end
```

Using the controller's instance variables just like views doesn't make sense in a ViewModel implementation.

Also, as we want to make things more explicitly (in case of another dev that doesn't know about this gem enters the project), it's better to always have to write the command.

```
render component: true
```

# Style namespacing: css scoped by component

## How to write my css?
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

## How to import the css files?

You can split your css in each component folder. It doesn't matter the name or the number of css/sass/less files that you have in each folder... Just don't forget to namespace it!

Also, in your application.css file you should require all the css from the app/components folder with a relative `require_tree`. Like this:

**application.sass**

```sass
//*=require_tree ../../../components
@import "fullcalendar.min"
@import "bootstrap"
@import "datepicker"

// ...
```

# Configuration

You can customize our gem by creating an initializer on your rails app.

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
