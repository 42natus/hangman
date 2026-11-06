# frozen_string_literal: true

# This module contains the stick figure drawings at different execution stages.
module Hangable
  EXECUTION = {
    '7' => "──────────├\n          ❘\n          ❘\n          ❘\n          ❘\n          ❘\n          ❘\n          ❘\n",
    '6' => "──────────├\n          ❘\n    ☻     ❘\n          ❘\n          ❘\n          ❘\n          ❘\n          ❘\n",
    '5' => "──────────├\n          ❘\n    ☻     ❘\n    |     ❘\n          ❘\n          ❘\n          ❘\n          ❘\n",
    '4' => "──────────├\n          ❘\n    ☻     ❘\n    |     ❘\n   ∕      ❘\n          ❘\n          ❘\n          ❘\n",
    '3' => "──────────├\n          ❘\n    ☻     ❘\n    |     ❘\n   ∕ \\    ❘\n          ❘\n          ❘\n          ❘\n",
    '2' => "──────────├\n          ❘\n    ☻     ❘\n    |     ❘\n   ∕ \\    ❘\n    |     ❘\n          ❘\n          ❘\n",
    '1' => "──────────├\n          ❘\n    ☻     ❘\n    |     ❘\n   ∕ \\    ❘\n    |     ❘\n   /      ❘\n          ❘\n",
    '0' => "──────────├\n          ❘\n    ☻     ❘\n    |     ❘\n   ∕ \\    ❘\n    |     ❘\n   ∕ \\    ❘\n          ❘\n",
    '-1' => "──────────├\n    |     ❘\n    ☹     ❘\n    |     ❘\n   ∕ \\    ❘\n    |     ❘\n   ∕ \\    ❘\n          ❘\n"
  }.freeze

  def stick_figure(stage)
    EXECUTION[stage]
  end
end
