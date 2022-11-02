# frozen_string_literal: true

module RuboCop
  module CustomCops
    # This cop checks for TODO/FIXME/etc comments.
    #
    # Avoid TODO comments, instead create tickets for them and assign
    # them to the right person. Half of the TODOs usually never get done, and
    # the code is then polluted with old stale TODOs. Sometimes developers
    # really mean to work on their TODOs soon, but then Product
    # re-prioritizes their work, or the developer leaves the company, and
    # never get a chance to tackle them.
    class NoTodos < Cop::Cop
      MSG = "Avoid TODO comment, create a ticket instead."
      KEYWORD_REGEX = /(^|[^\w])(TODO|FIXME|OPTIMIZE|HACK)($|[^\w])/i.freeze

      def on_new_investigation
        processed_source.comments.each do |comment|
          if comment.text.match?(KEYWORD_REGEX)
            add_offense(comment)
          end
        end
      end
    end
  end
end
