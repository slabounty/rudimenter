# frozen_string_literal: true

require_relative "rudimenter/version"

require_relative "rudimenter/score"
require_relative "rudimenter/measure"
require_relative "rudimenter/note_event"
require_relative "rudimenter/harmony"

require_relative "rudimenter/rudiments/rudiment_zero"
require_relative "rudimenter/renderers/musicxml_renderer"

module Rudimenter
  class Error < StandardError; end
  # Your code goes here...
end
