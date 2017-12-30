# CloudText

This gem removes punctuation and digits(optional), filters stopwords for the chosen language ('tr', 'en' or 'fr'), does stemming on the words and outputs an array of words with their frequencies.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cloud_text'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cloud_text

## Usage

```ruby
require 'cloud_text'

# Default options
# remove_digits => false
# language => "en"
# stemming => false

options = { remove_digits: false, language: "en", stemming: true }
cleaner = CloudText.clean_text("Your text to be cleaned, will come here1!1", options)
# => [["come", 1], ["will", 1], ["clean", 1], ["text", 1]]
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/twentify/cloud_text. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Code of Conduct

Everyone interacting in the CloudText project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/twentify/cloud_text/blob/master/CODE_OF_CONDUCT.md).
