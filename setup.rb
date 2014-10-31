#------------------------------------------------------------------------------
# Setup and Check Bundle Dependencies
#------------------------------------------------------------------------------
DefaultDeps = [
  ['rake',    '>= 0'],
  ['rscons',  '>= 0'],
  ['rspec',   '>= 0'],
  ['trollop', '>= 0']
]

# Generate a default Gemfile if none exists
if not File.exists? "Gemfile"
  File.open("Gemfile","w") do |f|
    DefaultDeps.each {|d| f.puts("gem '#{d[0]}', '#{d[1]}'") }
  end
end

# Check that we have the right dependencies
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  raise LoadError.new("Unable to Bundler.setup(): Please run 'bundle install': #{e.message}")
end
DefaultDeps.each {|d| require d[0] }
require_relative 'toolsets'

#------------------------------------------------------------------------------
# Command Options
#------------------------------------------------------------------------------
Opts = Trollop::options do
  opt :verbose, "Echo commands being executed", :short => 'v'
  opt :clean,   "Clean all generated files",    :short => 'c'
  opt :purge,   "Purges all generated files and directories", :short => 'p'
  opt :define,  "Define or override a cosntruction variable", :type => :strings, :short => 'D'
end

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
    options[:echo] = :command if Opts[:verbose]
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
at_exit do
  if Opts[:purge]
    FileUtils.rm_rf('build/')
  elsif Opts[:clean]
    Rscons.clean
  else
    BuildEnvManager.process
  end
end

