$:.push File.join(File.dirname(__FILE__), '..', 'lib')

require 'gg'
Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each {|f| require f }
