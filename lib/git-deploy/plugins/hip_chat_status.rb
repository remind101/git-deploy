begin
  require 'hipchat'
rescue LoadError => e
  require 'pry'
  binding.pry
end