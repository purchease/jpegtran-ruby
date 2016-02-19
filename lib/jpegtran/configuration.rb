module Jpegtran
  class Configuration

    COMMAND = :jpegtran

    def executable=(path)
      @executable = path
    end

    def executable
      @executable ||= default_executable
    end

    def default_executable
      path = `which #{COMMAND}`
      $? == 0 ? path.chomp! : nil
    end
  end
end
