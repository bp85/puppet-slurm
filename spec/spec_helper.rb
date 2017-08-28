require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
require 'lib/module_spec_helper'

include RspecPuppetFacts

dir = File.expand_path(File.dirname(__FILE__))

Dir["#{dir}/support/*.rb"].sort.each {|f| require f}

at_exit { RSpec::Puppet::Coverage.report! }

def cpuinfo_fixtures(filename)
  fixtures('cpuinfo', filename)
end

def cpuinfo_fixture_read(filename)
  File.read(cpuinfo_fixtures(filename))
end

def cpuinfo_fixture_readlines(filename)
  cpuinfo_fixture_read(filename).split(/\n/)
end

def meminfo_fixtures(filename)
  fixtures('meminfo', filename)
end

def meminfo_fixture_read(filename)
  File.read(meminfo_fixtures(filename))
end

def meminfo_fixture_readlines(filename)
  meminfo_fixture_read(filename).split(/\n/)
end

class String
  def camel_case
    return self if self !~ /_/ && self =~ /[A-Z]+.*/
    split('_').map{|e| e.capitalize}.join
  end
end
