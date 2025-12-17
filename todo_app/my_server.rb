#!/usr/bin/env ruby

# === 1. Bundler & Bootsnap Setup ===
ENV["BUNDLE_GEMFILE"] ||= File.expand_path("Gemfile", __dir__)
ENV["BOOTSNAP_CACHE_DIR"] ||= File.expand_path("tmp/cache/bootsnap", __dir__)
require "bundler/setup"
require "bootsnap/setup"

# === 2. Load Rails Application ===
require_relative "config/application"

# === 3. Initialize Rails Application ===
Rails.application.initialize!

# === 4. Load Puma and Configure ===
require "puma"
require "puma/configuration"
require "puma/launcher"

# === 5. Create Puma Configuration ===
puma_config = Puma::Configuration.new do |config|
  config.bind "tcp://0.0.0.0:3000"
  config.threads 1, 3
  config.workers 0
  config.app Rails.application
end

# === 6. Start Puma Server ===
puts "==> Starting Puma server on http://0.0.0.0:3000"
launcher = Puma::Launcher.new(puma_config)
launcher.run
