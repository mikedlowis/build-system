#------------------------------------------------------------------------------
# Check Bundle Dependencies
#------------------------------------------------------------------------------
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  raise LoadError.new("Unable to Bundler.setup(): Please run 'bundle install': #{e.message}")
end
require 'rake'
require 'rscons'
require_relative 'toolsets'

#------------------------------------------------------------------------------
# Environment Manager
#------------------------------------------------------------------------------
module BuildEnvManager
  @@environments = []

  def self.register(env)
    @@environments << env
  end

  def self.process()
    @@environments.each {|env| env.process }
  end
end

#------------------------------------------------------------------------------
# Environment Class
#------------------------------------------------------------------------------
class BuildEnv < Rscons::Environment
  attr_reader :toolset

  def initialize(options = {})
    super(options)
    BuildEnvManager.register(self)
  end

  def set_toolset(name, options = {})
    if Toolsets.respond_to?(name)
      Toolsets.send(name, self, options)
      @toolset = name
    else
      raise "No toolset found for selection '#{name}'"
    end
  end
end

# Make sure we process any environments before rake exits
at_exit { BuildEnvManager.process }

