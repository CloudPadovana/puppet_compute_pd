class compute_pd::pwl_access {

  $home_dir = "/var/lib/nova"
  $config = "Host *
    StrictHostKeyChecking no
    UserKnownHostsFile=/dev/null
"
  $pub_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAIEAz2q6df7MpfQpZtHnOaQkuu4+Ka9KWD8zKS68qp78vieOuJSHoEUwZg2hA1pfVTChuKejuSNnoZso5dJbXBUFJdDpIx9FXGLP3M5UolEvcwxIbYASsRfsE+snWdNbHk8eZ8Ia4b3Km9tAYLBj4btFBqlCbtP5FyRzEKzDI5mltZU= nova@cld-ctrl-01.pd.infn.it"

  user {'nova':
        ensure	=> present,
        shell	=> '/bin/bash',
        require	=> Package["openstack-nova-common"],
  }

  file { 
	"nova_sshdir":
            ensure  => "directory",
            path    => "$home_dir/.ssh",
            owner   => nova,
            group   => nova,
            mode    => 0700;

	"config_ssh":
            path    => "$home_dir/.ssh/config",
	    content => "$config",
            owner   => nova,
            group   => nova,
	    require => File['nova_sshdir'];

	"private_key":
	    source  => 'puppet:///modules/test_access/id_rsa_cld-ctrl-01',
	    path    => "$home_dir/.ssh/id_rsa",
            owner   => nova,
            group   => nova,
            mode    => 0600;

	"public_key":
            path    => "$home_dir/.ssh/id_rsa.pub",
            content => "$pub_key",
            owner   => nova,
            group   => nova,
            require => File['nova_sshdir'];
        }
}
