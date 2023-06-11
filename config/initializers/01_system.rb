# frozen_string_literal: true

module Application
  container = Dry::Container.new
  CONTAINER = container
  Import = Dry::AutoInject(container)
end

def auto_register(category, base: 'app')
  base = "#{ROOT_PATH}/#{base}"
  root_dir = File.join(base, category)
  all_files = Dir[File.join(root_dir, '**/*.rb')]

  container = Application::CONTAINER

  all_files.sort_by { |f| f.count('/') }.each do |path|
    path = path.sub('.rb', '')
    subpath = path.sub("#{root_dir}/", '')

    require path

    key = subpath.gsub('/', '.')

    const_name = key.split('.')
                    .map(&:camelize)
                    .join('::')
                    .constantize

    container.register(key, -> { const_name.new })
  end
end

auto_register('operations', base: 'lib')
# auto_register('transactions')

# Add support of database transactions for Dry::Transaction
# container.register(:transaction) do |input, &block|
#   result = nil

#   begin
#     ActiveRecord::Base.transaction do
#       result = block.call(Dry::Monads.Success(input))
#       raise ActiveRecord::Rollback if result.failure?
#     end
#     result
#   end
# end
