name 'postfix'
maintainer 'Chef Software, Inc.'
maintainer_email 'cookbooks@chef.io'
license 'Apache 2.0'
description 'Installs and configures postfix for client or outbound relayhost, or to do SASL auth'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '3.7.0'
issues_url 'https://github.com/chef-cookbooks/postfix/issues' if respond_to?(:source_url)
source_url 'https://github.com/chef-cookbooks/postfix' if respond_to?(:issues_url)

recipe 'postfix', 'Installs and configures postfix'
recipe 'postfix::sasl_common', 'Installs the SASL packages and configures smtpd.conf'
recipe 'postfix::sasldb', 'Creates SASL users from attributes'
recipe 'postfix::sasl_auth', 'Sets up Postfix to auth to a server with SASL'
recipe 'postfix::aliases', 'Manages /etc/aliases'
recipe 'postfix::transports', 'Manages /etc/postfix/transport'
recipe 'postfix::access', 'Manages /etc/postfix/access'
recipe 'postfix::virtual_aliases', 'Manages /etc/postfix/virtual'
recipe 'postfix::client', 'Searches for the relayhost based on an attribute'
recipe 'postfix::server', 'Sets the mail_type attribute to master'

%w(ubuntu debian redhat centos amazon oracle scientific smartos fedora).each do |os|
  supports os
end

attribute 'postfix/main',
          display_name: 'postfix/main',
          description: 'Hash of Postfix main.cf attributes',
          type: 'hash'

attribute 'postfix/aliases',
          display_name: 'Postfix Aliases',
          description: "Hash of Postfix aliases mapping a name to a value. Example 'root' => 'operator@example.com'. See aliases man page for details.",
          type: 'hash'

attribute 'postfix/transports',
          display_name: 'Postfix Transports',
          description: "Hash of Postfix transports mapping a destination to a smtp server. Example 'my.domain' => 'smtp:outbound-relay.my.domain'. See transport man page for details.",
          type: 'hash'

attribute 'postfix/access',
          display_name: 'Postfix Access Table',
          description: "Hash of Postfix accesses mapping a pattern to a action.  Example 'domain.tld' => 'OK'.  See access man page for details.",
          type: 'hash'

attribute 'postfix/dhparam_bits',
          display_name: 'Postfix DH Parameter Bits',
          description: 'Number of bits to generate or nil to use the built-in parameters',
          default: nil

attribute 'postfix/mail_type',
          display_name: 'Postfix Mail Type',
          description: 'Is this node a client or server?',
          default: 'client'

attribute 'postfix/sasl_conf',
          display_name: 'postfix/sasl_conf',
          description: 'Hash of SASL smtpd.conf attributes',
          type: 'hash',
          recipes: ['postfix::sasl_common']

attribute 'postfix/sasl_conf/pwcheck_method',
          display: 'SASL password check method',
          description: "smtpd.conf's pwcheck_method parameter",
          type: 'string',
          default: 'saslauthd',
          recipes: ['postfix::sasl_common']

attribute 'postfix/sasl_conf/mech_list',
          display: 'SASL mechanism list',
          description: "smtpd.conf's mech_list parameter",
          type: 'array',
          default: %w(plain login),
          recipes: ['postfix::sasl_common']

attribute 'postfix/sasldb/users',
          display_name: 'SASL database users',
          description: 'Email/password pairs of SASL users to create',
          type: 'hash',
          recipes: ['postfix::sasldb']

attribute 'postfix/sasldb/group',
          display_name: 'SASL database group',
          description: 'Group to assign to the sasldb file',
          type: 'string',
          default: 'postfix'

attribute 'postfix/sasldb/path',
          display_name: 'SASL database path',
          description: 'Path to the sasldb file',
          type: 'string',
          default: '/etc/sasldb2'

attribute 'postfix/smtp_sasl_user_name',
          display_name: 'Postfix SMTP SASL Username',
          description: 'User to auth SMTP via SASL',
          default: ''

attribute 'postfix/smtp_sasl_passwd',
          display_name: 'Postfix SMTP SASL Password',
          description: 'Password for smtp_sasl_user_name',
          default: ''

attribute 'postfix/relayhost_role',
          display_name: "Postfix Relayhost's role",
          description: 'String containing the role name',
          default: 'relayhost'

attribute 'postfix/use_procmail',
          display_name: 'Postfix Use procmail?',
          description: 'Whether procmail should be used as the local delivery agent for a server',
          default: 'no'
