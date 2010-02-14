require File.join( File.dirname( __FILE__ ), "..", "lib", "table" )
 
=begin
module Table
  module Test
    module Factory
      def create_backend_record( name = :temp )
        Packit::Backend.create name do | record |
          if block_given?
            yield record
          else
            record.add :field_1
            record.add :field_2
            record.add :field_3
          end
        end
      end
    end
  end
end
=end
 
Spec::Runner.configure do |config|
  #config.include Table::Test::Factory
end
