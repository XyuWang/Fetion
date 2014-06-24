# Fetion

Fetion SMS gem
## Installation

Add this line to your application's Gemfile:

    gem 'fetion'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fetion

## Usage
    f = Fetion.new 'phone number', 'fetion password'
    f.send 'receiver phone number', 'content'
    f.logout

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
