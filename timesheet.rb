require 'ap'
require 'pry'
require 'yaml'

class Timesheet
  class << self
    def bootstrap
      new
    end
  end

  DEFAULTS = {
    source_file: 'source.yml',
    config_file: 'config.yml'
  }.freeze

  attr_accessor :source, :config

  def initialize(options = DEFAULTS)
    @source = YAML.load_file(options[:source_file])
    @config = YAML.load_file(options[:config_file])['config']
  end

  # Output to STDIN for now
  def generate!
    puts generate_day(*@source.first)
  end

  private

  def generate_day(timestamp, data)
    <<~REP
      #{timestamp}:
      #{day_info(data)}
    REP
  end

  def day_info(data)
    data.map do |task, subtasks|
      task_info(task, subtasks)
    end.join('')
  end

  def task_info(task, subtasks)
    <<~TASK
      #{indention 1}Task #{task}:
      #{task_detail_list(subtasks)}
    TASK
  end

  def task_detail_list(subtasks)
    subtasks.map { |subtask| "#{indention 2}- #{subtask}" }.join("\n")
  end

  def indention(level)
    ' ' * (level * 2)
  end
end

Timesheet.bootstrap.generate!
