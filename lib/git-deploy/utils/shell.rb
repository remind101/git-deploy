require 'highline'
require 'forwardable'

module Git
  module Deploy
    module Utils
      class Shell < HighLine
      end
    end
  end
end

##
# Core extensions for coloring strings.
# TODO move this somewhere else?
class String

  HighLine::COLORS.map(&:downcase).each do |color|
    define_method( color ){ HighLine::Style( color.to_sym ).color self }
  end
end
