## CMG 365-Widgets

### Ruby version: ruby 2.5.5p157 (2019-03-15 revision 67260) [x86_64-darwin18]

### Usage
```bash
$ ruby sensor_evaluator.rb
$ ruby sensor_evaluator.rb -f /path/to/file/to/be/read
$ ruby sensor_evaluator.rb --file=path/to/file/to/be/read
```

**NOTE**: `-f`/`--file` defaults to `/path/to/wiged-365-app/docs/sensors.log`

### Options
```bash
$ ruby sensor_evaluator.rb -h
Usage: example.rb [options]
    -f, --file=FILE                  Open file for reading
```

### Tests
Install `minitest` by running `bundle install`.

This application contains a Rakefile for testing
```ruby
task :test do
  Dir["./test/**/*.rb"].reject { |f| /test_helper\.rb$/ =~ f }.each do |f|
    system("ruby -Ilib:test #{f}")
  end
end
```

To run the tests use `rake test`.

