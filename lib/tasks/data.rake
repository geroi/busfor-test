namespace :data do
  desc "Loading initial data"
  task load: :environment do
    Rails.logger.level = 1

    ROUTE_LOGS = Dir[Rails.root + "data/search_results/*"]

    LoadInitialData.call(files: ROUTE_LOGS)
    Rails.logger.debug "Initial data loaded"

    ParseRouteLogs.call
    Rails.logger.debug "Routing data parsed"
  end
end
