module Toolsets
  def self.default(env, options = {})
    env.set_toolset(:gcc, options)
  end
end
