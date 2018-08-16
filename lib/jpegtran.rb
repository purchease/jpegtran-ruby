require_relative "jpegtran/configuration"

module Jpegtran
  extend self

  class Error < StandardError
  end

  BOOLEAN_ARGS = [
    :arithmetic, :grayscale, :optimize, :perfect, :progressive,
    :transpose, :transverse, :trim, :verbose
  ]

  COPY_OPTIONS = [
    :none, :comments, :all
  ]

  FLIP_OPTIONS = [
    :horizontal, :vertical
  ]

  def configured?
    !executable.nil?
  end

  def executable
    configuration.executable
  end

  def configuration
    @configuration ||= Configuration.new
  end

  def configure
    yield configuration
  end

  def optimize(path, options = {})
    cmd = [executable]

    # Boolean arguments
    options.each_pair do |k, v|
      if BOOLEAN_ARGS.include?(k) && v
        cmd << "-#{k}"
      end
    end

    # Integer arguments
    [ :rotate, :restart ].each do |arg|
      if Integer === options[arg]
        cmd << "-#{arg} #{options[arg]}"
      elsif options.include?(arg)
        raise Error.new("Invalid value for :#{arg} option. Integer expected.")
      end
    end

    # String arguments
    [ :crop, :scans ].each do |arg|
      if String === options[arg]
        cmd << "-#{arg} #{options[arg]}"
      elsif options.include?(arg)
        raise Error.new("Invalid value for :#{arg} option. Structured string expected. See 'jpegtran' reference.")
      end
    end

    # Copy
    if options.include?(:copy)
      value = options[:copy].to_sym

      if COPY_OPTIONS.include?(value)
        cmd << "-copy #{value}"
      else
        raise Error.new("Invalid value for :copy. Expected #{COPY_OPTIONS}")
      end
    end

    # Flip
    if options.include?(:flip)
      value = options[:flip].to_sym

      if FLIP_OPTIONS.include?(value)
        cmd << "-flip #{value}"
      else
        raise Error.new("Invalid value for :flip. Expected #{FLIP_OPTIONS}")
      end
    end

    # Outfile
    if options.include?(:outfile)
      if String === options[:outfile]
        out = options[:outfile]
      else
        raise Error.new("Invalid value for :outfile option. String expected.")
      end
    else
      out = path.to_s
    end

    cmd << "-outfile #{out}"
    cmd << path.to_s
    cmd = cmd.join(" ")

    IO.popen(cmd) do |f|
      f.read.chomp
    end
  end
end
