namespace :data do
  desc "Loading initial data"
  task load: :environment do
    ROUTE_LOGS = Dir[Rails.root + "data/search_results/*"]

    LoadInitialData.call(files: ROUTE_LOGS)
    Rails.logger.info "Initial data loaded"

    ParseRouteLogs.call
    Rails.logger.info "Routing data parsed"
  end
end
