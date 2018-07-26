# require 'spec_helper'

describe package('docker-ce') do
  it { should be_installed }
end

describe service('docker') do
  it { should be_enabled }
  it { should be_running }
end

describe command('/usr/local/bin/docker-compose --version') do
  its(:stdout) { should match /1.21.2/ }
end
