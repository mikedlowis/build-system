module Toolsets
  def self.gcc(env, options = {})
      default_vars = {
        "AR" => "ar",
        "ARCMD" => ["${AR}", "rcs", "${ARFLAGS}", "${_TARGET}", "${_SOURCES}"],
        "ARFLAGS" => [],

        "AS" => "${CC}",
        "ASCMD" => ["${AS}", "-c", "-o", "${_TARGET}", "${ASDEPGEN}", "-I${ASPPPATH}", "${ASPPFLAGS}", "${ASFLAGS}", "${_SOURCES}"],
        "ASDEPGEN" => ["-MMD", "-MF", "${_DEPFILE}"],
        "ASFLAGS" => [],
        "ASPPFLAGS" => ["${CPPFLAGS}"],
        "ASSUFFIX" => ".S",

        "CC" => "gcc",
        "CCCMD" => ["${CC}", "-c", "-o", "${_TARGET}", "${CCDEPGEN}", "-I${CPPPATH}", "${CPPFLAGS}", "${CFLAGS}", "${_SOURCES}"],
        "CCDEPGEN" => ["-MMD", "-MF", "${_DEPFILE}"],
        "CFLAGS" => [],
        "CSUFFIX" => ".c",

        "CXX" => "g++",
        "CXXCMD" => ["${CXX}", "-c", "-o", "${_TARGET}", "${CXXDEPGEN}", "-I${CPPPATH}", "${CPPFLAGS}", "${CXXFLAGS}", "${_SOURCES}"],
        "CXXDEPGEN" => ["-MMD", "-MF", "${_DEPFILE}"],
        "CXXFLAGS" => [],
        "CXXSUFFIX" => ".cc",

        "CPP_CMD" => ["${_PREPROCESS_CC}", "-E", "-o", "${_TARGET}", "-I${CPPPATH}", "${CPPFLAGS}", "${CFLAGS}", "${_SOURCES}"],
        "CPPFLAGS" => ["-D${defines}"],

        "DISASM_CMD" => ["${OBJDUMP}", "${DISASM_FLAGS}", "${_SOURCES}"],
        "DISASM_FLAGS" => ["--disassemble", "--source"],

        "LD" => nil,
        "LDCMD" => ["${LD}", "-o", "${_TARGET}", "${LDFLAGS}", "${_SOURCES}", "-L${LIBPATH}", "-l${LIBS}"],
        "LDFLAGS" => [],

        "OBJDUMP" => "objdump",
        "OBJSUFFIX" => ".o",
      }
      default_vars.each_pair do |var, val|
        env[var] = val
      end
  end
end
