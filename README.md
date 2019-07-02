SolidusContactUs
================

[![Build Status](https://travis-ci.org/jtapia/solidus_contact_us.svg?branch=master)](https://travis-ci.org/jtapia/solidus_contact_us)

This extension provides a basic contact form for Solidus.

Installation
------------

Add solidus_contact_us to your Gemfile:

```ruby
gem 'solidus_contact_us', github: 'jtapia/solidus_contact_us'
```

Bundle your dependencies and run the installation generator:

```shell
bundle
bundle exec rails g solidus_contact_us:install
```

If you want to change the configuration, you can add the following to an initializer:

```ruby
SolidusContactUs::Config.tap do |config|
  config.mailer_from = 'store@example.com' # String, *optional, default: ''
  config.require_name = true # Boolean, default: false
  config.require_subject = true # Boolean, default: false
  config.contact_tracking_message = '' # String, default: nil
  config.link_on_header = false # Boolean, default: true
  config.link_on_footer = false # Boolean, default: true
end
```

Preview
-------

![](https://user-images.githubusercontent.com/957520/60550867-01091500-9cef-11e9-8c9f-4b78e81f4b24.png)
![](https://user-images.githubusercontent.com/957520/60550869-01091500-9cef-11e9-8c2f-9ee247c2d86a.png)


Testing
-------

First bundle your dependencies, then run `rake`. `rake` will default to building the dummy app if it does not exist, then it will run specs, and [Rubocop](https://github.com/bbatsov/rubocop) static code analysis. The dummy app can be regenerated by using `rake test_app`.

```shell
bundle
bundle exec rake
```

When testing your applications integration with this extension you may use it's factories.
Simply add this require statement to your spec_helper:

```ruby
require 'solidus_contact_us/factories'
```

Copyright (c) 2019 [name of extension creator], released under the New BSD License
