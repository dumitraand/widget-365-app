
task :test do
  Dir["./test/**/*.rb"].reject { |f| /test_helper\.rb$/ =~ f }.each do |f|
    system("ruby -Ilib:test #{f}")
  end
end
