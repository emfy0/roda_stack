# frozen_string_literal: true

module V1
  module Posts
    class IndexPrint < Blueprinter::Base
      identifier :id

      fields :title, :description, :likes, :dislikes
    end
  end
end
