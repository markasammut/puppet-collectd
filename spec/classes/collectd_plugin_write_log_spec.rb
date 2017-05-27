require 'spec_helper'

describe 'collectd::plugin::write_log', type: :class do
  on_supported_os.each do |os, facts|
    context "on #{os} " do
      let :facts do
        facts.merge
      end

      options = os_specific_options(facts)
      context ':ensure => present and :format => \'JSON\'' do
        let :params do
          { format: 'JSON' }
        end

        it { is_expected.to contain_collectd__plugin('write_log') }
        it { is_expected.to contain_file('old_write_log.load').with_ensure('absent') }
        it { is_expected.to contain_file('older_write_log.load').with_ensure('absent') }
        it 'Will create 10-write_log.conf' do
          is_expected.to contain_file('write_log.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-write_log.conf",
            content: "#\ Generated by Puppet\n<LoadPlugin write_log>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"write_log\">\n  Format \"JSON\"\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => present and :format => \'Graphite\'' do
        let :params do
          { format: 'Graphite' }
        end

        it 'Will create 10-write_log.conf' do
          is_expected.to contain_file('write_log.load').with(
            ensure: 'present',
            path: "#{options[:plugin_conf_dir]}/10-write_log.conf",
            content: "#\ Generated by Puppet\n<LoadPlugin write_log>\n  Globals false\n</LoadPlugin>\n\n<Plugin \"write_log\">\n  Format \"Graphite\"\n</Plugin>\n\n"
          )
        end
      end

      context ':ensure => absent' do
        let :params do
          { ensure: 'absent' }
        end

        it 'Will not create 10-write_log.conf' do
          is_expected.to contain_file('write_log.load').with(
            ensure: 'absent',
            path: "#{options[:plugin_conf_dir]}/10-write_log.conf"
          )
        end
      end
    end
  end
end
