# SkypeApi

SkypeApi is a gem to use Skype API in Ruby projects.
It's testing and working.

## Installation

Install Skype, dbus, Xvfb and some fonts:

    sudo aptitude install skype
    sudo aptitude install dbus xvfb
    sudo aptitude install xfonts-100dpi xfonts-75dpi xfonts-scalable xfonts-cyrillic

Add this line to your application's Gemfile:

    gem 'skype_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install skype_api

## Usage

You have to run Skype at least once, because gem needs config files (authorization and API access).

At first You have to run Skype:

    $ skype_api

Next You can use Skype API. For example run Echo Bot:

    $ skype_echo

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
