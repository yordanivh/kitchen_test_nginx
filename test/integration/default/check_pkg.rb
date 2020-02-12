 
describe package('wget') do
  it { should be_installed }
end

describe package('language-pack-en') do
  it { should be_installed }
end

describe package('nginx') do
  it { should be_installed }
end

