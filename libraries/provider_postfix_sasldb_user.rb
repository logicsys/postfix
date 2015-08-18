#
# Cookbook Name:: postfix
# Provider:: sasldb_user
#

require 'chef/provider/lwrp_base'
require 'chef/mixin/shell_out'

class Chef
  class Provider
    class PostfixSasldbUser < Chef::Provider::LWRPBase
      include Chef::Mixin::ShellOut

      provides :postfix_sasldb_user
      use_inline_resources

      def whyrun_supported?
        true
      end

      def load_current_resource
        @current_resource = Chef::Resource::PostfixSasldbUser.new(@new_resource.name)

        cmd = Mixlib::ShellOut.new("sasldblistusers2 | grep '^#{@current_resource.email}: '")
        cmd.run_command

        @current_resource.exists = true unless cmd.error?
        @current_resource
      end

      def action_create
        return if current_resource.exists?
        shell_out!('saslpasswd2', '-c', '-p', '-u', new_resource.domain, new_resource.username, input: new_resource.password)
        new_resource.updated_by_last_action(true)
        set_permissions
      end

      def action_disable
        return unless current_resource.exists?
        shell_out!('saslpasswd2', '-d', '-u', current_resource.domain, current_resource.username)
        new_resource.updated_by_last_action(true)
        set_permissions
      end

      def set_permissions
        file node['postfix']['sasldb']['path'] do
          owner 'root'
          group node['postfix']['sasldb']['group']
          mode '0640'
          action :touch
          only_if { ::File.exist? path }
        end
      end
    end
  end
end
