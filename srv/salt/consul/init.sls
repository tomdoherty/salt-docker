repo:
  pkgrepo.managed:
    - name: hashicorp
    - humanname: Hashicorp Stable - $basearch
    - baseurl: https://rpm.releases.hashicorp.com/RHEL/$releasever/$basearch/stable
    - gpgcheck: 1
    - gpgkey: https://rpm.releases.hashicorp.com/gpg

consul:
  pkg.installed

config:
  file.managed:
    - name: /etc/consul.d/consul.hcl
    - contents: |
        data_dir = "/opt/consul"
        server = true
        bind_addr = "0.0.0.0"
        advertise_addr = "127.0.0.1"
        bootstrap_expect = 1

consul service:
  service.running:
    - name: consul
    - enable: True
    - reload: True
    - watch:
      - file: /etc/consul.d/consul.hcl

consul.agent_service_register:
  module.run:
    - consul_url: http://localhost:8500
    - kwargs:
        name: "testing"
        id: "testing"
        port: 9100
        
