module Toolsets
  class << self
    @@location = File.dirname(__FILE__) + '/toolsets'
    Dir["#{@@location}/*.rb"].each do |fname|
      name = File.basename(fname).gsub(/\.rb$/,'')
      define_method(name) do |env, options = {}|
        require_relative "toolsets/#{name}"
        self.send(name, env, options)
      end
    end
  end
end
