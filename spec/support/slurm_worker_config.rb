shared_examples 'slurm::worker::config' do
  let(:params) { context_params }

  it do
    should contain_file('SlurmdSpoolDir').with({
      :ensure => 'directory',
      :path   => '/var/spool/slurmd',
      :owner  => 'root',
      :group  => 'root',
      :mode   => '0755',
    })
  end

  it { should_not contain_file('epilog') }
  it { should_not contain_file('health_check_program') }
  it { should_not contain_file('prolog') }
  it { should_not contain_file('task_epilog') }
  it { should_not contain_file('task_prolog') }

  it do
    should contain_logrotate__rule('slurmd').with({
      :path          => '/var/log/slurm/slurmd.log',
      :compress      => 'true',
      :missingok     => 'true',
      :copytruncate  => 'false',
      :delaycompress => 'false',
      :ifempty       => 'false',
      :rotate        => '10',
      :sharedscripts => 'true',
      :size          => '10M',
      :create        => 'true',
      :create_mode   => '0640',
      :create_owner  => 'slurm',
      :create_group  => 'root',
      :postrotate    => '/etc/init.d/slurm reconfig >/dev/null 2>&1',
    })
  end

  it_behaves_like 'slurm_conf_common'
  it_behaves_like 'slurm_conf_partitions'

  context 'when manage_logrotate => false' do
    let(:params) { context_params.merge({ :manage_logrotate => false }) }
    it { should_not contain_logrotate__rule('slurmd') }
  end

  context 'when epilog => /tmp/foo' do
    let(:params) { context_params.merge({ :epilog => '/tmp/foo' }) }

    it do
      should contain_file('epilog').with({
        :ensure => 'file',
        :path   => '/tmp/foo',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end
  end

  context 'when health_check_program => /tmp/nhc' do
    let(:params) { context_params.merge({ :health_check_program => '/tmp/nhc' }) }

    it do
      should contain_file('health_check_program').with({
        :ensure => 'file',
        :path   => '/tmp/nhc',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end
  end

  context 'when prolog => /tmp/bar' do
    let(:params) { context_params.merge({ :prolog => '/tmp/bar' }) }

    it do
      should contain_file('prolog').with({
        :ensure => 'file',
        :path   => '/tmp/bar',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end
  end

  context 'when task_epilog => /tmp/epilog' do
    let(:params) { context_params.merge({ :task_epilog => '/tmp/epilog' }) }

    it do
      should contain_file('task_epilog').with({
        :ensure => 'file',
        :path   => '/tmp/epilog',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end
  end

  context 'when task_prolog => /tmp/foobar' do
    let(:params) { context_params.merge({ :task_prolog => '/tmp/foobar' }) }

    it do
      should contain_file('task_prolog').with({
        :ensure => 'file',
        :path   => '/tmp/foobar',
        :source => nil,
        :owner  => 'root',
        :group  => 'root',
        :mode   => '0754',
      })
    end
  end
end
