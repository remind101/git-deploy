require 'open3'

module Git
  module Deploy
    module Shell

      ##
      #
      def sh( command )
        puts command if Git::Deploy.verbose # TODO class this up a bit

        out, status = Open3.capture2e command

        return nil if out.chomp.empty?

        if block_given?
          out.lines.each { |line| yield line.chomp }
        end

        out.chomp
      end

      ##
      #
      def sh?( command )
        out, status = Open3.capture2e command

        if block_given?
          out.lines.each { |line| yield line.chomp }
        end

        status.success?
      end
    end
  end
end
