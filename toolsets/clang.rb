module Toolsets
  def self.clang(env, options = {})
    env.set_toolset(:gcc, options)
    env['AS']  = 'clang'
    env['CC']  = 'clang'
    env['CXX'] = 'clang'
    env['LD']  = 'clang'
  end
end
