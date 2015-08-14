require 'chef/knife/profitbricks_base'

class Chef
  class Knife
    class ProfitbricksServerStart < Knife
      include Knife::ProfitbricksBase

      banner 'knife profitbricks server start SERVER_UUID [SERVER_UUID] (options)'

      option :datacenter_id,
             short: '-D DATACENTER_UUID',
             long: '--datacenter-id DATACENTER_UUID',
             description: 'UUID of the data center',
             proc: proc { |datacenter_id| Chef::Config[:knife][:datacenter_id] = datacenter_id }

      def run
        connection
        @name_args.each do |server_id|
          begin
            server = ProfitBricks::Server.get(config[:datacenter_id], server_id)
          rescue Excon::Errors::NotFound
            ui.error("Server ID #{server_id} not found. Skipping.")
            next
          end

          server.start
          ui.warn("Server #{server.id} is starting")
        end
      end
    end
  end
end