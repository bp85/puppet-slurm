shared_examples_for 'slurm::common::config' do
  it { should have_slurm__spank_resource_count(0) }

  context 'with spank_plugins defined' do
    let(:params) {{ :spank_plugins => {'x11' => {}} }}

    it { should have_slurm__spank_resource_count(1) }
    it { should contain_slurm__spank('x11') }
  end

  it do
    should contain_file('slurm.conf').with({
      :ensure         => 'present',
      :path           => '/etc/slurm/slurm.conf',
      :owner          => 'root',
      :group          => 'root',
      :mode           => '0644',
    })
  end

  it do
    verify_exact_file_contents(catalogue, 'slurm.conf', [
      "AccountingStorageHost=slurm",
      "AccountingStoragePort=6819",
      "AccountingStorageType=accounting_storage/slurmdbd",
      "AccountingStoreJobComment=YES",
      "AuthType=auth/munge",
      "CacheGroups=0",
      "CheckpointType=checkpoint/none",
      "ClusterName=linux",
      "CompleteWait=0",
      "ControlMachine=slurm",
      "CryptoType=crypto/munge",
      "DefaultStorageHost=slurm",
      "DefaultStoragePort=6819",
      "DefaultStorageType=slurmdbd",
      "DisableRootJobs=NO",
      "EpilogMsgTime=2000",
      "FastSchedule=1",
      "FirstJobId=1",
      "GetEnvTimeout=2",
      "GroupUpdateForce=0",
      "GroupUpdateTime=600",
      "HealthCheckInterval=0",
      "HealthCheckNodeState=ANY",
      "InactiveLimit=0",
      "JobAcctGatherFrequency=task=30",
      "JobAcctGatherType=jobacct_gather/linux",
      "JobCheckpointDir=/var/lib/slurm/checkpoint",
      "JobCompType=jobcomp/none",
      "JobRequeue=1",
      "KillOnBadExit=0",
      "KillWait=30",
      "MailProg=/bin/mail",
      "MaxArraySize=1001",
      "MaxJobCount=10000",
      "MaxJobId=4294901760",
      "MaxMemPerCPU=0",
      "MaxMemPerNode=0",
      "MaxStepCount=40000",
      "MaxTasksPerNode=128",
      "MessageTimeout=10",
      "MinJobAge=300",
      "MpiDefault=none",
      "OverTimeLimit=0",
      "PlugStackConfig=/etc/slurm/plugstack.conf",
      "PluginDir=/usr/lib64/slurm",
      "PreemptMode=OFF",
      "PreemptType=preempt/none",
      "PriorityType=priority/basic",
      "ProctrackType=proctrack/pgid",
      "PropagatePrioProcess=0",
      "PropagateResourceLimits=ALL",
      "ResvOverRun=0",
      "ReturnToService=0",
      "SchedulerTimeSlice=30",
      "SchedulerType=sched/backfill",
      "SelectType=select/linear",
      "SlurmSchedLogFile=/var/log/slurm/slurmsched.log",
      "SlurmSchedLogLevel=0",
      "SlurmUser=slurm",
      "SlurmctldDebug=info",
      "SlurmctldLogFile=/var/log/slurm/slurmctld.log",
      "SlurmctldPidFile=/var/run/slurm/slurmctld.pid",
      "SlurmctldPort=6817",
      "SlurmctldTimeout=120",
      "SlurmdDebug=info",
      "SlurmdLogFile=/var/log/slurm/slurmd.log",
      "SlurmdPidFile=/var/run/slurm/slurmd.pid",
      "SlurmdPort=6818",
      "SlurmdSpoolDir=/var/spool/slurmd",
      "SlurmdTimeout=300",
      "SlurmdUser=root",
      "StateSaveLocation=/var/lib/slurm/state",
      "SwitchType=switch/none",
      "TaskPlugin=task/none",
      "TmpFS=/tmp",
      "TopologyPlugin=topology/none",
      "TrackWCKey=no",
      "TreeWidth=50",
      "UsePAM=0",
      "VSizeFactor=0",
      "WaitTime=0",
      "Include /etc/slurm/nodes.conf",
      "Include /etc/slurm/partitions.conf",
    ])
  end

  it do
    should contain_file('slurm-partitions.conf').with({
      :ensure         => 'present',
      :path           => '/etc/slurm/partitions.conf',
      :owner          => 'root',
      :group          => 'root',
      :mode           => '0644',
    })
  end

  it do
    verify_exact_file_contents(catalogue, 'slurm-partitions.conf', [])
  end

  it do
    should contain_datacat('slurm-nodes.conf').with({
      :ensure         => 'present',
      :path           => '/etc/slurm/nodes.conf',
      :template       => 'slurm/slurm.conf/nodes.conf.erb',
      :owner          => 'root',
      :group          => 'root',
      :mode           => '0644',
    })
  end

  it do
    should contain_file('plugstack.conf.d').with({
      :ensure   => 'directory',
      :path     => '/etc/slurm/plugstack.conf.d',
      :recurse  => 'true',
      :purge    => 'true',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    should contain_file('plugstack.conf').with({
      :ensure   => 'file',
      :path     => '/etc/slurm/plugstack.conf',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it do
    verify_exact_file_contents(catalogue, 'plugstack.conf', [
      "include /etc/slurm/plugstack.conf.d/*.conf",
    ])
  end

  it do
    should contain_file('slurm-cgroup.conf').with({
      :ensure   => 'file',
      :path     => '/etc/slurm/cgroup.conf',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it "should have cgroup.conf with valid contents" do
    verify_contents(catalogue, 'slurm-cgroup.conf', [
      'CgroupMountpoint=/cgroup',
      'CgroupAutomount=yes',
      'CgroupReleaseAgentDir="/etc/slurm/cgroup"',
      'ConstrainCores=no',
      'TaskAffinity=no',
      'AllowedRAMSpace=100',
      'AllowedSwapSpace=0',
      'ConstrainRAMSpace=no',
      'ConstrainSwapSpace=no',
      'MaxRAMPercent=100',
      'MaxSwapPercent=100',
      'MinRAMSpace=30',
      'ConstrainDevices=no',
      'AllowedDevicesFile=/etc/slurm/cgroup_allowed_devices_file.conf',
    ])
  end

  it do
    should contain_file('cgroup_allowed_devices_file.conf').with({
      :ensure   => 'file',
      :path     => '/etc/slurm/cgroup_allowed_devices_file.conf',
      :owner    => 'root',
      :group    => 'root',
      :mode     => '0644',
    })
  end

  it "should have cgroup_allowed_devices_file.conf with valid contents" do
    verify_contents(catalogue, 'cgroup_allowed_devices_file.conf', [
      '/dev/null',
      '/dev/urandom',
      '/dev/zero',
      '/dev/sda*',
      '/dev/cpu/*/*',
      '/dev/pts/*',
    ])
  end

  it do
    should contain_sysctl('net.core.somaxconn').with({
      :ensure => 'present',
      :value  => '1024',
    })
  end

  context 'when use_syslog => true' do
    let(:params) { default_params.merge({:use_syslog => true}) }

    it do
      should contain_file('slurm.conf') \
        .without_content(/^SlurmctldLogFile.*$/) \
        .without_content(/^SlurmdLogFile.*$/)
    end
  end

  context 'when slurm_conf_override defined' do
    let :params do
       default_params.merge({
        :slurm_conf_override => {
          'PreemptMode'         => 'SUSPEND,GANG',
          'PreemptType'         => 'preempt/partition_prio',
          'ProctrackType'       => 'proctrack/linuxproc',
          'SchedulerParameters' => [
            'bf_continue',
            'defer',
          ]
        }
      })
    end

    it "should override values" do
      verify_contents(catalogue, 'slurm.conf', [
        'PreemptMode=SUSPEND,GANG',
        'PreemptType=preempt/partition_prio',
        'ProctrackType=proctrack/linuxproc',
        'SchedulerParameters=bf_continue,defer',
      ])
    end
  end

  context 'when partitionlist defined' do
    let :params do
      default_params.merge({
        :partitionlist => [
          {
            'PartitionName' => 'DEFAULT',
            'Nodes'         => 'c[0-9]',
            'State'         => 'UP',
          },
          {
            'PartitionName' => 'general',
            'Priority'      => '3',
            'MaxNodes'      => '1',
            'MaxTime'       => '48:00:00',
            'Default'       => 'YES',
          }
        ]
      })
    end

    it do
      verify_exact_file_contents(catalogue, 'slurm-partitions.conf', [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=general Default=YES Priority=3 MaxNodes=1 MaxTime=48:00:00",
      ])
    end
  end

  context 'when partitionlist_template defined' do
    let :params do
      default_params.merge({
        :partitionlist_template => 'site_slurm/slurm.conf/partitions.erb',
      })
    end

    it do
      verify_exact_file_contents(catalogue, 'slurm-partitions.conf', [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ])
    end
  end

  context "partitionlist hierarchy - partitionlist_template first" do
    let :params do
      default_params.merge({
        :partitionlist => [
          {
            'PartitionName' => 'DEFAULT',
            'Nodes'         => 'c[0-9]',
            'State'         => 'UP',
          },
          {
            'PartitionName' => 'general',
            'Priority'      => '3',
            'MaxNodes'      => '1',
            'MaxTime'       => '48:00:00',
            'Default'       => 'YES',
          }
        ],
        :partitionlist_template => 'site_slurm/slurm.conf/partitions.erb',
      })
    end

    it do
      verify_exact_file_contents(catalogue, 'slurm-partitions.conf', [
        "PartitionName=DEFAULT Nodes=c[0-9] State=UP",
        "PartitionName=ib Nodes=c[0101-0102] Priority=6 MaxTime=12:00:00 State=UP",
      ])
    end
  end

  context 'when manage_slurm_conf => false' do
    let(:params) { default_params.merge({ :manage_slurm_conf => false }) }
    it { should_not contain_file('slurm.conf') }
    it { should_not contain_file('slurm-partitions.conf') }
    it { should_not contain_concat('slurm-nodes.conf') }
    it { should_not contain_file('plugstack.conf.d') }
    it { should_not contain_file('plugstack.conf') }
    it { should_not contain_file('slurm-cgroup.conf') }
    it { should_not contain_file('cgroup_allowed_devices_file.conf') }
  end

  context 'when slurm_conf_source => "file:///path/slurm.conf"' do
    let(:params) { default_params.merge({ :slurm_conf_source => 'file:///path/slurm.conf'}) }

    it { should contain_file('slurm.conf').without_content }
    it { should contain_file('slurm.conf').with_source('file:///path/slurm.conf') }
  end

  context 'when partitionlist_source => "file:///path/partitions.conf"' do
    let(:params) { default_params.merge({ :partitionlist_source => 'file:///path/partitions.conf'}) }

    it { should contain_file('slurm-partitions.conf').without_content }
    it { should contain_file('slurm-partitions.conf').with_source('file:///path/partitions.conf') }
  end

  context 'when node_source => "file:///path/nodes.conf"' do
    let(:params) { default_params.merge({ :node_source => 'file:///path/nodes.conf'}) }

    it { should_not contain_datacat('slurm-nodes.conf') }
    it { should contain_file('slurm-nodes.conf').with_source('file:///path/nodes.conf') }
  end

  context 'when cgroup_conf_source => "file:///path/cgroup.conf"' do
    let(:params) { default_params.merge({ :cgroup_conf_source => 'file:///path/cgroup.conf'}) }

    it { should contain_file('slurm-cgroup.conf').without_content }
    it { should contain_file('slurm-cgroup.conf').with_source('file:///path/cgroup.conf') }
  end
end
