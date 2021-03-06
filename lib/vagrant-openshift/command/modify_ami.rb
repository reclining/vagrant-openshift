#--
# Copyright 2013 Red Hat, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#++
require_relative "../action"

module Vagrant
  module Openshift
    module Commands
      class ModifyAMI < Vagrant.plugin(2, :command)
        include CommandHelper

        def self.synopsis
          "modifies corresponding ami of the current instance"
        end

        def execute
          options = {}
          options[:help] = false
          options[:tag] = nil

          opts = OptionParser.new do |o|
            o.banner = "Usage: vagrant modify-ami [machine-name]"
            o.separator ""

            o.on("-t", "--tag [name]", String, "Tag the AMI") do |f|
              options[:tag] = f
            end

            o.on("-h", "--help", "Show this message") do |f|
              options[:help] = true
            end
          end

          # Parse the options
          argv = parse_options(opts)

          if options[:help]
            @env.ui.info opts
            exit
          end

          with_target_vms(argv, :reverse => true) do |machine|
            actions = Vagrant::Openshift::Action.modify_ami(options)
            @env.action_runner.run actions, {:machine => machine}
            0
          end
        end
      end
    end
  end
end
