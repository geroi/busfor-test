RailsAdmin.config do |config|
  config.main_app_name = ["Busfor Test App", "Админ"]

  config.actions do
    dashboard
    index
    new
    bulk_delete
    show
    edit
    delete
  end

  Rails.application.eager_load!

  ApplicationRecord.descendants.each do |model_class|
    model = model_class.to_s.underscore
    config.model model.capitalize do
      label I18n.t("admin.#{model}.singular")
      label_plural I18n.t("admin.#{model}.plural")
    end
  end
end
