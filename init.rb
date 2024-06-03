# Write in this file customization code that will get executed before 
# autoproj is loaded.

# Set the path to 'make'
# Autobuild.commands['make'] = '/path/to/ccmake'

# Set the parallel build level (defaults to the number of CPUs)
# Autobuild.parallel_build_level = 10

# Uncomment to initialize the environment variables to default values. This is
# useful to ensure that the build is completely self-contained, but leads to
# miss external dependencies installed in non-standard locations.
#
# set_initial_env
#
# Additionally, you can set up your own custom environment with calls to env_add
# and env_set:
#
# env_add 'PATH', "/path/to/my/tool"
# env_set 'CMAKE_PREFIX_PATH', "/opt/boost;/opt/xerces"
# env_set 'CMAKE_INSTALL_PATH', "/opt/orocos"
#
# NOTE: Variables set like this are exported in the generated 'env.sh' script.
#

require 'autoproj/git_server_configuration'

Autoproj.env_inherit 'CMAKE_PREFIX_PATH'

# autoload config seed (https://github.com/rock-core/autoproj/issues/364)
# allows to load a seed-config.yml file from a buildconf repository
# rather than providing it before checkout using the --seed-config paramater
# of the autoproj_bootstrap script
# this allows to bootstrap with --no-interactive and still apply a custom config e.g. in CI/CD
# The call to this function has to be in the init.rb of the buildconf BEFORE any other
# config option, e.g. the git server configuration settings
# The filename parameter is the name of the config seed yml file in the repository
def define_default_config_seed_in_buildconf(filename)
    Autoproj.configuration_option 'use_default_config', 'boolean',
    :default => "yes",
    :doc => ["Should the default workspace config be used?", "This buildconf defines a default configuration", "Should it be applied?"]
    if (Autoproj.user_config('use_default_config')) then
        unless Autoproj.config.has_value_for?('default_config_applied')
            seed_config = File.join(Autoproj.workspace.root_dir, 'autoproj', filename)
            Autoproj.message "loading seed config #{seed_config}"
            Autoproj.config.load(path: seed_config)
            Autoproj.config.set 'default_config_applied', true, true
        end
    end
end

define_default_config_seed_in_buildconf("config_seed.yml")
