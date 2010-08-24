begin
  require 'metric_fu'
rescue LoadError => e
end

if defined? :MetricFu
  MetricFu::Configuration.run do |config|
    config.metrics = config.metrics - [:churn]
  end
end
