shared_examples_for 'slurm::slurmdbd' do

  it { should contain_anchor('slurm::slurmdbd::start').that_comes_before('Class[munge]') }
  it { should contain_class('munge').that_comes_before('Class[slurm::common::user]') }
  it { should contain_class('slurm::common::user').that_comes_before('Class[slurm::common::install]') }
  it { should contain_class('slurm::common::install').that_comes_before('Class[slurm::common::setup]') }
  it { should contain_class('slurm::common::setup').that_comes_before('Class[slurm::slurmdbd::config]') }
  it { should contain_class('slurm::slurmdbd::config').that_comes_before('Class[slurm::slurmdbd::service]') }
  it { should contain_class('slurm::slurmdbd::service').that_comes_before('Anchor[slurm::slurmdbd::end]') }
  it { should contain_anchor('slurm::slurmdbd::end') }

  it_behaves_like 'slurm::common::user'
  it_behaves_like 'slurm::common::install-slurmdbd'
  it_behaves_like 'slurm::common::setup'
  it_behaves_like 'slurm::slurmdbd::config'
  it_behaves_like 'slurm::slurmdbd::service'
end
