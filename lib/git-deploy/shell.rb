require 'highline'
require 'forwardable'

module Git
  module Deploy
    module Shell
      extend Forwardable

      ##
      # A new HighLine instance.
      def shell
        @shell ||= HighLine.new
      end
      def_delegators :shell, :agree, :say
    end
  end
end

##
# Core extensions for coloring strings
class String

  HighLine::COLORS.map(&:downcase).each do |color|
    define_method( color ){ HighLine::Style( color.to_sym ).color self }
  end
end
