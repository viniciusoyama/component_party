# Welcome to action_component gem

[![Travis](https://travis-ci.org/viniciusoyama/action_component.svg?branch=master)](https://travis-ci.org/viniciusoyama/action_component)
[![Code Climate](https://codeclimate.com/github/viniciusoyama/action_component/badges/gpa.svg)](https://codeclimate.com/github/viniciusoyama/action_component)
[![Test Coverage](https://codeclimate.com/github/viniciusoyama/action_component/badges/coverage.svg)](https://codeclimate.com/github/viniciusoyama/action_component)

Frontend components for Ruby on Rails: group your view logic, html, css and javascript files in components to be used in views or directly rendered from controllers.

# What do you get?

## Organize your frontend code
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

```html
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

```html
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
# TODO
# ...

```

## Pass data to your components

When rendering your can pass data in a hash/named parameters format. The data will be exposed in your template through a view model.  

Supose that you have a header component

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
  import_action_component 'Header', path: 'header'
%>

<%= Header(user: current_user) %>
```

You can access the user attribute in your template like this:

**app/components/header/template.html.erb**

```html
<header>
  Hi, <%= vm.user.name %>
</header>
```

## View Models

The `vm` method returns an instance of our ActionComponent::Component::ViewModel instantied with the data that you passed when calling the component in the view.

### ActionComponent::Component::ViewModel

It takes all the constructor arguments (it must be a hash/named args) and creates a getter for each one o them. Example:

```ruby
vm = ActionComponent::Component::ViewModel.new(name: 'John', age: 12)
vm.name # John
vm.age # 12
```

### Create your own ViewModel: handle complex view logic

We only use our own view model if there is no view_model.rb file inside your component's folder. This file should declare a class following all the Rails naming conventions.

So, imagine that we want our vm to have a random_greeting method. We can can create a view model like this:


## Use helpers inside your components

In a component's template you will have access to a `h` or `helper` method that will be delegated to the vm instance. So you can use helpers like this:

**Example of a component's templatefile**

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

**app/components/header/view_model.rb**

```ruby
class Header::ViewModel < ActionComponent::Component::ViewModel
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
  <%= vm.random_greeting %>
</header>
```

### Use helpers inside a ViewModel

A `helper` attribute is passed when instantiating a ViewModel. So if you use the default one or your ViewModel inherits from the `ActionComponent::Component::ViewModel` your can access the helpers using `h` or `helper` method.

```ruby
class Header::ViewModel < ActionComponent::Component::ViewModel
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
  <%= vm.random_greeting %> Today is <%= formated_date %>
</header>
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

  # Default name for the view model file inside the component folder
  config.view_model_file_name = 'view_model'
end

```
